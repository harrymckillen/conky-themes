-- Conky Orange ------------------------
-- 
-- Derived from the Conky Grey script, and 
-- modified
-- 
----------------------------------------
require 'cairo'

--- configurable variables
local base_colour = 0x62bb51 -- green
local base_hand_fg_colour = 0x000000 -- black
local base_graph_thickness = 5

local graph_radius = 80
local graph_x_coord = 450
local graph_y_coord = 230

local line_colour = base_colour
local line_alpha = 0.75

local filesystem = '/' -- root filesystem

local segment_thickness = 3.6


--------------------------------------------------------------------------------
--                                                                    gauge DATA
gauge = {
{
    name='nvidia',           arg='gpuutil',                     max_value=100,
    x=graph_x_coord,                          y=graph_y_coord,
    graph_radius=graph_radius+50,
    graph_thickness=base_graph_thickness*4,
    graph_start_angle=225,
    graph_unit_angle=segment_thickness,          graph_unit_thickness=segment_thickness,
    graph_bg_colour=base_colour,      graph_bg_alpha=0.1,
    graph_fg_colour=base_colour,      graph_fg_alpha=0.8,
    hand_fg_colour=base_hand_fg_colour,       hand_fg_alpha=0.0,
    txt_radius=graph_radius-10,
    txt_weight=0,                  txt_size=8.0,
    txt_fg_colour=base_colour,        txt_fg_alpha=0,
    graduation_radius=218,
    graduation_thickness=0,        graduation_mark_thickness=1,
    graduation_unit_angle=27,
    graduation_fg_colour=base_colour, graduation_fg_alpha=0.3,
    caption='',
    caption_weight=1,              caption_size=8.0,
    caption_fg_colour=base_colour,    caption_fg_alpha=0.5,
},
{
    name='cpu',                    arg='',                  max_value=100,
    x=graph_x_coord,                          y=graph_y_coord,
    graph_radius=graph_radius+25,
    graph_thickness=base_graph_thickness*4,
    graph_start_angle=15,
    graph_unit_angle=segment_thickness,          graph_unit_thickness=segment_thickness,
    graph_bg_colour=base_colour,      graph_bg_alpha=0.1,
    graph_fg_colour=base_colour,      graph_fg_alpha=0.8,
    hand_fg_colour=base_hand_fg_colour,       hand_fg_alpha=0.0,
    txt_radius=graph_radius-20,
    txt_weight=0,                  txt_size=12.0,
    txt_fg_colour=base_colour,        txt_fg_alpha=0,
    graduation_radius=graph_radius-20,
    graduation_thickness=0,        graduation_mark_thickness=1,
    graduation_unit_angle=17,
    graduation_fg_colour=base_colour, graduation_fg_alpha=0.3,
    caption='',
    caption_weight=1,              caption_size=12.0,
    caption_fg_colour=base_colour,    caption_fg_alpha=0.8,
},
{
    name='memperc',                arg='',                      max_value=100,
    x=graph_x_coord,                           y=graph_y_coord,
    graph_radius=graph_radius,
    graph_thickness=base_graph_thickness*4,
    graph_start_angle=310,
    graph_unit_angle=segment_thickness,          graph_unit_thickness=segment_thickness,
    graph_bg_colour=base_colour,      graph_bg_alpha=0.1,
    graph_fg_colour=base_colour,      graph_fg_alpha=0.8,
    hand_fg_colour=base_hand_fg_colour,       hand_fg_alpha=0.0,
    txt_radius=graph_radius-13,
    txt_weight=0,                  txt_size=8.0,
    txt_fg_colour=base_colour,        txt_fg_alpha=0,
    graduation_radius=graph_radius,
    graduation_thickness=0,        graduation_mark_thickness=2,
    graduation_unit_angle=27,
    graduation_fg_colour=base_colour, graduation_fg_alpha=0.5,
    caption='',
    caption_weight=1,              caption_size=8.0,
    caption_fg_colour=base_colour,    caption_fg_alpha=0.3,
},
}

