-- This library provides helper functions for working  with colors.
-- 
-- Author: end draconis
-- SPDX-License-Identifier: CC-BY-4.0

--- Converts an HSV color into an RGB one.
-- @param h hue in degrees [0, 360]
-- @param s saturation [0.0, 1.0]
-- @param v value [0.0, 1.0]
-- @return {r [0.0, 1.0], g [0.0, 1.0], b [0.0, 1.0]} table
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
    initial.r = initial.r + m
    initial.g = initial.g + m
    initial.b = initial.b + m
    
    return initial
end

--- Converts an RGB color into an HSV one.
-- @param r red channel [0.0, 1.0]
-- @param g green channel [0.0, 1.0]
-- @param b blue channel [0.0, 1.0]
-- @return {h [0, 360], s [0.0, 1.0], v [0.0, 1.0]} table
local function rgb_to_hsv(r, g, b)
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

--- Converts an XYZ color into an RGB one. Requires the matrix library as well.
-- @param x channel [0.0, 1.0]
-- @param y channel [0.0, 1.0]
-- @param z channel [0.0, 1.0]
-- @return {r [0.0, 1.0]], g [0.0, 1.0]], b [0.0, 1.0]]} table
local function xyz_to_rgb(x, y, z)
    local matrix = require("matrix")
    -- Transformation matrix we'll be using (D65). actually M-inverse but whatever
    local M = { {3.2404542, -1.5371385, -0.4985314},
                {-0.9692660, 1.8760108, 0.0415560},
                {0.0556434, -0.2040259, 1.0572252}}
    local vec = {{x}, {y}, {z}}
    local rgb = matrix.multiply(M, vec)
    rgb = {r = rgb[1][1], g = rgb[2][1], b = rgb[3][1]}
    
    if rgb.r > 0.0031308 then rgb.r = 1.055 * (rgb.r^(1/2.4)) - 0.055 else rgb.r = 12.92 * rgb.r end
    if rgb.g > 0.0031308 then rgb.g = 1.055 * (rgb.g^(1/2.4)) - 0.055 else rgb.g = 12.92 * rgb.g end
    if rgb.b > 0.0031308 then rgb.b = 1.055 * (rgb.b^(1/2.4)) - 0.055 else rgb.b = 12.92 * rgb.b end
    
    return {r = rgb.r, g = rgb.g, b = rgb.b}
end

--- Converts an RGB color into an XYZ one. Requires the matrix library as well.
-- @param r red channel [0.0, 1.0]
-- @param g green channel [0.0, 1.0]
-- @param b blue channel [0.0, 1.0]
-- @return {x [0.0, 1.0], y [0.0, 1.0], z [0.0, 1.0]} table
local function rgb_to_xyz(r, g, b)
    local matrix = require("matrix")
    -- Transformation matrix we'll be using (D65)
    local M = {{0.4124564, 0.3575761, 0.1804375}, {0.2126729, 0.7151522, 0.0721750}, {0.0193339, 0.1191920, 0.9503041}}
    
    local im = {{r}, {g}, {b}}
    
    if im[1][1] <= 0.04045 then im[1][1] = im[1][1] / 12.92 else im[1][1] = ((im[1][1] + 0.055) / 1.055)^2.4 end
    if im[2][1] <= 0.04045 then im[2][1] = im[2][1] / 12.92 else im[2][1] = ((im[2][1] + 0.055) / 1.055)^2.4 end
    if im[3][1] <= 0.04045 then im[3][1] = im[3][1] / 12.92 else im[3][1] = ((im[3][1] + 0.055) / 1.055)^2.4 end
        
    local xyz = matrix.multiply(M, im)
    
    return {x = xyz[1][1], y = xyz[2][1], z = xyz[3][1]}
end

--- Converts a LAB color into an XYZ one.
-- @param l lightness channel [0, 100]
-- @param a channel [-128, 127]
-- @param b channel [-128, 127]
-- @return {x [0.0, 1.0], y [0.0, 1.0], z [0.0, 1.0]} table
local function lab_to_xyz(l, a, b)
    local ref = {x = 95.047, y = 100, z = 108.883}
    local im = {}
    im.y = (l + 16) / 116
    im.x = a / 500 + im.y
    im.z = im.y - (b / 200)

    if (im.x^3 > 0.008856) then im.x = im.x^3 else im.x = (im.x - (16 / 116)) / 7.787 end
    if (im.y^3 > 0.008856) then im.y = im.y^3 else im.y = (im.y - (16 / 116)) / 7.787 end
    if (im.z^3 > 0.008856) then im.z = im.z^3 else im.z = (im.z - (16 / 116)) / 7.787 end
        
    return {x = im.x * ref.x / 100, y = im.y * ref.y / 100, z = im.z * ref.z / 100}
end

--- Converts an XYZ color into a LAB one.
-- @param x channel [0.0, 1.0]
-- @param y channel [0.0, 1.0]
-- @param z channel [0.0, 1.0]
-- @return {l [0, 100], a [-128, 127], b [-128, 127]} table
local function xyz_to_lab(x, y, z)
    local ref = {x = 95.047, y = 100, z = 108.883}
    
    x = x / ref.x
    y = y / ref.y
    z = z / ref.z
    
    if x > 0.008856 then x = x^(1/3) else x = (7.787 * x) + (16 / 116) end
    if y > 0.008856 then y = y^(1/3) else y = (7.787 * y) + (16 / 116) end
    if z > 0.008856 then z = z^(1/3) else z = (7.787 * z) + (16 / 116) end
        
    return {l = (116 * y) - 16, a = 500 * (x - y), b = 200 * (y - z)}
end

--- Converts a LAB color into an RGB one.
-- @param l lightness channel [0, 100]
-- @param a channel [-128, 127]
-- @param b channel [-128, 127]
-- @return {r [0.0, 1.0]], g [0.0, 1.0]], b [0.0, 1.0]]} table
local function lab_to_rgb(l, a, b)
    local xyz = lab_to_xyz(l, a, b)
    return xyz_to_rgb(xyz.x, xyz.y, xyz.z)
end

--- Converts an RGB color into a LAB one.
-- @param r red channel [0.0, 1.0]
-- @param g green channel [0.0, 1.0]
-- @param b blue channel [0.0, 1.0]
-- @return {l [0, 100], a [-128, 127], b [-128, 127]} table
local function rgb_to_lab(r, g, b)
    local xyz = rgb_to_xyz(r, g, b)
    return xyz_to_lab(xyz.x, xyz.y, xyz.z)
end

return { hsv_to_rgb = hsv_to_rgb, rgb_to_hsv = rgb_to_hsv, xyz_to_rgb = xyz_to_rgb, rgb_to_xyz = rgb_to_xyz, lab_to_xyz = lab_to_xyz, xyz_to_lab = xyz_to_lab, lab_to_rgb = lab_to_rgb, rgb_to_lab = rgb_to_lab }