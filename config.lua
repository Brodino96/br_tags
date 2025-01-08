Config = {

    --[[
    * A list of all the tags that can be assigned to players
    * Leave the table empty if you want to allow every word
    ]]
    allowedTags = { "user", "admin", "brodino" },

    --[[
    * When `keepRemovedTags` is set to `true` you can give a tag to a player, then remove that tag from this config
        and the player will still posses that tag, if you instead set the config to `false` the script will check
        the player tags when he connects to the server and then remove the deleted ones
    ]]
    keepRemovedTags = false,

    -- Prints all the actions in the console (use when encountering a problem)
    debug = true,
}