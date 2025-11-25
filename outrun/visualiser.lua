require 'cairo'

-- Color definitions
local pink = {254/255, 62/255, 145/255, 1}
local pink_dim = {254/255, 62/255, 145/255, 0.25}
local bar_style = "lcd" -- options: "solid", "lcd"

function read_8bit_values(filename, count)
  local values = {}
  local f = io.open(filename, "rb")
  if f then
      for i = 1, count do
          local byte = f:read(1)
          if not byte then break end
          table.insert(values, string.byte(byte) or 0)
      end
      f:close()
  end
  return values
end

function draw_bars(cr, freq_values, prev_bar_heights, bar_count)
  local bar_width = 14
  local bar_spacing = 6
  local max_bar_height = 90 -- max height for the bar
  local base_y = 115         -- y position for the bottom of the bars
  local smoothing = 1 -- Animation smoothing factor (0.0 = no smoothing, 1.0 = full smoothing)

  for i, v in ipairs(freq_values) do
      local target_height = (v / 255) * max_bar_height
      local prev_height = prev_bar_heights[i] or target_height
      local bar_height = prev_height + (target_height - prev_height) * smoothing
      prev_bar_heights[i] = bar_height

      local x = 363 + (i - 1) * (bar_width + bar_spacing)
      local y = base_y - bar_height
      cairo_rectangle(cr, x, y, bar_width, bar_height)
      cairo_set_source_rgba(cr, table.unpack(pink))
      cairo_fill(cr)
  end
end

function draw_lcd_bars(cr, freq_values, bar_count)
  local bar_width = 16
  local bar_spacing = 4
  local segment_height = 3
  local segment_spacing = 2
  local segments_per_bar = 19
  local base_y = 115
  local x_start = 362

  for i, v in ipairs(freq_values) do
      local x = x_start + (i - 1) * (bar_width + bar_spacing)
      -- Calculate how many segments to light up
      local lit_segments = math.floor((v / 255) * segments_per_bar + 0.5)
      for seg = 1, segments_per_bar do
          local y = base_y - seg * (segment_height + segment_spacing)
          -- Set color: lit segments are pink, others are dark
          if seg <= lit_segments then
              cairo_set_source_rgba(cr, table.unpack(pink))
          else
              cairo_set_source_rgba(cr, 0.2, 0.2, 0.2, 0.5)
          end
          -- Draw rounded rectangle segment
          draw_rounded_rect(cr, x, y, bar_width, segment_height, 3)
          cairo_fill(cr)
      end
  end
end

-- Helper function for rounded rectangles
function draw_rounded_rect(cr, x, y, w, h, r)
  cairo_move_to(cr, x + r, y)
  cairo_line_to(cr, x + w - r, y)
  cairo_arc(cr, x + w - r, y + r, r, -math.pi/2, 0)
  cairo_line_to(cr, x + w, y + h - r)
  cairo_arc(cr, x + w - r, y + h - r, r, 0, math.pi/2)
  cairo_line_to(cr, x + r, y + h)
  cairo_arc(cr, x + r, y + h - r, r, math.pi/2, math.pi)
  cairo_line_to(cr, x, y + r)
  cairo_arc(cr, x + r, y + r, r, math.pi, 3*math.pi/2)
  cairo_close_path(cr)
end

function conky_main()
    if conky_window == nil then return end

    local width, height = conky_window.width, conky_window.height
    local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, width, height)
    local cr = cairo_create(cs)

    local bar_count = 10 -- match your cava config
    local prev_bar_heights = {}
    local freq_values = read_8bit_values("/tmp/cava.txt", bar_count)

    cairo_rectangle(cr, 360, 15, 200, 100)
    cairo_set_source_rgba(cr, table.unpack(pink_dim)) -- pink dim
    cairo_stroke(cr)

    if bar_style == "solid" then
        draw_bars(cr, freq_values, prev_bar_heights, bar_count)
    elseif bar_style == "lcd" then  
        draw_lcd_bars(cr, freq_values, bar_count)
    end
    cairo_surface_destroy(cs)
    cairo_destroy(cr)
end