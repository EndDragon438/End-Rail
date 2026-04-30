-- Dig a sloped 11x6 tunnel at a grade of 12.5% (1:8 blocks)

-- CLI arguments. First argument should always be present, and be either
-- 'up' or 'down'
local args = {...}

if #args < 1 then
    print("Please pass a direction")
elseif args[1] ~= "up" and args[1] ~= "down" then
    print("Direction must be either 'up' or 'down'")
end

-- Refuels the turtle from the first slot, then returns to the previous
-- slot.
function refuel()
    local save = turtle.getSelectedSlot()
    turtle.select(1)
    local success = turtle.refuel()
    turtle.select(save)
    return sucess
end

-- Digs until the block in front of the turtle is empty
function digUntilClear()
    while turtle.detect() do
        turtle.dig()
    end
end

-- Digs forward 7 blocks, then moves back to its starting position. Tries
-- to refuel if needed.
function digRowAndReturn()
    for i = 1,7 do
        digUntilClear()
        turtle.forward()
    end
    for i = 1,7 do
        turtle.back()
    end
end

-- Digs a flat face. At the end, the turtle will be in the bottom right
-- corner of the face.
 function digFace(dir)
    -- if dir == up we have to dig 1 row above current
    -- if dir == down we'll have to dig an extra row down
    digUntilClear()
    turtle.forward()
    turtle.turnRight()
    if dir == 'up' then
        turtle.digUp()
        turtle.up()
        for i = 1,10 do
            digUntilClear()
            turtle.forward()
        end
        for i = 1, 10 do
            turtle.back()
        end
        turtle.down()
    end
    
    for i = 1,5 do
        for j = 1, 10 do
            digUntilClear()
            turtle.forward()
        end
        for j = 1, 10 do
            turtle.back()
        end
        if i ~= 5 then
            turtle.digDown()
            turtle.down()
        end
    end
    
    if dir == 'down' then
        turtle.digDown()
        turtle.down()
        for i = 1, 10 do
            digUntilClear()
            turtle.forward()
        end
    else
        for i = 1, 10 do
            turtle.forward()
        end
    end
    turtle.turnLeft()
end

-- Digs the sloped tunnel
function dig(dir)
    print("Press Ctrl+T to stop")
    local counter = 0
    while true do
        if turtle.getFuelLevel() < 80 then
           refuel()
        end
        -- dig a face from the top left corner
        digFace(dir)
        
        -- dig a buncha rows, starting in the bottom right
        for y = 1, 6 do
            for x = 1, 11 do
                digRowAndReturn()
                if x < 11 then
                    turtle.turnLeft()
                    turtle.forward()
                    turtle.turnRight()
                end
            end
            if y < 5 then
                turtle.turnRight()
                for x = 1, 10 do
                    turtle.forward()
                end
                turtle.turnLeft()
                turtle.up()
            end
        end
        turtle.down()
        counter = counter + 1
        print("Dug "..counter.." sections.")
    end
end

dig(args[1])