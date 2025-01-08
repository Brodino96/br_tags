
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
function UpdateTags(playerId)

    if not Tags[playerId] then
        return Debug.error("Function 'UpdateTags': the specified player didn't have any locally saved tags", true, debug.getinfo(1).currentline)
    end

    local response = MySQL.update.await("UPDATE users SET br_tags = ? WHERE identifier = ?", {
        json.encode(Tags[playerId]), ESX.GetPlayerFromId(playerId).getIdentifier()
    })

    if not response then
        return Debug.error("Function 'UpdateTags': no response was given from the database", true, debug.getinfo(1).currentline)
    end

    SyncTags(playerId)
end

---Fetches the user info to be used in the menu
---@param identifier string The player identifier saved in the database
---@return table
function FetchUserInfo(identifier)

    local serverId = ESX.GetPlayerFromIdentifier(identifier)
    if Tags[serverId] then
        return Tags[serverId]
    end

    local info = MySQL.single.await("SELECT `firstname`, `lastname`, `group`, `job`, `job_grade`, `dateofbirth`, `tags` FROM `users` WHERE `identifier` = ? LIMIT 1", {
        identifier
    })

    return info
end