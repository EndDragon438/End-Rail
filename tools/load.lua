-- this is for a different modpack but whateva
-- CBC/CC autoloader

local ram = peripheral.wrap("left")
local place = peripheral.wrap("bottom")
-- For playing loaded sound, needs to be in the right hand turtle slot
local speaker = peripheral.wrap("right")

while true do
    -- Wait for redstone signal to load
    os.pullEvent("redstone")
    -- Signal 'not loaded'
    speaker.playNote("bit", 3)
    
    -- Load cannon
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
    
    sleep(0.55)
    
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
    
    sleep(0.55)
    
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
    
    -- Signal 'loaded'
    speaker.playNote("bell", 3)
end