-------------------------------------------------------------------------------
--                                                                 rgb_to_r_g_b
-- converts color in hexa to decimal
--
function rgb_to_r_g_b(colour, alpha)
    return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end

-------------------------------------------------------------------------------
--                                                            angle_to_position
-- convert degree to rad and rotate (0 degree is top/north)
--
function angle_to_position(start_angle, current_angle)
    local pos = current_angle + start_angle
    return ( ( pos * (2 * math.pi / 360) ) - (math.pi / 2) )
end

-------------------------------------------------------------------------------
--                                                              draw_gauge_ring
-- displays gauges
--
function draw_gauge_ring(display, data, value)
    local max_value = data['max_value']
    local x, y = data['x'], data['y']
    local graph_radius = data['graph_radius']
    local graph_thickness, graph_unit_thickness = data['graph_thickness'], data['graph_unit_thickness']
    local graph_start_angle = data['graph_start_angle']
    local graph_unit_angle = data['graph_unit_angle']
    local graph_bg_colour, graph_bg_alpha = data['graph_bg_colour'], data['graph_bg_alpha']
    local graph_fg_colour, graph_fg_alpha = data['graph_fg_colour'], data['graph_fg_alpha']
    local hand_fg_colour, hand_fg_alpha = data['hand_fg_colour'], data['hand_fg_alpha']
    local graph_end_angle = 360
    -- local graph_end_angle = (max_value * graph_unit_angle) % 360

    -- background ring
    cairo_arc(display, x, y, graph_radius, angle_to_position(graph_start_angle, 0), angle_to_position(graph_start_angle, graph_end_angle))
    cairo_set_source_rgba(display, rgb_to_r_g_b(graph_bg_colour, graph_bg_alpha))
    cairo_set_line_width(display, graph_thickness)
    cairo_stroke(display)

    -- arc of value
    local val = value % (max_value + 1)
    local start_arc = 0
    local stop_arc = 0
    local i = 1
    while i <= val do
        start_arc = (graph_unit_angle * i) - graph_unit_thickness
        stop_arc = (graph_unit_angle * i)
        cairo_arc(display, x, y, graph_radius, angle_to_position(graph_start_angle, start_arc), angle_to_position(graph_start_angle, stop_arc))
        cairo_set_source_rgba(display, rgb_to_r_g_b(graph_fg_colour, graph_fg_alpha))
        cairo_stroke(display)
        i = i + 1
    end
    local angle = start_arc

    -- hand
    start_arc = (graph_unit_angle * val) - (graph_unit_thickness * 2)
    stop_arc = (graph_unit_angle * val)
    cairo_arc(display, x, y, graph_radius, angle_to_position(graph_start_angle, start_arc), angle_to_position(graph_start_angle, stop_arc))
    cairo_set_source_rgba(display, rgb_to_r_g_b(hand_fg_colour, hand_fg_alpha))
    cairo_stroke(display)

    -- graduations marks
    local graduation_radius = data['graduation_radius']
    local graduation_thickness, graduation_mark_thickness = data['graduation_thickness'], data['graduation_mark_thickness']
    local graduation_unit_angle = data['graduation_unit_angle']
    local graduation_fg_colour, graduation_fg_alpha = data['graduation_fg_colour'], data['graduation_fg_alpha']
    if graduation_radius > 0 and graduation_thickness > 0 and graduation_unit_angle > 0 then
        local nb_graduation = graph_end_angle / graduation_unit_angle
        local i = 0
        while i < nb_graduation do
            cairo_set_line_width(display, graduation_thickness)
            start_arc = (graduation_unit_angle * i) - (graduation_mark_thickness / 2)
            stop_arc = (graduation_unit_angle * i) + (graduation_mark_thickness / 2)
            cairo_arc(display, x, y, graduation_radius, angle_to_position(graph_start_angle, start_arc), angle_to_position(graph_start_angle, stop_arc))
            cairo_set_source_rgba(display,rgb_to_r_g_b(graduation_fg_colour,graduation_fg_alpha))
            cairo_stroke(display)
            cairo_set_line_width(display, graph_thickness)
            i = i + 1
        end
    end

    -- text
    local txt_radius = data['txt_radius']
    local txt_weight, txt_size = data['txt_weight'], data['txt_size']
    local txt_fg_colour, txt_fg_alpha = data['txt_fg_colour'], data['txt_fg_alpha']
    local movex = txt_radius * math.cos(angle_to_position(graph_start_angle, angle))
    local movey = txt_radius * math.sin(angle_to_position(graph_start_angle, angle))
    cairo_select_font_face (display, "ubuntu", CAIRO_FONT_SLANT_NORMAL, txt_weight)
    cairo_set_font_size (display, txt_size)
    cairo_set_source_rgba (display, rgb_to_r_g_b(txt_fg_colour, txt_fg_alpha))
    cairo_move_to (display, x + movex - (txt_size / 2), y + movey + 3)
    cairo_show_text (display, value)
    cairo_stroke (display)

    -- caption
    local caption = data['caption']
    local caption_weight, caption_size = data['caption_weight'], data['caption_size']
    local caption_fg_colour, caption_fg_alpha = data['caption_fg_colour'], data['caption_fg_alpha']
    local tox = graph_radius * (math.cos((graph_start_angle * 2 * math.pi / 360)-(math.pi/2)))
    local toy = graph_radius * (math.sin((graph_start_angle * 2 * math.pi / 360)-(math.pi/2)))
    cairo_select_font_face (display, "ubuntu", CAIRO_FONT_SLANT_NORMAL, caption_weight);
    cairo_set_font_size (display, caption_size)
    cairo_set_source_rgba (display, rgb_to_r_g_b(caption_fg_colour, caption_fg_alpha))
    cairo_move_to (display, x + tox + 5, y + toy + 1)
    -- bad hack but not enough time !
    if graph_start_angle < 105 then
        cairo_move_to (display, x + tox - 30, y + toy + 1)
    end
    cairo_show_text (display, caption)
    cairo_stroke (display)
