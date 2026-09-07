-- this is for a different modpack but whateva
-- CBC/CC autoloader

local ram = peripheral.wrap("back")
local place = peripheral.wrap("bottom")
-- For playing loaded/not loaded sound
local speaker = peripheral.wrap("right")
-- Toggle reversed rotation; either 1 or -1
local REVERSE = 1

while true do
    -- Wait for redstone signal to fire
    os.pullEvent("redstone")
    if rs.getInput("left") then
        -- Fire the cannon
        rs.setOutput("right", true)
        sleep(0.1)
        rs.setOutput("right", false)
        
        -- Signal 'not loaded'
        speaker.playNote("bit", 3)
        
        -- Toggle cannon
        rs.setOutput("left", false)
        -- Remove breech
        turtle.dig()
        
        -- Load cannon
        place.rotate(45, -1 * REVERSE)
        while place.isRunning() do
            sleep(0.05)
        end
        place.rotate(45, 1 * REVERSE)
        
        ram.move(2, 1 * REVERSE)
        while ram.isRunning() do
            sleep(0.05)
        end
        ram.move(2, -1 * REVERSE)
        
        while ram.isRunning() do
            sleep(0.05)
        end
        
        place.rotate(45, -1 * REVERSE)
        while place.isRunning() do
            sleep(0.05)
        end
        place.rotate(45, 1 * REVERSE)
        
        ram.move(3, 1 * REVERSE)
        while ram.isRunning() do
            sleep(0.05)
        end
        ram.move(3, -1 * REVERSE)
        
        while ram.isRunning() do
            sleep(0.05)
        end
        
        place.rotate(45, -1 * REVERSE)
        while place.isRunning() do
            sleep(0.05)
        end
        place.rotate(45, 1 * REVERSE)
        
        ram.move(4, 1 * REVERSE)
        while ram.isRunning() do
            sleep(0.05)
        end
        ram.move(4, -1 * REVERSE)
        
        -- Replace the breech
        turtle.place()
        
        -- Toggle the cannon on
        rs.setOutput("left", true)
        
        -- Signal 'loaded'
        speaker.playNote("bell", 3)
    end
end