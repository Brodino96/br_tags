---@diagnostic disable: need-check-nil
------------------------ # ------------------------ # ------------------------ # ------------------------

ESX = exports["es_extended"]:getSharedObject()
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
function SyncTags(playerId, tags)
    ---@diagnostic disable-next-line: param-type-mismatch
    TriggerClientEvent("br_tags:syncTags", playerId, tags)
    print("aaaaaaaaa")
end

---Adds a new tag the the specified player
---@param id integer? Player's id
---@param name string The tags name
---@return nil
function AddTag(id, name)

    if not isTagAllowed(name) then
        return Debug.error("Function: 'AddTag': the tag ["..tostring(name).."] is not allowed", true, debug.getinfo(1).currentline)
    end

    local playerId = math.tointeger(id)

    if not Shared.type(playerId, "number", "AddTag") then
        return
    end

    local tags = FetchTags(playerId)

    for i = 1, #tags do
        if tags[i] == name then
            return Debug.error("Function: 'AddTag': player ["..tostring(playerId).."] already has the tag ["..name.."]", true, debug.getinfo(1).currentline)
        end
    end

    tags[#tags+1] = name

    UpdateTags(playerId, tags)
end

---Removes the specified tag from the specified id
---@param id integer Player's id
---@param name string Tag's name
---@return nil
function RemoveTag(id, name)

    local playerId = math.tointeger(id)

    if not Shared.type(playerId, "number", "RemoveTag") then
        return
    end

    local tags = FetchTags(playerId)
    if tags == nil then return end

    for i = 1, #tags do
        if tags[i] == name then
            table.remove(tags, i)
        end
    end

    UpdateTags(playerId, tags)
end

---Returns the list of tag of the player
---@param id integer Player's id
---@return table?
local function getTags(id)
    local playerId = math.tointeger(id)

    if not Shared.type(playerId, "number", "getTags") then
        return
    end
    return FetchTags(playerId)
end

---Returns if the player has the specified tag
---@param id integer Player's id
---@param name string Tag's name
---@return boolean?
function HasTag(id, name)

    local playerId = math.tointeger(id)

    if not Shared.type(name, "string", "HasTag") or not Shared.type(playerId, "number", "HasTag") then
        return
    end

    local tags = FetchTags(playerId)
    for i = 1, #tags do
        if tags[i] == name then
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
    local tags = FetchTags(id)

    for i = 1, #tags do
        if not isTagAllowed(tags[i]) then
            ---@diagnostic disable-next-line: param-type-mismatch
            Debug.info("Removed tag ["..tags[i].."] from player ["..tostring(id).."]", false, debug.getinfo(1).currentline)
            RemoveTag(id, tags[i])
        end
    end
end

RegisterNetEvent("br_tags:playerConnected")
AddEventHandler("br_tags:playerConnected", function ()
    init(source)
end)

------------------------ # ------------------------ # ------------------------ # ------------------------

exports("has", HasTag)
exports("add", AddTag)
exports("remove", RemoveTag)

------------------------ # ------------------------ # ------------------------ # ------------------------