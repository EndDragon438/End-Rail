-- This library provides helper functions for working  with colors.
-- 
-- Author: end draconis
-- SPDX-License-Identifier: CC-BY-4.0

--- Converts an HSV color into an RGB one.
-- @param h hue in degrees [0, 360]
-- @param s saturation [0.0, 1.0]
-- @param v value [0.0, 1.0]
-- @return {r [0, 255], g [0, 255], b [0, 255]} table
local function hsv_to_rgb(h, s, v)
    -- https://en.wikipedia.org/wiki/HSL_and_HSV#HSV_to_RGB
    local chroma = v * s
    local h2 = h / 60
    local x = chroma * (1 - math.abs(h2 % 2 - 1))
    local initial
    if h2 < 1 then
        initial = {r = chroma, g = x, b = 0}
    elseif h2 < 2 then
        initial = {r = x, g = chroma, b = 0}
    elseif h2 < 3 then
        initial = {r = 0, g = chroma, b = x}
    elseif h2 < 4 then
        initial = {r = 0, g = x, b = chroma}
    elseif h2 < 5 then
        initial = {r = x, g = 0, b = chroma}
    else
        initial = {r = chroma, g = 0, b = x}
    end
    
    local m = v - chroma
    initial.r = ((initial.r + m) * 255)
    initial.g = ((initial.g + m) * 255)
    initial.b = ((initial.b + m) * 255)
    
    return initial
end

--- Converts an RGB color into an HSV one.
-- @param r red channel [0, 255]
-- @param g green channel [0, 255]
-- @param b blue channel [0, 255]
-- @return {h [0, 360], s [0.0, 1.0], v [0.0, 1.0]} table
local function rgb_to_hsv(r, g, b)
    -- convert to [0...1]
    local r = r / 255
    local g = g / 255
    local b = b / 255
    
    -- https://en.wikipedia.org/wiki/HSL_and_HSV#From_RGB
    local xmax = math.max(r, g, b) -- also equiv to V
    local xmin = math.min(r, g, b)
    
    local chroma = xmax - xmin
    
    local hue
    if chroma == 0 then
        hue = 0
    elseif xmax == r then
        hue = 60 * (((g - b) / chroma) % 6)
    elseif xmax == g then
        hue = 60 * (((b - r) / chroma) + 2)
    else
        hue = 60 * (((r - g) / chroma) + 4)
    end
    
    local s
    if v == 0 then
        s = 0
    else
        s = chroma / xmax
    end
    
    return {h = hue, s = s, v = xmax}
end

--- Converts an XYZ color into an RGB one.
-- @param x channel [0.0, 1.0]
-- @param y channel [0.0, 1.0]
-- @param z channel [0.0, 1.0]
-- @return {r [0, 255]], g [0, 255]], b [0, 255]]} table
local function xyz_to_rgb(x, y, z)

end

--- Converts an RGB color into an XYZ one.
-- @param r red channel [0, 255]
-- @param g green channel [0, 255]
-- @param b blue channel [0, 255]
-- @return {x [0, 360], y [0.0, 1.0], z [0.0, 1.0]} table
local function rgb_to_xyz(r, g, b)

end

--- Converts a LAB color into an RGB one.
-- @param l channel [0, 100]
-- @param a channel [0.0, 1.0]
-- @param b channel [0.0, 1.0]
-- @return {r [0, 255]], g [0, 255]], b [0, 255]]} table
local function lab_to_rgb(l, a, b)

end

--- Converts an RGB color into a LAB one.
-- @param r red channel [0, 255]
-- @param g green channel [0, 255]
-- @param b blue channel [0, 255]
-- @return {l [0, 100], a [0.0, 1.0], b [0.0, 1.0]} table
local function rgb_to_lab(r, g, b)

end

return { hsv_to_rgb = hsv_to_rgb, rgb_to_hsv = rgb_to_hsv }