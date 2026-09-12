-- Companion to the 'load' program for the breech-screwing secondary turtle
while true do
    os.pullEvent("redstone")
    if rs.getInput("top") then
        -- Wait to fire
        sleep(0.1)
        
        -- Toggle off the cannon
        rs.setOutput("front", false)
        
        -- Wait for the loader to finish
        sleep(3.75)
        
        -- Screw the breech
        turtle.placeUp()
        turtle.digUp()
        
        -- Toggle on the cannon
        rs.setOutput("front", true)
    end
end