-- Auto-craft granite from cobblestone and quartz
-- Quartz inventory on the top
-- Cobblestone inventory on the bottom
-- Outputs to front
--
-- Author: end draconis

-- Slot 2 on the both for this (using 1-slot storage drawers)
quartz = peripheral.wrap("top")
cobble = peripheral.wrap("bottom")
slot = 2

-- Get items from adjacent inventory or wait until they are available
-- @param inv wrapped peripheral inventory
-- @param slot integer slot to pull the items into
-- @param count? integer number of items to wait for
local function getOrWait(inv, slot, count)
    count = count or 64
    local deets = inv.getItemDetail(slot)
    -- the 'wait' part
    while not deets or deets.count < count do
        deets = inv.getItemDetail(slot)
    end
    -- grab that shit
    turtle.select(slot)
    if peripheral.getName(inv) == "top" then
        turtle.suckUp(count or 64)
    else
        turtle.suckDown(count or 64)
    end
end

while true do
    -- Step 1: grab items from adjacent inventories
    --   a) getOrWait(item)
    --   b) moveItemToSlot()
    getOrWait(cobble, 1, 32)
    getOrWait(quartz, 2, 32)
    getOrWait(quartz, 5, 32)
    getOrWait(cobble, 6, 32)
    -- Step 2: craft diorite (go for 64 at once if possible; compensate for slow program)
    --   a) turtle.craft()
    turtle.select(1)
    turtle.craft(64)
    -- Step 3: craft granite
    --   a) grab more quartz
    --   b) craft
    getOrWait(quartz, 2, 64)
    turtle.craft(64)
    -- Step 4: output product
    --   a) drop() (from correct slot)
    turtle.drop()
end