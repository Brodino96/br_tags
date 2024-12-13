---@diagnostic disable: need-check-nil
------------------------ # ------------------------ # ------------------------ # ------------------------ # ------------------------

ESX = exports["es_extended"]:getSharedObject()
Tags = {}
local undefined

------------------------ # ------------------------ # ------------------------ # ------------------------ # ------------------------

---Sends a new set of tags to the client
---@param playerId integer? Player's id
---@return nil
function SyncTags(playerId)
    ---@diagnostic disable-next-line: param-type-mismatch
    TriggerClientEvent("br_tags:syncTags", playerId, Tags[playerId])
end

---Add a new tag the the specified player
---@param id integer Player's id
---@param name string The tags name
---@return nil
local function addTag(id, name)

    local playerId = math.tointeger(id)

    if not Shared.type(name, "string") or not Shared.type(playerId, "number") then
        return Debug.error(string.format("Function: 'addTag': was expecting [string] & [number], got [%s] & [%s]", type(name), type(id)), true, debug.getinfo(1).currentline)
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

    if not Shared.type(name, "string") or not Shared.type(playerId, "number") then
        return Debug.error(string.format("Function: 'removeTag': was expecting [string] & [number], got [%s] & [%s]", type(name), type(id)), true, debug.getinfo(1).currentline)
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

    if not Shared.type(playerId, "number") then
        return Debug.error(string.format("Function: 'getTags': was expecting [number], got [%s]", type(id)), true, debug.getinfo(1).currentline)
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

    if not Shared.type(name, "string") or not Shared.type(playerId, "number") then
        return Debug.error(string.format("Function: 'hasTag': was expecting [string] & [number], got [%s] & [%s]", type(name), type(id)), true, debug.getinfo(1).currentline)
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

RegisterCommand("brtags", function (source, args)
    local id = args[1] or source
    print(json.encode(getTags(id)))
end, false)

RegisterCommand("addtags", function (source, args)
    addTag(args[1], args[2])
end, false)

RegisterCommand("removetag", function (source, args)
    removeTag(args[1], args[2])
end, false)

RegisterCommand("test", function ()
    print(json.encode(Tags))
end, false)

------------------------ # ------------------------ # ------------------------ # ------------------------ # ------------------------

exports("has", hasTag)
exports("add", addTag)
exports("remove", removeTag)

------------------------ # ------------------------ # ------------------------ # ------------------------ # ------------------------