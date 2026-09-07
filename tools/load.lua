-- this is for a different modpack but whateva
-- CBC/CC autoloader

local ram = peripheral.wrap("back")
local place = peripheral.wrap("bottom")
-- For playing loaded/not loaded sound
local speaker = peripheral.wrap("right")

while true do
    -- Wait for redstone signal to fire
    os.pullEvent("redstone")
    if rs.getInput("back") then
        -- Fire the cannon
        rs.setOutput("right", true)
        sleep(0.1)
        rs.setOuput("right", false)
        
        -- Signal 'not loaded'
        speaker.playNote("bit", 3)
        
        -- Toggle cannon
        rs.setOutput("left", false)
        -- Remove breech
        turtle.dig()
        
        -- Load cannon
        place.rotate(45, -1)
        while place.isRunning() do
            sleep(0.05)
        end
        place.rotate(45, 1)
        
        ram.move(2, 1)
        while ram.isRunning() do
            sleep(0.05)
        end
        ram.move(2, -1)
        
        while ram.isRunning() do
            sleep(0.05)
        end
        
        place.rotate(45, -1)
        while place.isRunning() do
            sleep(0.05)
        end
        place.rotate(45, 1)
        
        ram.move(3, 1)
        while ram.isRunning() do
            sleep(0.05)
        end
        ram.move(3, -1)
        
        while ram.isRunning() do
            sleep(0.05)
        end
        
        place.rotate(45, -1)
        while place.isRunning() do
            sleep(0.05)
        end
        place.rotate(45, 1)
        
        ram.move(4, 1)
        while ram.isRunning() do
            sleep(0.05)
        end
        ram.move(4, -1)
        
        -- Replace the breech
        turtle.place()
        
        -- Toggle the cannon on
        rs.setOutput("left", true)
        
        -- Signal 'loaded'
        speaker.playNote("bell", 3)
    end
end