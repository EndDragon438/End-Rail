-- Given screen dimensions and a list of stations with a route name,
-- write a .pnft image to display.

--[[ Description of the structure for the array of stations
    {
        {
            name = "Example Station",
            coords = {x = 123, y = 456}, -- unsure abt this. statically define or dynamically generate?
            routes = {"Passenger Route A", "Freight Route B"}
        },
        {
            name = "Example Station 2",
            coords = {x = 789, y = 101},
            routes = {"Passenger Route B", "Freight Route A"}
        }
    }
]]

local function newImage(width, height)
    local image = {}
    for y = 1, height do
        image[y] = {}
        for x = 1, width do
            image[y][x] = {color = '0', text = ' '}
        end
    end
    image.width = width
    image.height = height
    return image
end

local function paint(stations, width, height)
    local image = newImage(width, height)

    -- First, find the scale to work at
    local stationX = {min = 0, max = 0}
    local stationY = {min = 0, max = 0}
    for _, station in stations do
        if station.x > stationX.max then
            stationX.max = station.x
        elseif station.x < stationX.min then
            stationX.min = station.x
        end
        if station.y > stationY.max then
            stationY.max = station.y
        elseif station.y < stationY.min then
            stationY.min = station.y
        end
    end

    local scaleX = (stationX.max - stationX.min) / width
    local scaleX = (stationY.max - stationY.min) / height

    -- Second, draw the lines
    --[[
        ok so
        .pnft
        can have lines of widely varying length
        because of the colour modification characters (2 chars per swap)
        so
        my character insertion will be inconsistent
        because whenever i insert
        i change the indexes
        so i might just want to append to each line
        BUt
        that assumes that each line will be written to once
        which they won't
        at all
        i could swap to nfp instead of nft
        but
        that means i can't do text
        which seems like it would be real useful

        ------

        ok, maybe i do an intermediate format which is width X height
        then i translate that once all the painting is done into a pnft
    ]]
    -- Third, draw the stations
end

return { paint = paint }