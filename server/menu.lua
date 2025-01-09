------------------------ # ------------------------ # ------------------------ # ------------------------

---Checks if the player is allowed to use commands
---@param id integer Player's id
---@return boolean
local function isAllowed(id)
    HasTag(id, Config.menu.tag)
end

RegisterCommand(Config.menu.command, function (source)
    if isAllowed(source) then
        TriggerClientEvent("br_tags:openMenu", source)
    end
end, false)

------------------------ # ------------------------ # ------------------------ # ------------------------

lib.callback.register("br_tags:getOnlinePlayers", function ()
    local arr = {}
    for _, xPlayer in ipairs(ESX.GetExtendedPlayers()) do
        arr[_] = { name = xPlayer.getName(), identifier = xPlayer.getIdentifier() }
    end
    return arr
end)

lib.callback.register("br_tags:getUserInfo", function (source, identifier)
    return FetchUserInfo(identifier)
end)

lib.callback.register("br_tags:searchPlayer", function (source, name)
    local arr = {}
    local values = Search(name)
    for i = 1, #values do
        arr[i] = { name = values[i].firstname.." "..values[i].lastname, identifier = values[i].identifier }
    end
    return arr
end)

lib.callback.register("br_tags:changeTagsFromMenu", function (source, data)
    if not isAllowed(source) then
        return
    end
    if data.action then
        AddTag(nil, data.tag, data.identifier)
    else
        RemoveTag(nil, data.tag, data.identifier)
    end
    return FetchTags(data.identifier)
end)

------------------------ # ------------------------ # ------------------------ # ------------------------