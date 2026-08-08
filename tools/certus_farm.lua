-- Mining turtle program to automate certus quartz farming
-- Slots: 1: fuel, 2: budding certus quartz

-- Refuels the turtle from the first slot, then returns to the previous
-- slot.
function refuel()
    local save = turtle.getSelectedSlot()
    turtle.select(1)
    local success = turtle.refuel()
    turtle.select(save)
    return success
end

-- Dig until there's no block ahead
function digUntilClear()
    while turtle.detect() do
        turtle.dig()
    end
end

function farm()
    local dirSwap = false
    while true do
        if turtle.getFuelLevel() < 100 then 
            local isFuel = refuel()
            if not isFuel then return end -- don't spin in circles breaking and placing shit
        end
        while true do
            local isBlock, block = turtle.inspect()
            if isBlock and not string.find(block.name, 'quartz_bud') then break end -- found end of farm
            -- while we've got further to go
            digUntilClear()
            turtle.forward()
            if dirSwap then
                turtle.turnRight()
            else
                turtle.turnLeft()
            end
            isBlock, block = turtle.inspect()
            -- put a new budding quartz down if needed
            if not isBlock then
                turtle.select(2)
                turtle.place()
            end
            -- check for full clusters
            turtle.up()
            isBlock, block = turtle.inspect()
            if isBlock and block.name == 'ae2:quartz_cluster' then turtle.dig() end
            turtle.down()
            turtle.down()
            isBlock, block = turtle.inspect()
            if isBlock and block.name == 'ae2:quartz_cluster' then turtle.dig() end
            turtle.up()
            
            isBlock, block = turtle.inspect()
            -- if the block has run out, replace it
            if isBlock and block.name == 'ae2:quartz_block' then
                turtle.dig()
                turtle.select(2)
                turtle.place()
            end
            if dirSwap then
                turtle.turnLeft()
            else
                turtle.turnRight()
            end
        end
        turtle.turnRight()
        turtle.turnRight()
        dirSwap = not dirSwap
        sleep(300)
    end
end

farm()