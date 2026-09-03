#!/usr/bin/env python3
"""Patch a monochrome NAVER Whale glyph into sketchybar-app-font at U+E000.

The upstream font has no whale icon (checked through v2.0.83), so we trace the
silhouette out of Whale.app's own .icns and inject it as a real glyph. Living
in the font itself -- rather than relying on CoreText fallback to another font
-- is what keeps it the same size and weight as :docker:, :kitty: and friends.

Re-run this after upgrading sketchybar-app-font; an upgrade overwrites the
patched .ttf. Requires: pip3 install fonttools pillow
"""
import os, subprocess, sys, tempfile
from PIL import Image
from fontTools.ttLib import TTFont
from fontTools.pens.ttGlyphPen import TTGlyphPen

FONT   = os.path.expanduser("~/Library/Fonts/sketchybar-app-font.ttf")
ICNS   = "/Applications/Whale.app/Contents/Resources/app.icns"
CODEPOINT = 0xE000
GLYPH  = "naver_whale"
EPS    = 1.0          # Douglas-Peucker tolerance, in 1024px source pixels
TARGET_H = 709        # median height of the font's wide (aspect>1.2) icons
CENTER_Y = 500        # every icon in this font is centred on y=500
SIDE_PAD = 412        # :docker: advance(1411) - bbox width(999)
EYE_SCALE = 2.7       # the traced eye is ~1px at 16pt -- enlarge so it reads

def whale_mask(tmp):
    png = os.path.join(tmp, "icon.png")
    subprocess.run(["sips", "-s", "format", "png", ICNS, "--out", png],
                   check=True, capture_output=True)
    im = Image.open(png).convert("RGBA").resize((1024, 1024))
    w, h = im.size; px = im.load()
    m = Image.new("L", (w, h), 0); mp = m.load()
    for y in range(h):
        for x in range(w):
            r, g, b, a = px[x, y]
            if a < 128: continue
            if (g > 110 and g >= b * .75 and r < 170) or (r > 185 and g > 195 and b > 195):
                mp[x, y] = 255
    return m, w, h

def largest_component(m, w, h):
    p = m.load(); seen = [[False]*w for _ in range(h)]; best = []
    for y in range(h):
        for x in range(w):
            if p[x, y] == 255 and not seen[y][x]:
                st = [(x, y)]; seen[y][x] = True; comp = []
                while st:
                    cx, cy = st.pop(); comp.append((cx, cy))
                    for dx, dy in ((1,0),(-1,0),(0,1),(0,-1)):
                        nx, ny = cx+dx, cy+dy
                        if 0 <= nx < w and 0 <= ny < h and not seen[ny][nx] and p[nx,ny] == 255:
                            seen[ny][nx] = True; st.append((nx, ny))
                if len(comp) > len(best): best = comp
    out = Image.new("L", (w, h), 0); op = out.load()
    for cx, cy in best: op[cx, cy] = 255
    return out

def drop_specks(m, w, h):
    """Fill every interior hole except the largest one (the eye)."""
    p = m.load(); filled = lambda x, y: 0 <= x < w and 0 <= y < h and p[x, y] > 127
    seen = [[False]*w for _ in range(h)]; holes = []
    for y in range(h):
        for x in range(w):
            if not filled(x, y) and not seen[y][x]:
                st = [(x, y)]; seen[y][x] = True; comp = []; edge = False
                while st:
                    cx, cy = st.pop(); comp.append((cx, cy))
                    if cx in (0, w-1) or cy in (0, h-1): edge = True
                    for dx, dy in ((1,0),(-1,0),(0,1),(0,-1)):
                        nx, ny = cx+dx, cy+dy
                        if 0 <= nx < w and 0 <= ny < h and not seen[ny][nx] and not filled(nx, ny):
                            seen[ny][nx] = True; st.append((nx, ny))
                if not edge: holes.append(comp)
    holes.sort(key=len, reverse=True)
    for c in holes[1:]:
        for cx, cy in c: p[cx, cy] = 255
    return m

def contours(m, w, h):
    p = m.load(); filled = lambda x, y: 0 <= x < w and 0 <= y < h and p[x, y] > 127
    e = {}
    for y in range(h):
        for x in range(w):
            if not filled(x, y): continue
            if not filled(x, y-1): e.setdefault((x, y),     []).append((x+1, y))
            if not filled(x+1, y): e.setdefault((x+1, y),   []).append((x+1, y+1))
            if not filled(x, y+1): e.setdefault((x+1, y+1), []).append((x, y+1))
            if not filled(x-1, y): e.setdefault((x, y+1),   []).append((x, y))
    loops = []
    while e:
        start = next(iter(e)); loop = [start]; cur = start
        while True:
            nxt = e.get(cur)
            if not nxt: break
            n = nxt.pop()
            if not nxt: del e[cur]
            loop.append(n); cur = n
            if cur == start: break
        if len(loop) > 8: loops.append(loop)
    return sorted(loops, key=len, reverse=True)[:2]

