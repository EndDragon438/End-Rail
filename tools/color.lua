-- This library provides helper functions for working  with colors.
-- 
-- Author: end draconis
-- SPDX-License-Identifier: CC-BY-4.0

--- Check if two tables have the same keys
-- @param tb1 the first table
-- @param tb2 the second table
-- @return true if every value of tb1 is present in the keys of tb2, false otherwise
local function keyEq(tb1, tb2)
    local eq = true
    for k2, _ in pairs(tb2) do
        for _, v1 in pairs(tb1) do
            if v1 == k2 then goto continue end
        end
        eq = false
        ::continue::
    end
    return eq
end
    
--- Converts an HSV color into an RGB one.
-- @param table HSV color {h[0.0, 1.0],s[0.0, 1.0],v[0.0, 1.0]}
-- @return {r [0.0, 1.0], g [0.0, 1.0], b [0.0, 1.0]} table
local function hsv_to_rgb(t)
    -- https://en.wikipedia.org/wiki/HSL_and_HSV#HSV_to_RGB
    local chroma = t.v * t.s
    local h2 = t.h / 60 * 360
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
    
    local m = t.v - chroma
    initial.r = initial.r + m
    initial.g = initial.g + m
    initial.b = initial.b + m
    
    return initial
end

--- Converts an RGB color into an HSV one.
-- @param table RGB color {r[0.0, 1.0],g[0.0, 1.0],b[0.0, 1.0]}
-- @return {h [0.0, 1.0], s [0.0, 1.0], v [0.0, 1.0]} table
local function rgb_to_hsv(t)
    -- https://en.wikipedia.org/wiki/HSL_and_HSV#From_RGB
    local xmax = math.max(t.r, t.g, t.b) -- also equiv to V
    local xmin = math.min(t.r, t.g, t.b)
    
    local chroma = xmax - xmin
    
    local hue
    if chroma == 0 then
        hue = 0
    elseif xmax == t.r then
        hue = 60 * (((t.g - t.b) / chroma) % 6)
    elseif xmax == t.g then
        hue = 60 * (((t.b - t.r) / chroma) + 2)
    else
        hue = 60 * (((t.r - t.g) / chroma) + 4)
    end
    
    local s
    if v == 0 then
        s = 0
    else
        s = chroma / xmax
    end
    
    return {h = hue / 360, s = s, v = xmax}
end

--- Converts an XYZ color into an RGB one. Requires the matrix library as well.
-- @param table XYZ color {x[0.0, 1.0],y[0.0, 1.0],z[0.0, 1.0]}
-- @return {r [0.0, 1.0]], g [0.0, 1.0]], b [0.0, 1.0]]} table
local function xyz_to_rgb(t)
    local matrix = require("matrix")
    -- Transformation matrix we'll be using (D65). actually M-inverse but whatever
    local M = { {3.2404542, -1.5371385, -0.4985314},
                {-0.9692660, 1.8760108, 0.0415560},
                {0.0556434, -0.2040259, 1.0572252}}
    local vec = {{t.x}, {t.y}, {t.z}}
    local rgb = matrix.multiply(M, vec)
    rgb = {r = rgb[1][1], g = rgb[2][1], b = rgb[3][1]}
    
    if rgb.r > 0.0031308 then rgb.r = 1.055 * (rgb.r^(1/2.4)) - 0.055 else rgb.r = 12.92 * rgb.r end
    if rgb.g > 0.0031308 then rgb.g = 1.055 * (rgb.g^(1/2.4)) - 0.055 else rgb.g = 12.92 * rgb.g end
    if rgb.b > 0.0031308 then rgb.b = 1.055 * (rgb.b^(1/2.4)) - 0.055 else rgb.b = 12.92 * rgb.b end
    
    return {r = rgb.r, g = rgb.g, b = rgb.b}
end

