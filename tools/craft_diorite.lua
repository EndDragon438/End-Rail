-- Auto-craft diorite from cobblestone and quartz
-- Quartz inventory on the top
-- Cobblestone inventory on the bottom
-- Outputs to front
--
-- Author: end draconis

-- Slot 2 on the both for this (using 1-slot storage drawers)
quartz = peripheral.wrap("top")
cobble = peripheral.wrap("bottom")

-- Get items from adjacent inventory or wait until they are available
-- @param inv wrapped peripheral inventory
-- @param slot integer slot to pull the items into
-- @param count? integer number of items to wait for
local function getOrWait(inv, slot, count)
    local deets = inv.getItemDetail(2)
    -- the 'wait' part
    while not deets or (count and deets.count < count) do
        deets = inv.getItemDetail(2)
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
    getOrWait(cobble, 1)
    getOrWait(quartz, 2)
    getOrWait(cobble, 5)
    getOrWait(quartz, 6)
    -- Step 2: craft items (go for 64 at once if possible; compensate for slow program)
    --   a) turtle.craft()
    turtle.craft()
    -- Step 3: output product
    --   a) drop() (from correct slot)
    drop()
    select(turtle.getSelectedSlot() + 1)
    drop()
end