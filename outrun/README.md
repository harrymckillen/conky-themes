# Outrun

A Retro 80's influenced theme

It displays the main info on RAM, CPU and GPU. You can always extend this to add the details you want.

There is also a widget which displays the currently playing track information, as well as an audio visualizer. I have really only tested with Spotify, though as it uses `playerctl` which itself utilises the MPRIS interface, it should ideally work with others. Maybe the artwork might not look great.

## Pre-requisites

- Assumes you already have `conky` and `cairo` packages installed
- Install necessary fonts from the `fonts/` directory.
- Install `playerctl`, instructions [from here](https://github.com/altdesktop/playerctl).
- Install `cava` (relied upon by the audio visualiser), instructions [from here](https://github.com/karlstav/cava).

## Installation

- Download git repo, and navigate to `outrun` directory. Ensure `start.sh` is executable.
- You can place the path to the `start.sh` script in your startup applications for example

## Configuration

- You can change the colours etc.
- For the audio visualiser, there are two styles, `solid` or `lcd`. See the theme example for a view of `lcd` style.

## Example

![Outrun](theme.png "Outrun")

### Future plans

Add weather and a bit more info
