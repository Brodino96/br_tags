------------------------ # ------------------------ # ------------------------ # ------------------------ # ------------------------

ESX = exports["es_extended"]:getSharedObject()
Tags = {}
local undefined

------------------------ # ------------------------ # ------------------------ # ------------------------ # ------------------------

---Sends a new set of tags to the client
---@param playerId integer Player's id
---@return nil
function SyncTags(playerId)
    TriggerClientEvent("br_tags:syncTags", playerId, Tags[playerId])
end

---Add a new tag the the specified player
---@param playerId integer Player's id
---@param name string The tags name
local function addTag(playerId, name)

    if not Shared.type(name, "string") then
        return Debug.error("Function: 'addTag': tag name should be a string, parameter with type ["..type(name).."] was passed", true, debug.getinfo(1).currentline)
    end

    if not Tags[playerId] then
        Debug.info("Function: 'addTag': player ["..tostring(playerId).."] didn't have any tag stored locally, fetching from database", false, debug.getinfo(1).currentline)
        Tags[playerId] = FetchTags(playerId)
    end

    Tags[#Tags+1] = name

    UpdateTags(playerId)
end

local function removeTag(playerId, name)

    if not Shared.type(name, "string") then
        return Debug.error("Function: 'removeTag': tag name should be a string, parameter with type ["..type(name).."] was passed", true, debug.getinfo(1).currentline)
    end

    if not Tags[playerId] then
        Debug.info("Function: 'removeTag': player ["..tostring(playerId).."] didn't have any tag stored locally, fetching from database", false, debug.getinfo(1).currentline)
        Tags[playerId] = FetchTags(playerId)
    end

    for i = 1, #Tags[playerId] do
        if Tags[playerId][i] == name then
            Tags[playerId][i] = undefined
        end
    end

    UpdateTags(playerId)
end

------------------------ # ------------------------ # ------------------------ # ------------------------ # ------------------------

---Returns the list of tag of the player
---@return table
---@param playerId integer Player's id
local function getTags(playerId)

    if not Tags[playerId] then
        Debug.info("Function: 'getTags': player ["..tostring(playerId).."] didn't have any tag stored locally, fetching from database", false, debug.getinfo(1).currentline)
        Tags[playerId] = FetchTags(playerId)
    end

    return Tags[playerId]
end

---Returns if the player has the specified tag
---@return boolean|nil
---@param playerId integer Player's id
---@param name string Tag's name
local function hasTag(playerId, name)

    if not Shared.type(name, "string") then
        return Debug.error("Function: 'hasTag': tag name should be a string, parameter with type ["..type(name).."] was passed", true, debug.getinfo(1).currentline)
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

---@diagnostic disable-next-line: undefined-global
lib.callback.register("br_tags:getTags", function (source)
    return getTags(source)
end)

------------------------ # ------------------------ # ------------------------ # ------------------------ # ------------------------

RegisterCommand("tags", function (source, args)
    local id = args[1] or source
    print(json.encode(getTags(id)))
end, false)

------------------------ # ------------------------ # ------------------------ # ------------------------ # ------------------------

exports("has", hasTag)
exports("add", addTag)
exports("remove", removeTag)

------------------------ # ------------------------ # ------------------------ # ------------------------ # ------------------------