#!/bin/bash

if ! playerctl status &>/dev/null; then
  echo "\${offset 70}\${voffset 50}\${font1}No active media player"
  exit 0
fi

shorten() {
  local text="$1"
  local maxlen=22
  if (( ${#text} > maxlen )); then
    echo "${text:0:maxlen}..."
  else
    echo "$text"
  fi
}

IFS='|' read -r status title artist album arturl <<< "$(playerctl metadata --format '{{status}}|{{title}}|{{artist}}|{{album}}|{{mpris:artUrl}}')"

offset=10
if [[ -n "$arturl" ]]; then
  offset=116
fi

echo -e "\${offset $offset}\${voffset 12}\${font1}STATUS: \${font}${status^^}\n"
echo "\${offset $offset}\${voffset -10}\${font1}Track: \${font}$(shorten "${title:-Unknown}")"
echo "\${offset $offset}\${font1}Artist: \${font}$(shorten "${artist:-Unknown}")"
echo "\${offset $offset}\${font1}Album: \${font}$(shorten "${album:-Unknown}")\${voffset -10}"

# Download cover only if URL is not empty and has changed
if [[ -n "$arturl" ]]; then
  if [[ ! -f /tmp/conky_cover.jpg ]] || [[ "$(cat /tmp/conky_cover.url 2>/dev/null)" != "$arturl" ]]; then
    curl -s "$arturl" -o /tmp/conky_cover.jpg
    echo "$arturl" > /tmp/conky_cover.url
  fi
  echo "\${image /tmp/conky_cover.jpg -p 3,2 -s 100x100 -n}"
fi