end

-------------------------------------------------------------------------------
--                                                               go_gauge_rings
-- loads data and displays gauges
--
function go_gauge_rings(display)
    local function load_gauge_rings(display, data)
        local str, value = '', 0
        str = string.format('${%s %s}',data['name'], data['arg'])
        str = conky_parse(str)
        value = tonumber(str)
        draw_gauge_ring(display, data, value)
    end
    
    for i in pairs(gauge) do
        load_gauge_rings(display, gauge[i])
    end
end

function draw_line(display, sx, sy, ex, ey)
    line_width = 2
    -- line_cap = CAIRO_LINE_CAP_SQUARE
    line_cap = CAIRO_LINE_CAP_BUTT

    cairo_set_line_width (display, line_width)
    cairo_set_line_cap  (display, line_cap)
    cairo_set_source_rgba (display, rgb_to_r_g_b(line_colour, line_alpha))
    cairo_move_to (display, sx, sy)
    cairo_line_to (display, ex, ey)
    cairo_stroke (display)
end 

function draw_lines(display)
    -- cpu line
    draw_line(display, 595, 20, 482, 128)
    draw_line(display, 595, 20, 835, 20)
    
    -- gpu line
    draw_line(display, 75, 300, 270, 300)
    draw_line(display, 270, 300, 322, 250)

    -- ram line 
    draw_line(display, 75, 20, 250, 20)
    draw_line(display, 250, 20, 398, 168) 
end

-------------------------------------------------------------------------------
--                                                                         MAIN
function conky_main()
    if conky_window == nil then 
        return
    end

    local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
    local display = cairo_create(cs)
    
    local updates = conky_parse('${updates}')
    update_num = tonumber(updates)
    
    if update_num > 5 then
        go_gauge_rings(display)
        draw_lines(display)
        
    end
    
    cairo_surface_destroy(cs)
    cairo_destroy(display)
end

