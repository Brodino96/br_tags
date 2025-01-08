---Returns the list of all the tags the player has
---@param id integer? The serverId of the player
---@return table|nil
function FetchTags(id)

    local tags = MySQL.scalar.await("SELECT `br_tags` FROM `users` WHERE `identifier` = ? LIMIT 1", { ESX.GetPlayerFromId(id).getIdentifier() })

    if not tags then
        return Debug.error("Function 'FetchTags': unable to return the tags for id ["..id.."]", true, debug.getinfo(1).currentline)
    end
    return json.decode(tags)
end

---Updated the database with the new tags
---@param playerId integer? Player's id
---@return nil
function UpdateTags(playerId, tags)

    local response = MySQL.update.await("UPDATE users SET br_tags = ? WHERE identifier = ?", {
        json.encode(tags), ESX.GetPlayerFromId(playerId).getIdentifier()
    })

    if not response then
        return Debug.error("Function 'UpdateTags': no response was given from the database", true, debug.getinfo(1).currentline)
    end

    SyncTags(playerId, tags)
end

---Fetches the user info to be used in the menu
---@param identifier string The player identifier saved in the database
---@return table|nil
function FetchUserInfo(identifier)

    local info = MySQL.single.await("SELECT `firstname`, `lastname`, `group`, `job`, `job_grade`, `dateofbirth`, `br_tags` FROM `users` WHERE `identifier` = ? LIMIT 1", {
        identifier
    })

    if not info then
        return Debug.error("Function 'FetchUserInfo': failed to get info from database", true, debug.getinfo(1).currentline)
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