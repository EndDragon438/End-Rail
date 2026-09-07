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
    redstone.setOutput("front", false)
    speaker.playNote("bit", 3)
    
    -- Load cannon
    place.rotate(45, -1)
    place.rotate(45, 1)
    
    ram.move(5, 1)
    ram.move(5, -1)
    
    sleep(0.55)
    
    place.rotate(45, -1)
    place.rotate(45, 1)
    
    ram.move(5, 1)
    ram.move(5, -1)
    
    -- Signal 'loaded'
    redstone.setOutput("front", true)
    speaker.playNote("bell", 3)
end