--- Converts an RGB color into an XYZ one. Requires the matrix library as well.
-- @param table RGB color {r[0.0, 1.0],g[0.0, 1.0],b[0.0, 1.0]}
-- @return {x [0.0, 1.0], y [0.0, 1.0], z [0.0, 1.0]} table
local function rgb_to_xyz(t)
    local matrix = require("matrix")
    -- Transformation matrix we'll be using (D65)
    local M = {{0.4124564, 0.3575761, 0.1804375}, {0.2126729, 0.7151522, 0.0721750}, {0.0193339, 0.1191920, 0.9503041}}
    
    local im = {{t.r}, {t.g}, {t.b}}
    
    if im[1][1] <= 0.04045 then im[1][1] = im[1][1] / 12.92 else im[1][1] = ((im[1][1] + 0.055) / 1.055)^2.4 end
    if im[2][1] <= 0.04045 then im[2][1] = im[2][1] / 12.92 else im[2][1] = ((im[2][1] + 0.055) / 1.055)^2.4 end
    if im[3][1] <= 0.04045 then im[3][1] = im[3][1] / 12.92 else im[3][1] = ((im[3][1] + 0.055) / 1.055)^2.4 end
        
    local xyz = matrix.multiply(M, im)
    
    return {x = xyz[1][1], y = xyz[2][1], z = xyz[3][1]}
end

--- Converts a LAB color into an XYZ one.
-- @param table LAB color {l[0, 100],a[-128, 127],b[-128, 127]}
-- @return {x [0.0, 1.0], y [0.0, 1.0], z [0.0, 1.0]} table
local function lab_to_xyz(t)
    local ref = {x = 95.047, y = 100, z = 108.883}
    local im = {}
    im.y = (t.l + 16) / 116
    im.x = t.a / 500 + im.y
    im.z = im.y - (t.b / 200)

    if (im.x^3 > 0.008856) then im.x = im.x^3 else im.x = (im.x - (16 / 116)) / 7.787 end
    if (im.y^3 > 0.008856) then im.y = im.y^3 else im.y = (im.y - (16 / 116)) / 7.787 end
    if (im.z^3 > 0.008856) then im.z = im.z^3 else im.z = (im.z - (16 / 116)) / 7.787 end
        
    return {x = im.x * ref.x / 100, y = im.y * ref.y / 100, z = im.z * ref.z / 100}
end

--- Converts an XYZ color into a LAB one.
-- @param table XYZ color {x[0.0, 1.0],y[0.0, 1.0],z[0.0, 1.0]}
-- @return {l [0, 100], a [-128, 127], b [-128, 127]} table
local function xyz_to_lab(t)
    local ref = {x = 95.047, y = 100, z = 108.883}
    
    x = t.x / ref.x * 100
    y = t.y / ref.y * 100
    z = t.z / ref.z * 100
    
    if x > 0.008856 then x = x^(1/3) else x = (7.787 * x) + (16 / 116) end
    if y > 0.008856 then y = y^(1/3) else y = (7.787 * y) + (16 / 116) end
    if z > 0.008856 then z = z^(1/3) else z = (7.787 * z) + (16 / 116) end
        
    return {l = (116 * y) - 16, a = 500 * (x - y), b = 200 * (y - z)}
end

--- Converts a color to HSV
-- @param col table in RGB {r[0.0, 1.0],g[0.0, 1.0],b[0.0, 1.0]}, HSV {h[0.0, 1.0],s[0.0, 1.0],v[0.0, 1.0]},
--   XYZ {x[0.0, 1.0],y[0.0, 1.0],z[0.0, 1.0]}, or LAB {l[0, 100],a[-128, 127],b[-128, 127]}
-- @return {h[0, 360], s[0.0, 1.0], v[0.0, 1.0]} table
-- @raise 'Input not a recognized color'
local function hsv(col)
    if keyEq({'r', 'g', 'b'}, col) then
        return rgb_to_hsv(col)
    elseif keyEq({'h', 's', 'v'}, col) then
        return col
    elseif keyEq({'x', 'y', 'z'}, col) then
        return rgb_to_hsv(xyz_to_rgb(col))
    elseif keyEq({'l', 'a', 'b'}, col) then
        return rgb_to_hsv(lab_to_rgb(col))
    else
        error('Input not a recognized color')
    end