def dp(pts, eps):
    if len(pts) < 3: return pts
    ax, ay = pts[0]; bx, by = pts[-1]; dx, dy = bx-ax, by-ay
    n = (dx*dx + dy*dy) ** .5 or 1e-9; best = 0; idx = 0
    for i, (x, y) in enumerate(pts[1:-1], 1):
        d = abs(dy*x - dx*y + bx*ay - by*ax) / n
        if d > best: best = d; idx = i
    if best > eps: return dp(pts[:idx+1], eps)[:-1] + dp(pts[idx:], eps)
    return [pts[0], pts[-1]]

def dp_closed(loop, eps):
    pts = loop[:-1] if loop[0] == loop[-1] else loop[:]
    a = pts[0]
    far = max(range(len(pts)), key=lambda i: (pts[i][0]-a[0])**2 + (pts[i][1]-a[1])**2)
    return dp(pts[:far+1], eps)[:-1] + dp(pts[far:] + [pts[0]], eps)[:-1]

def area(c):
    return sum(c[i][0]*c[(i+1) % len(c)][1] - c[(i+1) % len(c)][0]*c[i][1]
               for i in range(len(c))) / 2.0

def main():
    if not os.path.exists(ICNS): sys.exit(f"missing {ICNS}")
    sys.setrecursionlimit(100000)
    with tempfile.TemporaryDirectory() as tmp:
        m, w, h = whale_mask(tmp)
        m = drop_specks(largest_component(m, w, h), w, h)
        cs = [dp_closed(l, EPS) for l in contours(m, w, h)]

    xs = [x for x, _ in cs[0]]; ys = [y for _, y in cs[0]]
    x0, x1, y0, y1 = min(xs), max(xs), min(ys), max(ys)
    scale = TARGET_H / (y1 - y0)
    # Every icon in this font is centred on y=500 (median of all 657 glyphs is
    # exactly 500). :docker: is an outlier at 356 -- do not copy it, or the
    # glyph visibly sits low next to :kitty: and the rest.
    y_off = CENTER_Y - TARGET_H / 2.0
    # image y grows downward, font y grows upward -> flip
    tx = lambda pt: (round((pt[0]-x0)*scale), round((y1-pt[1])*scale + y_off))
    cs = [[tx(p) for p in c] for c in cs]

    # The eye traces out at ~7% of the glyph height, which is about one pixel
    # once the bar renders it at 16pt -- it just disappears. Enlarge it about
    # its own centroid so the shape still reads as an animal at that size.
    if len(cs) > 1:
        ex = sum(p[0] for p in cs[1]) / len(cs[1])
        ey = sum(p[1] for p in cs[1]) / len(cs[1])
        cs[1] = [(round(ex + (x-ex)*EYE_SCALE), round(ey + (y-ey)*EYE_SCALE))
                 for x, y in cs[1]]

    # TrueType non-zero winding: outer clockwise (negative area, y-up), hole opposite
    if area(cs[0]) > 0: cs[0].reverse()
    if len(cs) > 1 and area(cs[1]) < 0: cs[1].reverse()

    pen = TTGlyphPen(None)
    for c in cs:
        pen.moveTo(c[0])
        for pt in c[1:]: pen.lineTo(pt)
        pen.closePath()
    glyph = pen.glyph()

    font = TTFont(FONT)
    if GLYPH in font.getGlyphOrder(): sys.exit(f"{GLYPH} already present -- restore the .orig first")
    glyph.recalcBounds(font["glyf"])
    font["glyf"].glyphs[GLYPH] = glyph
    font.setGlyphOrder(font.getGlyphOrder() + [GLYPH])
    font["glyf"].glyphOrder = font.getGlyphOrder()
    font["hmtx"].metrics[GLYPH] = (round((x1-x0)*scale) + SIDE_PAD, 0)
    # format 0 subtables only address 0..255 -- skip them or compile() asserts
    added = 0
    for t in font["cmap"].tables:
        if t.format == 0:
            continue
        t.cmap[CODEPOINT] = GLYPH
        added += 1
    if not added:
        sys.exit("no cmap subtable could hold the codepoint")
    font.save(FONT)
    print(f"patched {FONT}: {GLYPH} at U+{CODEPOINT:04X}, "
          f"bbox={glyph.xMin},{glyph.yMin},{glyph.xMax},{glyph.yMax}, "
          f"points={[len(c) for c in cs]}")

if __name__ == "__main__":
    main()
