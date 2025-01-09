Config = {

    -- A list of all the tags that can be assigned to players
    allowedTags = { "user", "admin", "brodino" },

    --[[
    * When `keepRemovedTags` is set to `true` you can give a tag to a player,
        then remove that tag from this config and the player will still posses
        that tag, if you instead set the config to `false` the script will check
        the player tags when he connects to the server and then remove the deleted ones
    ]]
    keepRemovedTags = false,

    --[[
    * A tag that will be given to every player
        will check every time a player connects or the scripts is restarted
    * You cannot use a tag that isn't configured in `allowedTags`
    ]]
    defaultTag = "user",

    menu = {
        command = "tagsmenu", -- command name to open the menu
        tag = "user" -- [IMPORTANT] the required tag to use the menu, change it a soon as possible
    },
}