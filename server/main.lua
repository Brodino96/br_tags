---@diagnostic disable: need-check-nil
------------------------ # ------------------------ # ------------------------ # ------------------------ # ------------------------

ESX = exports["es_extended"]:getSharedObject()
Tags = {}

------------------------ # ------------------------ # ------------------------ # ------------------------ # ------------------------

---Sends a new set of tags to the client
---@param playerId integer? Player's id
---@return nil
function SyncTags(playerId)
    ---@diagnostic disable-next-line: param-type-mismatch
    TriggerClientEvent("br_tags:syncTags", playerId, Tags[playerId])
end

---Adds a new tag the the specified player
---@param id integer? Player's id
---@param name string The tags name
---@return nil
local function addTag(id, name)

    local playerId = math.tointeger(id)

    if not Shared.type(name, "string", "addTag") or not Shared.type(playerId, "number", "addTag") then
        return
    end

    if not Tags[playerId] then
        Debug.info("Function: 'addTag': player ["..tostring(playerId).."] didn't have any tag stored locally, fetching from database", false, debug.getinfo(1).currentline)
        Tags[playerId] = FetchTags(playerId)
    end

    for i = 1, #Tags[playerId] do
        if Tags[playerId][i] == name then
            return Debug.error("Function: 'addTag': player ["..tostring(playerId).."] already has the tag ["..name.."]", true, debug.getinfo(1).currentline)
        end
    end

    Tags[playerId][#Tags[playerId]+1] = name

    UpdateTags(playerId)
end

---Removes the specified tag from the specified id
---@param id integer Player's id
---@param name string Tag's name
---@return nil
local function removeTag(id, name)

    local playerId = math.tointeger(id)

    if not Shared.type(name, "string", "removeTag") or not Shared.type(playerId, "number", "removeTag") then
        return
    end

    if not Tags[playerId] then
        Debug.info("Function: 'removeTag': player ["..tostring(playerId).."] didn't have any tag stored locally, fetching from database", false, debug.getinfo(1).currentline)
        Tags[playerId] = FetchTags(playerId)
    end

    for i = 1, #Tags[playerId] do
        if Tags[playerId][i] == name then
            table.remove(Tags[playerId], i)
        end
    end

    UpdateTags(playerId)
end

------------------------ # ------------------------ # ------------------------ # ------------------------ # ------------------------

---Returns the list of tag of the player
---@param id integer Player's id
---@return table?
local function getTags(id)

    local playerId = math.tointeger(id)

    if not Shared.type(playerId, "number", "getTags") then
        return
    end

    if not Tags[playerId] then
        Debug.info("Function: 'getTags': player ["..tostring(playerId).."] didn't have any tag stored locally, fetching from database", false, debug.getinfo(1).currentline)
        Tags[playerId] = FetchTags(playerId)
    end

    return Tags[playerId]
end

---Returns if the player has the specified tag
---@param id integer Player's id
---@param name string Tag's name
---@return boolean?
local function hasTag(id, name)

    local playerId = math.tointeger(id)

    if not Shared.type(name, "string", "hasTag") or not Shared.type(playerId, "number", "hasTag") then
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

---@diagnostic disable-next-line: undefined-global
lib.callback.register("br_tags:getTags", function (source)
    return getTags(source)
end)

------------------------ # ------------------------ # ------------------------ # ------------------------ # ------------------------

exports("has", hasTag)
exports("add", addTag)
exports("remove", removeTag)

------------------------ # ------------------------ # ------------------------ # ------------------------ # ------------------------