
---Returns the list of all the tags the player has
---@return table
---@param id number|string The serverId of the player
function FetchTags(id)

    ---@diagnostic disable-next-line: undefined-global
    local tags = MySQL.scalar.await("SELECT `tags` FROM `users` WHERE `identifier` = ? LIMIT 1", { ESX.GetPlayerFromId(id).getIdentifier() })

    if not tags then
        Debug.error("Unable to fetch the tags for id ["..id.."]", true)
        return {}
    end
    return tags
end