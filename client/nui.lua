------------------------ # ------------------------ # ------------------------ # ------------------------

local function openMenu()
    local pList = lib.callback.await("br_tags:getOnlinePlayers")
    SendNUIMessage({
        action = "open",
        players = pList
    })
    SetNuiFocus(true, true)
end

------------------------ # ------------------------ # ------------------------ # ------------------------

RegisterNUICallback("close", function (body, cb)
    SetNuiFocus(false, false)
    cb()
end)

RegisterNUICallback("selectPlayer", function (body, cb)
    cb(lib.callback.await("br_tags:getUserInfo", false, body.identifier))
end)

RegisterNUICallback("search", function (body, cb)
    cb(lib.callback.await("br_tags:searchPlayer", false, body.name))
end)

RegisterNUICallback("onlineList", function (body, cb)
    cb(lib.callback.await("br_tags:getOnlinePlayers"))
end)

RegisterNUICallback("loaded", function (body, cb)
    cb(Config.allowedTags)
end)

------------------------ # ------------------------ # ------------------------ # ------------------------

RegisterNetEvent("br_tags:openMenu")
AddEventHandler("br_tags:openMenu", openMenu)

------------------------ # ------------------------ # ------------------------ # ------------------------