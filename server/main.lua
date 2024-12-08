------------------------ # ------------------------ # ------------------------ # ------------------------ # ------------------------

ESX = exports["es_extended"]:getSharedObject()
Tags = {}

------------------------ # ------------------------ # ------------------------ # ------------------------ # ------------------------

---Returns the list of tag of the player
---@return table|nil
---@param playerId integer|string Player's id
local function getTags(playerId)
    if Tags[playerId] then
        return Tags[playerId]
    end
    return print("The players somehow doesn't have any tags THIS IS AN ERROR")
end

---Returns if the player has the specified tag
---@return boolean
---@param name string Tag's name
---@param playerId integer|string Player's id
local function hasTag(name, playerId)
    local playerTags = Tags[playerId]
    for i = 1, #playerTags do
        if playerTags[i] == name then
            return true
        end
    end
    return false
end

------------------------ # ------------------------ # ------------------------ # ------------------------ # ------------------------

exports("getTags", getTags)
exports("hasTag", hasTag)

------------------------ # ------------------------ # ------------------------ # ------------------------ # ------------------------