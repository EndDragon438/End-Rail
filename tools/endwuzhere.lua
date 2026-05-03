-- hi there :3

local color = require("color")
local monitor = peripheral.find("monitor")
local args = {...}
local w, h = monitor.getSize()

local text = "end wuz here"

local function strMult(str, mult)
    local temp = str
    while mult > 1 do
        temp = temp .. str
        mult = mult - 1
    end
    return temp
end

-- @param stops array of at least 2 HSV colors {h, s, v}
-- @param t time factor [0.0, 1.0]
-- @return HSV color {h, s, v}
local function lerp(stops, t)
    t = t * (#stops - 1)

    local first = stops[math.floor(t) + 1]
    local second = stops[math.ceil(t) + 1]

    return {
        h = first.h + (second.h - first.h) * (t % 1),
        s = first.s + (second.s - first.s) * (t % 1),
        v = first.v + (second.v - first.v) * (t % 1)
    }
end

local function main()
    print("hehehehehe")
    print("hold Ctrl+T to terminate")
    
    monitor.setCursorPos((w - #text) / 2, 1)
    monitor.setBackgroundColor(colors.red)
    monitor.setTextColor(colors.blue)
    
    local gradients = {
        rainbow = {
            {h = 0, s = 1, v = 1},
            {h = 60, s = 1, v = 1},
            {h = 115, s = 1, v = 1},
            {h = 240, s = 1, v = 1},
            {h = 360, s = 1, v = 1}
        },
        trans = {
            {h = 196, s = .63, v = 98},
            {h = 348, s = .31, v = 96},
            {h = 0, s = 0, v = 1}
        }
    }

    local time = 0
    local height = 1
    while true do
        os.sleep(0.05)
        monitor.clear()
        monitor.setCursorPos((w - #text) / 2, height)
        
        local col = lerp(gradients[args[1]] or gradients.rainbow, time)
        local bgCol = color.hsv_to_rgb(col.h, col.s, col.v)
        local txtCol = color.hsv_to_rgb((col.h + 180) % 360, col.s, col.v)
        
        monitor.setPaletteColor(colors.red, colors.packRGB(bgCol.r, bgCol.g, bgCol.b))
        monitor.setPaletteColor(colors.blue, colors.packRGB(txtCol.r, txtCol.g, txtCol.b))
        
        monitor.write(text)
        
        time = (time + 0.01) % 1
        height = (height + 1) % h
    end
end

main()