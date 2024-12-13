------------------------ # ------------------------ # ------------------------ # ------------------------ # ------------------------

Tags = {}

------------------------ # ------------------------ # ------------------------ # ------------------------ # ------------------------

---Returns the list of all the player tags
---@return table
local function fetchTags()
    ---@diagnostic disable-next-line: undefined-global
    return lib.callback.await("br_tags:getTags")
end

------------------------ # ------------------------ # ------------------------ # ------------------------ # ------------------------

---Returns the list of all the tags for this player
---@return table
local function getTags()
    if not Tags then
        Debug.info("Function: 'getTags': didn't have any tag stored locally, fetching from database", false, debug.getinfo(1).currentline)
        Tags = fetchTags()
    end
    return Tags
end

---Returns true if the player has the specified tag
---@return boolean|nil
---@param name string Name of the tag
local function hasTag(name)

    if not Shared.type(name, "string") then
        return Debug.error("Function: 'hasTag': tag name should be a string, parameter with type ["..type(name).."] was passed", true, debug.getinfo(1).currentline)
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

------------------------ # ------------------------ # ------------------------ # ------------------------ # ------------------------

RegisterNetEvent("br_tags:syncTags")
AddEventHandler("br_tags:syncTags", function (newTags)
    Tags = newTags
end)

------------------------ # ------------------------ # ------------------------ # ------------------------ # ------------------------

exports("getTags", getTags)
exports("hasTag", hasTag)

------------------------ # ------------------------ # ------------------------ # ------------------------ # ------------------------