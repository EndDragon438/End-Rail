-- this is for a different modpack but whateva
-- CBC/CC autoloader
-- requires screw.lua on the second turtle too

local ram = peripheral.wrap("back")
local place = peripheral.wrap("bottom")
-- For playing loaded/not loaded sound
local speaker = peripheral.wrap("right")
-- Toggle reversed rotation; either 1 or -1
local REVERSE_RAM = 1
local REVERSE_PLACE = 1

while true do
    -- Wait for redstone signal to fire
    os.pullEvent("redstone")
    if rs.getInput("left") then
        -- Fire the cannon
        rs.setOutput("right", true)
        sleep(0.1)
        rs.setOutput("right", false)
        sleep(0.1)
        
        -- Signal 'not loaded'
        speaker.playNote("bit", 3)
        
        -- Wait to toggle cannon
        sleep(0.1)
        -- Remove breech
        turtle.dig()
        
        -- Load cannon
        place.rotate(45, -1 * REVERSE_PLACE)
        while place.isRunning() do
            sleep(0.05)
        end
        place.rotate(45, 1 * REVERSE_PLACE)
        
        ram.move(2, 1 * REVERSE_RAM)
        while ram.isRunning() do
            sleep(0.05)
        end
        ram.move(2, -1 * REVERSE_RAM)
        
        while ram.isRunning() do
            sleep(0.05)
        end
        
        place.rotate(45, -1 * REVERSE_PLACE)
        while place.isRunning() do
            sleep(0.05)
        end
        place.rotate(45, 1 * REVERSE_PLACE)
        
        ram.move(3, 1 * REVERSE_RAM)
        while ram.isRunning() do
            sleep(0.05)
        end
        ram.move(3, -1 * REVERSE_RAM)
        
        while ram.isRunning() do
            sleep(0.05)
        end
        
        place.rotate(45, -1 * REVERSE_PLACE)
        while place.isRunning() do
            sleep(0.05)
        end
        place.rotate(45, 1 * REVERSE_PLACE)
        
        ram.move(4, 1 * REVERSE_RAM)
        while ram.isRunning() do
            sleep(0.05)
        end
        ram.move(4, -1 * REVERSE_RAM)
        
        sleep(0.1)
        
        -- Replace the breech
        turtle.place()

        -- Wait for breech to be screwed
        sleep(0.7)
        
        -- Signal 'loaded'
        speaker.playNote("bell", 3)
    end
end