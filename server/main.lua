---@diagnostic disable: need-check-nil
------------------------ # ------------------------ # ------------------------ # ------------------------

ESX = exports["es_extended"]:getSharedObject()
local nTags = #Config.allowedTags

------------------------ # ------------------------ # ------------------------ # ------------------------

---Checks if the specified tag is usable
---@param tag string The tag's name
---@return boolean
local function isTagAllowed(tag)
    for i = 1, nTags do
        if tag == Config.allowedTags[i] then
            return true
        end
    end
    return false
end

------------------------ # ------------------------ # ------------------------ # ------------------------

---Adds a new tag the the specified player
---@param id integer? Player's id
---@param name string The tags name
---@return nil
function AddTag(id, name)

    if not isTagAllowed(name) then
        return
    end

    local identifier = ESX.GetPlayerFromId(id).getIdentifier()

    local tags = FetchTags(identifier)

    for i = 1, #tags do
        if tags[i] == name then
            return
        end
    end

    tags[#tags+1] = name

    UpdateTags(identifier, tags)
end

---Removes the specified tag from the specified id
---@param id integer? Player's id
---@param name string Tag's name
---@return nil
function RemoveTag(id, name)

    local identifier = ESX.GetPlayerFromId(id).getIdentifier()

    local tags = FetchTags(identifier)
    if tags == nil then return end

    for i = 1, #tags do
        if tags[i] == name then
            table.remove(tags, i)
        end
    end

    UpdateTags(identifier, tags)
end

---Returns if the player has the specified tag
---@param id integer? Player's id
---@param name string Tag's name
---@return boolean
function HasTag(id, name)

    local identifier = ESX.GetPlayerFromId(id).getIdentifier()

    local tags = FetchTags(identifier)
    for i = 1, #tags do
        if tags[i] == name then
            return true
        end
    end
    return false
end

------------------------ # ------------------------ # ------------------------ # ------------------------

lib.callback.register("br_tags:getTags", function (source)
    return FetchTags(ESX.GetPlayerFromId(source).getIdentifier())
end)

------------------------ # ------------------------ # ------------------------ # ------------------------

local function init(serverId)

    AddTag(serverId, Config.defaultTag)

    if Config.keepRemovedTags then
        return
    end

    local id = math.tointeger(serverId)
    local tags = FetchTags(ESX.GetPlayerFromId(id).getIdentifier())

    for i = 1, #tags do
        if not isTagAllowed(tags[i]) then
            ---@diagnostic disable-next-line: param-type-mismatch
            RemoveTag(id, tags[i])
        end
    end
end

RegisterNetEvent("br_tags:playerConnected")
AddEventHandler("br_tags:playerConnected", function ()
    init(source)
end)

-- Runs every time the resources is started
for _, i in pairs(GetPlayers()) do
    init(i)
end

------------------------ # ------------------------ # ------------------------ # ------------------------

exports("has", HasTag)
exports("add", AddTag)
exports("remove", RemoveTag)

------------------------ # ------------------------ # ------------------------ # ------------------------