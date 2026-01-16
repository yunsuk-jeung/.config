
DIR=$(osascript -e 'tell application "Finder"
  if (count of windows) is 0 then
    return POSIX path of (desktop as alias)
  else
    return POSIX path of (target of front window as alias)
  end if
end tell')

open -na "/Applications/kitty.app" --args --directory "$DIR"
