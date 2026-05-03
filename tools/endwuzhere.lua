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
    
    local str = strMult(text, math.floor(w / #text))

    local hue = 0
    local posCounter = 0
    while true do
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
        
        if posCounter == 0 then
            monitor.clear()
        end
        
        monitor.setCursorPos(posCounter % w, math.floor(posCounter / w))
        monitor.blit(string.sub(text, posCounter % #text - 1, posCounter % #text), colors.toBlit(colors.red), colors.toBlit(colors.blue))
        
        hue = hue + 1 % 360
        posCounter = (posCounter + 1) % (w * h)
    end
end

main()