
---Returns the list of all the tags the player has
---@return table
---@param id number|string The serverId of the player
function FetchTags(id)

    ---@diagnostic disable-next-line: undefined-global
    local tags = MySQL.scalar.await("SELECT `tags` FROM `users` WHERE `identifier` = ? LIMIT 1", { ESX.GetPlayerFromId(id).getIdentifier() })

    if not tags then
        Debug.error("Function 'FetchTags': unable to return the tags for id ["..id.."]", true, debug.getinfo(1).currentline)
        return {}
    end
    return json.decode(tags)
end

---Updated the database with the new tags
---@param playerId integer Player's id
---@return nil
function UpdateTags(playerId)

    if not Tags[playerId] then
        return Debug.error("Function 'UpdateTags': the specified player didn't have any locally saved tags", true, debug.getinfo(1).currentline)
    end

    ---@diagnostic disable-next-line: undefined-global
    local response = MySQL.update.await("UPDATE users SET tags = ? WHERE identifier = ?", {
        Tags[playerId], ESX.GetPlayerFromId(playerId).getIdentifier()
    })

    if not response then
        return Debug.error("Function 'UpdateTags': no response was given from the database", true, debug.getinfo(1).currentline)
    end

    SyncTags(playerId)
end