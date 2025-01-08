------------------------ # ------------------------ # ------------------------ # ------------------------

Tags = {}

------------------------ # ------------------------ # ------------------------ # ------------------------

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

    if not Shared.type(name, "string", "hasTag") then
        return
    end

    if not Tags then
        Tags = fetchTags()
    end

    for i = 1, #Tags do
        if Tags[i] == name then
            return true
        end
    end

    return false
end

------------------------ # ------------------------ # ------------------------ # ------------------------

RegisterNetEvent("br_tags:syncTags")
AddEventHandler("br_tags:syncTags", function (newTags)
    Tags = newTags
end)

------------------------ # ------------------------ # ------------------------ # ------------------------

exports("has", hasTag)

------------------------ # ------------------------ # ------------------------ # ------------------------