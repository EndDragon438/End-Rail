--[[
Variable-munition single-turtle autoloader.

Inventory Layout:

S = Shell/Shot
P = Powder Charge
B = Breech (Unscrewed)
M = Motor (Rotation source, must rotate when placed, restricted to Creative Motor or Ender Transmission - configurable)
R = Ram Rod (Configured to a push limit of 9)

. = May be either shell/shot or powder charge, S and P sections MUST be contiguous

S . . .
. . . .
. . . .
P B M R

Hand Slots:

Speaker (Optional, plays signal sounds for ready/not ready)
Pickaxe

Author: end
Updated: Sept. 13, '26
]]


-- CONFIGURE INPUT SIDES (MUST NOT BE DUPLICATED)
-- Fire a round
local I_FIRE = "front"
-- Cycle munition up (forward)
local I_MUNITION_U = "right"
-- Cycle munition down (backward)
local I_MUNITION_D = "left"
-- Increase propellant count
local I_PROP_U = "top"
-- Decrease propellant count
local I_PROP_D = "bottom"

-- Assemble cannon output; with cables you don't need to configure this, but you may
local O_ASSEMBLE = "back"

-- OPTIONAL: Label your munitions, can be used to send data to some other peripheral
local MUNITIONS = {
    "SMOKE-T",
    "APDS-T",
    "SHRAP-T",
    "HE-T",
    "HEAT-T",
}

local SPEAKER = peripheral.find("speaker")

-- Confirm that all configuration is correct
local function checkConfiguration()
    -- Check that input sides are configured properly with no duplicates
    local sides = {"front", "back", "right", "left", "top", "bottom"}
    local missing = 0
    for k, v in ipairs(sides) do
        if (I_FIRE ~= v) and (I_MUNITION_U ~= v) and (I_MUNITION_D ~= v) and (I_PROP_U ~= v) and (I_PROP_D ~= v) then
            missing = missing + 1
        end
    end
    if missing ~= 1 then
        print("MISCONFIGURED INPUT SIDES")
        return false
    end
    
    -- Check input slots
    local ram = turtle.getItemDetail(16)
    if ram == nil or ram.name ~= "createbigcannons:ram_rod" then
        print("MISSING RAM ROD")
        return false
    end
    
    local motor = turtle.getItemDetail(15)
    -- NOTE: If you are using a different rotation source, add it here
    if motor == nil or (motor.name ~= "create:creative_motor" and motor.name ~= "createendertransmission_energy_transmitter") then
        print("MISSING MOTOR")
        return false
    end
    
    local breech = turtle.getItemDetail(14)
    -- NOTE: If you are using a different screw breech, add it here
    if breech == nil or (breech.name ~= "createbigcannons:nethersteel_screw_breech" and breech.name ~= "createbigcannons:steel_screw_breech") then
        print("MISSING BREECH")
        return false
    end
    
    local powder = turtle.getItemDetail(13)
    if powder == nil or powder.name ~= "createbigcannons:powder_charge" then
        print("MISSING POWDER CHARGE")
        return false
    end
    
    local shell = turtle.getItemDetail(1)
    if shell == nil then
        print("girl you gotta load *some* shell")
        return false
    end
    
    local powderOnly = false
    for i = 1, 13 do
        local item = turtle.getItemDetail(i)
        if not powderOnly and item ~= nil and item.name == "createbigcannons:powder_charge" then
            powderOnly = true
        else if powderOnly and item ~= nil and item.name ~= "createbigcannons:powder_charge" then
            print("MISORDER SHELL/SHOT AND POWDER")
            return false
        end
    end
    
    return true
end

local function startLoader()
    
end

-- Start 'er up if everything is good
if checkConfiguration() then
    startLoader()
end