------------------------ # ------------------------ # ------------------------ # ------------------------

local function openMenu()
    local pList = lib.callback.await("br_tags:getOnlinePlayers")
    SendNUIMessage({
        action = "open",
        players = pList
    })
    SetNuiFocus(true, true)
    TriggerScreenblurFadeIn(500)
end

------------------------ # ------------------------ # ------------------------ # ------------------------

RegisterNUICallback("close", function (body, cb)
    cb(SetNuiFocus(false, false))
    TriggerScreenblurFadeOut(500)
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

RegisterNUICallback("updateTags", function (body, cb)
    cb(lib.callback.await("br_tags:changeTagsFromMenu", false, body))
end)

------------------------ # ------------------------ # ------------------------ # ------------------------

RegisterNetEvent("br_tags:openMenu")
AddEventHandler("br_tags:openMenu", openMenu)

------------------------ # ------------------------ # ------------------------ # ------------------------