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
            {h = 196, s = .63, v = .98},
            {h = 348, s = .31, v = .96},
            {h = 0, s = 0, v = 1}
        }
    }

    local time = 0
    local height = 1
    while true do
        os.sleep(0.05)
        monitor.clear()
        monitor.setCursorPos((w - #text) / 2, height)
        
        local col = color.lerp(gradients[args[1]] or gradients.rainbow, time)
        local shift = color.hsv(col)
        local txtCol = color.rgb({ h = (shift.h + 0.5) % 1, s = shift.s, v = shift.v})
        
        monitor.setPaletteColor(colors.red, colors.packRGB(col.r, col.g, col.b))
        monitor.setPaletteColor(colors.blue, colors.packRGB(txtCol.r, txtCol.g, txtCol.b))
        
        monitor.write(text)
        
        time = (time + 0.01) % 1
        height = (height + 1) % h
    end
end

main()