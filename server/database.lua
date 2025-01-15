---Returns the list of all the tags the player has
---@param identifier string The player identifier
---@return table|nil
function FetchTags(identifier)

    local tags = MySQL.scalar.await("SELECT `br_tags` FROM `users` WHERE `identifier` = ? LIMIT 1", { identifier })

    if not tags then
        return
    end
    return json.decode(tags)
end

---Updated the database with the new tags
---@param identifier string? Player's identifier
---@return nil
function UpdateTags(identifier, tags)

    local response = MySQL.update.await("UPDATE users SET br_tags = ? WHERE identifier = ?", {
        json.encode(tags), identifier
    })

    if not response then
        return
    end
end

---Fetches the user info to be used in the menu
---@param identifier string The player identifier saved in the database
---@return table|nil
function FetchUserInfo(identifier)

    local info = MySQL.single.await("SELECT `firstname`, `lastname`, `group`, `br_tags` FROM `users` WHERE `identifier` = ? LIMIT 1", {
        identifier
    })

    if not info then
        return
    end

    info.identifier = identifier
    return info
end

function Search(name)
    local values = MySQL.rawExecute.await(
    "SELECT `firstname`, `lastname`, `identifier` FROM `users` WHERE `firstname` LIKE ? OR `lastname` LIKE ?", {
        "%"..name[1].."%", "%"..(name[2] or name[1]).."%"
    })
    return values
end