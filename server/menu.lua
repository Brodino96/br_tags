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

------------------------ # ------------------------ # ------------------------ # ------------------------