end

--- Converts a color to RGB
-- @param col table in RGB {r[0.0, 1.0],g[0.0, 1.0],b[0.0, 1.0]}, HSV {h[0.0, 1.0],s[0.0, 1.0],v[0.0, 1.0]},
--   XYZ {x[0.0, 1.0],y[0.0, 1.0],z[0.0, 1.0]}, or LAB {l[0, 100],a[-128, 127],b[-128, 127]}
-- @return {r[0.0, 1.0],g[0.0, 1.0],b[0.0, 1.0]} table
-- @raise 'Input not a recognized color'
local function rgb(col)
    if keyEq({'r', 'g', 'b'}, col) then
        return col
    elseif keyEq({'h', 's', 'v'}, col) then
        return hsv_to_rgb(col)
    elseif keyEq({'x', 'y', 'z'}, col) then
        return xyz_to_rgb(col)
    elseif keyEq({'l', 'a', 'b'}, col) then
        return xyz_to_rgb(lab_to_xyz(col))
    else
        error('Input not a recognized color')
    end
end

--- Converts a color to XYZ
-- @param col table in RGB {r[0.0, 1.0],g[0.0, 1.0],b[0.0, 1.0]}, HSV {h[0.0, 1.0],s[0.0, 1.0],v[0.0, 1.0]},
--   XYZ {x[0.0, 1.0],y[0.0, 1.0],z[0.0, 1.0]}, or LAB {l[0, 100],a[-128, 127],b[-128, 127]}
-- @return {x[0.0, 1.0],y[0.0, 1.0],z[0.0, 1.0]} table
-- @raise 'Input not a recognized color'
local function xyz(col)
    if keyEq({'r', 'g', 'b'}, col) then
        return rgb_to_xyz(col)
    elseif keyEq({'h', 's', 'v'}, col) then
        return rgb_to_xyz(hsv_to_rgb(col))
    elseif keyEq({'x', 'y', 'z'}, col) then
        return col
    elseif keyEq({'l', 'a', 'b'}, col) then
        return lab_to_xyz(col)
    else
        error('Input not a recognized color')
    end
end

--- Converts a color to XYZ
-- @param col table in RGB {r[0.0, 1.0],g[0.0, 1.0],b[0.0, 1.0]}, HSV {h[0.0, 1.0],s[0.0, 1.0],v[0.0, 1.0]},
--   XYZ {x[0.0, 1.0],y[0.0, 1.0],z[0.0, 1.0]}, or LAB {l[0, 100],a[-128, 127],b[-128, 127]}
-- @return {l[0, 100],a[-128, 127],b[-128, 127]} table
-- @raise 'Input not a recognized color'
local function lab(col)
    if keyEq({'r', 'g', 'b'}, col) then
        return xyz_to_lab(rgb_to_xyz(col))
    elseif keyEq({'h', 's', 'v'}, col) then
        return xyz_to_lab(rgb_to_xyz(hsv_to_rgb(col)))
    elseif keyEq({'x', 'y', 'z'}, col) then
        return xyz_to_lab(col)
    elseif keyEq({'l', 'a', 'b'}, col) then
        return col
    else
        error('Input not a recognized color')
    end
end

-- @param stops array of at least 2 color tables in RGB, HSV, XYZ, or LAB
-- @param t time factor [0.0, 1.0]
-- @return RGB color {r[0.0, 1.0],g[0.0, 1.0],b[0.0, 1.0]}
local function lerp(stops, t)
    t = t * (#stops - 1)
    
    local first = hsv(stops[math.max(1, math.floor(t) + 1)])
    local second = hsv(stops[math.min(#stops, math.ceil(t) + 1)])
    local new = {
        h = first.h + (second.h - first.h) * (t % 1),
        s = first.s + (second.s - first.s) * (t % 1),
        v = first.v + (second.v - first.v) * (t % 1)
    }
    return rgb(new)
end

return { rgb = rgb, hsv = hsv, xyz = xyz, lab = lab, lerp = lerp }