------------------------ # ------------------------ # ------------------------ # ------------------------ # ------------------------

ESX = exports["es_extended"]:getSharedObject()
Tags = {}

------------------------ # ------------------------ # ------------------------ # ------------------------ # ------------------------

---Returns the list of tag of the player
---@return table|nil
---@param playerId integer|string Player's id
local function getTags(playerId)

    if not Tags[playerId] then
        Debug.info("Player: ["..tostring(playerId).."] didn't have any tag stored locally, fetching from database", false)
        Tags[playerId] = FetchTags(playerId)
    end

    return Tags[playerId]
end

---Returns if the player has the specified tag
---@return boolean|nil
---@param name string Tag's name
---@param playerId integer|string Player's id
local function hasTag(name, playerId)

    if not Shared.type(name, "string") then
        return Debug.error("Tag name should be a string, a ["..type(name).."] was passed", false)
    end

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