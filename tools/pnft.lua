--- Provides functions for working with the pnft image format.
--
-- PNFT: Palette Nitrogen Fingers Text
-- This format is an extension of the NFT file format to allow setting
-- palette colors in an image. The format is somewhat backwards-compatible
-- with the NFT format and can be drawn (though not parsed) by the NFT library.
--
-- Author: end draconis
-- SPDX-License-Identifier: CC-BY-4.0

local nft = require 'cc.image.nft'
local expect = require 'cc.expect'.expect

--- Parse a pnft image from a string.
--
-- @tparam string image The image contents.
-- @treturn table The parsed image.
local function parse(image)
    expect(1, image, "string")
    local cols = string.sub(image, 1, string.find(image, '\n\n'))
    local palette = {}
    for line in string.gmatch(cols, '[^\n]+') do
        if tonumber(string.sub(line, 3, -1), 16) then
            palette[colors.fromBlit(string.sub(line, 1, 1))] = tonumber(string.sub(line, 3, -1), 16)
        end
    end
    local parsed = nft.parse(string.sub(image, string.find(image, '\n\n') + 2))
    parsed['palette'] = palette
    return parsed
end

--- Load a pnft image from a file.
--
-- @tparam string path The file to load.
-- @treturn[1] table The parsed image.
-- @treturn[2] nil If the file does not exist or could not be loaded.
-- @treturn[2] string An error message explaining why the file could not be
-- loaded.
local function load(path)
    expect(1, path, "string")
    local file, err = io.open(path, 'r')
    if not file then return nil, err end

    local result = file:read('*a')
    file:close()
    return parse(result)
end

--- Draw a pnft image to the screen.
--
-- @tparam table image An image, as returned from @{load} or @{parse}.
-- @tparam number x The x position to start drawing at.
-- @tparam number y The y position to start drawing at.
-- @tparam[opt] term.Redirect target The terminal redirect to draw to. Defaults to the
-- current terminal.
local function draw(image, x, y, target)
    expect(1, image, "table")
    expect(2, x, "number")
    expect(3, y, "number")
    expect(4, target, "table", "nil")

    if not target then target = term end

    if image.palette then
        for k, v in pairs(image.palette) do
            target.setPaletteColor(k, v)
        end
    end
    nft.draw(image, x, y, target)
end

return {parse = parse, load = load, draw = draw}