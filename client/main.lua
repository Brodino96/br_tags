------------------------ # ------------------------ # ------------------------ # ------------------------

Tags = {}

------------------------ # ------------------------ # ------------------------ # ------------------------

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function ()
    TriggerServerEvent("br_tags:playerConnected")
end)

---Returns the list of all the player tags
---@return table
local function fetchTags()
    return lib.callback.await("br_tags:getTags")
end

------------------------ # ------------------------ # ------------------------ # ------------------------

---Returns true if the player has the specified tag
---@return boolean|nil
---@param name string Name of the tag
local function hasTag(name)

    local tags = fetchTags()

    for i = 1, #tags do
        if tags[i] == name then
            return true
        end
    end

    return false
end

------------------------ # ------------------------ # ------------------------ # ------------------------

exports("has", hasTag)

------------------------ # ------------------------ # ------------------------ # ------------------------