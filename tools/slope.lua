-- Dig a sloped tunnel at a grade of 12.5% (1:8 blocks)

function refuel()
    local save = turtle.getSelectedSlot()
    turtle.select(1)
    turtle.refuel()
    turtle.select(save)
end

function digRowAndReturn()
    if turtle.getFuelLevel() < 100 then
        refuel()
    end

end