#!/bin/bash

if ! playerctl status &>/dev/null; then
  echo "\${offset 70}\${voffset 50}\${font1}No active media player"
  exit 0
fi

shorten() {
  local text="$1"
  local maxlen=24
  if (( ${#text} > maxlen )); then
    echo "${text:0:maxlen}..."
  else
    echo "$text"
  fi
}

IFS='|' read -r status title artist album arturl <<< "$(playerctl metadata --format '{{status}}|{{title}}|{{artist}}|{{album}}|{{mpris:artUrl}}')"

echo -e "\${offset 100}\${voffset 10}\${font1}STATUS: \${font}${status^^}\n"
echo "\${offset 100}\${voffset -10}\${font1}Track: \${font}$(shorten "$title")"
echo "\${offset 100}\${font1}Artist: \${font}$(shorten "$artist")"
echo "\${offset 100}\${font1}Album: \${font}$(shorten "$album")"

# Download cover only if URL is not empty and has changed
if [[ -n "$arturl" ]]; then
  if [[ ! -f /tmp/conky_cover.jpg ]] || [[ "$(cat /tmp/conky_cover.url 2>/dev/null)" != "$arturl" ]]; then
    curl -s "$arturl" -o /tmp/conky_cover.jpg
    echo "$arturl" > /tmp/conky_cover.url
  fi
  echo "\${image /tmp/conky_cover.jpg -p 5,10 -s 80x80 -n}"
fi