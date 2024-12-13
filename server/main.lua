------------------------ # ------------------------ # ------------------------ # ------------------------ # ------------------------

ESX = exports["es_extended"]:getSharedObject()
Tags = {}

------------------------ # ------------------------ # ------------------------ # ------------------------ # ------------------------

---Returns the list of tag of the player
---@return table|nil
---@param playerId integer|string Player's id
local function getTags(playerId)

    if not Tags[playerId] then
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
        return
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

AddEventHandler("onResourceStart", function (name)
    if name ~= GetCurrentResourceName() then
        return
    end

    local allPlayers = GetPlayers()
    for i = 1, #allPlayers do
        Tags[allPlayers[i]] = FetchTags(allPlayers[i])
    end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function (id)
    Tags[id] = FetchTags(id)
    TriggerClientEvent("br_tags:syncTags", id, Tags[id])
end)

------------------------ # ------------------------ # ------------------------ # ------------------------ # ------------------------

exports("getTags", getTags)
exports("hasTag", hasTag)

------------------------ # ------------------------ # ------------------------ # ------------------------ # ------------------------