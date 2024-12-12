Tags = {}

---Returns the list of all the tags for this player
---@return table
local function getTags()
    return Tags
end

---Returns if the player has the specified tag
---@return boolean|nil
---@param name string Name of the tag
local function hasTag(name)

    if not Shared.type(name, "string") then
        return
    end

    for i = 1, #Tags do
        if Tags[i] == name then
            return true
        end
    end
    return false
end

exports("getTags", getTags)
exports("hasTag", hasTag)