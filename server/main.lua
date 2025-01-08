---@diagnostic disable: need-check-nil
------------------------ # ------------------------ # ------------------------ # ------------------------

ESX = exports["es_extended"]:getSharedObject()
Tags = {}
local nTags = #Config.allowedTags

------------------------ # ------------------------ # ------------------------ # ------------------------

---Checks if the specified tag is usable
---@param tag string The tag's name
---@return boolean
local function isTagAllowed(tag)
    if nTags <= 0 then
        return true
    end
    for i = 1, nTags do
        if tag == Config.allowedTags[i] then
            return true
        end
    end
    return false
end

------------------------ # ------------------------ # ------------------------ # ------------------------

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

    if not isTagAllowed(name) then
        return Debug.error("Function: 'addTag': the tag ["..tostring(name).."] is not allowed", true, debug.getinfo(1).currentline)
    end

    local playerId = math.tointeger(id)

    if not Shared.type(playerId, "number", "addTag") then
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

    if not Shared.type(playerId, "number", "removeTag") then
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

------------------------ # ------------------------ # ------------------------ # ------------------------

lib.callback.register("br_tags:getTags", function (source)
    return getTags(source)
end)

------------------------ # ------------------------ # ------------------------ # ------------------------

local function init(serverId)
    local id = math.tointeger(serverId)
    Tags[id] = FetchTags(id)

    for i = 1, #Tags[id] do
        if not isTagAllowed(Tags[id][i]) then
            ---@diagnostic disable-next-line: param-type-mismatch
            Debug.info("Removed tag ["..Tags[id][i].."] from player ["..tostring(id).."]", false, debug.getinfo(1).currentline)
            removeTag(id, Tags[id][i])
        end
    end
end

RegisterNetEvent("br_tags:playerConnected")
AddEventHandler("br_tags:playerConnected", function ()
    init(source)
end)

------------------------ # ------------------------ # ------------------------ # ------------------------

---Checks if the player is allowed to use commands
---@param id integer Player's id
---@return boolean
local function isAllowed(id)
    return true
end

RegisterCommand("tagsmenu", function (source)
    if isAllowed(source) then
        TriggerClientEvent("br_tags:openMenu", source)
    end
end, false)

RegisterCommand("addtag", function (source)
    addTag(source, "brodino")
end, false)

------------------------ # ------------------------ # ------------------------ # ------------------------

exports("has", hasTag)
exports("add", addTag)
exports("remove", removeTag)

------------------------ # ------------------------ # ------------------------ # ------------------------