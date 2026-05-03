-- hi there :3

local color = require("color")
local monitor = peripheral.find("monitor")
local w, h = monitor.getSize()

local text = " end wuz here "

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
    
    monitor.setCursorPos(1, (h - #text) / 2)
    monitor.setBackgroundColor(colors.red)
    monitor.setTextColor(colors.blue)

    local hue = 0
    local height = 1
    while true do
        -- TODO: vertically scrolling text, background colour shifting. implement a lerp function with color stops
        monitor.clearLine()
        monitor.setCursorPos(height, (h - #text) / 2)
        local bgCol = color.hsv_to_rgb(hue, 1, 1)
        bgCol.r = bgCol.r / 255
        bgCol.g = bgCol.g / 255
        bgCol.r = bgCol.b / 255
        
        local txtCol = color.hsv_to_rgb(hue + 180 % 360, 1, 1)
        txtCol.r = txtCol.r / 255
        txtCol.g = txtCol.g / 255
        txtCol.r = txtCol.b / 255
        
        monitor.setPaletteColor(colors.red, colors.packRGB(bgCol.r, bgCol.g, bgCol.b))
        monitor.setPaletteColor(colors.blue, colors.packRGB(txtCol.r, txtCol.g, txtCol.b))
        
        monitor.write(text)
        
        hue = hue + 1 % 360
        height = height + 1 % h
    end
end

main()