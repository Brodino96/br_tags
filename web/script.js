// -------------------------------------------------------------------------- \\

let allowedTags = null
let ownedTags = []
const player_name = document.getElementById("player_name")
const player_group = document.getElementById("player_group")
const player_identifier = document.getElementById("player_identifier")
const list_buttons = document.getElementById("list_buttons")
const tag_search = document.getElementById("tag_search")
const item_list = document.getElementById("item_list")
const htmlbody = document.getElementsByTagName("body")[0]

// -------------------------------------------------------------------------- \\

// Makes sure js has the config file
fetch(`https://${GetParentResourceName()}/loaded`, {
    method: "POST",
}).then(resp => resp.json()).then(function(tags) {
    allowedTags = tags
}).catch()

// Lua requests
window.addEventListener("message", function(event) {
    if (event.data.action == "open") { showUi(event.data.players) }
})

// -------------------------------------------------------------------------- \\

function showUi(list) {
    renderPlayers(list)
    resetInfo()
    document.body.style.display = "block"
}

document.addEventListener("keydown", function(e) {
    if (e.key == "Escape") {
        fetch(`https://${GetParentResourceName()}/close`, {
            method: "POST",
        }).then(resp => resp.json()).then(function() {
            htmlbody.style.display = "none"
        })
    }
})

// -------------------------------------------------------------------------- \\
// Playerlist

function search(text) {
    if (text.trim().length == 0) {
        fetch(`https://${GetParentResourceName()}/onlineList`, {
            method: "POST",
        }).then(resp => resp.json()).then(function(list) {
            renderPlayers(list)
        })
    } else {
        fetch(`https://${GetParentResourceName()}/search`, {
            method: "POST",
            body: JSON.stringify({ name: text.split(" ")})
        }).then(resp => resp.json()).then(function(list) {
            renderPlayers(list)
        })
    }
}

// Triggered when selecting a player from the list in the left
function selectPlayer(identifier) {
    fetch(`https://${GetParentResourceName()}/selectPlayer`, {
        method: "POST",
        body: JSON.stringify({ identifier: identifier })
    }).then(resp => resp.json()).then(function(info) {
        displayInfo(info)
    })
}

// Updates the players list
function renderPlayers(list) {
    list_buttons.innerHTML = ""
    for (let i = 0; i < Object.keys(list).length; i++) {
        list_buttons.innerHTML +=
        `<button id="${list[i].identifier}" class="plist_button" onclick="selectPlayer(this.id)">${list[i].name}</button>`
    }
}

// -------------------------------------------------------------------------- \\

// Changes the text in the top right
function displayInfo(info) {
    if (!info) { return }
    player_name.innerHTML = `${info.firstname} ${info.lastname}`
    player_group.innerHTML = info.group
    player_identifier.innerHTML = info.identifier
    player_identifier.title = info.identifier
    ownedTags = info.br_tags
    renderTags(allowedTags)
}

function resetInfo() {
    player_name.innerHTML = "Player name"
    player_group.innerHTML = "group"
    player_identifier.innerHTML = "identifier"
    player_identifier.title = "identifier"
    item_list.innerHTML = ""
}

// Dinamically filters the tag list
tag_search.addEventListener("input", (e) => {
    const filteredItems = filterItems(e.target.value)
    renderTags(filteredItems)
})

function filterItems(searchTerm) {
    return allowedTags.filter(item => 
        item.toLowerCase().includes(searchTerm.toLowerCase())
    )
}

// Updates the tags list
function renderTags(tagList) {
    item_list.innerHTML = ""
    tagList.forEach(item => {
        const li = document.createElement("li")
        if (ownedTags.includes(item)) {
            li.innerHTML = `
            <label>
                <input type="checkbox" id="${item}" onchange="changed_check(this)" checked>
                ${item}
            </label>
        `
        } else {
            li.innerHTML = `
            <label>
                <input type="checkbox" id="${item}" onchange="changed_check(this)">
                ${item}
            </label>
        `
        }
        item_list.appendChild(li)
    })
}

// Triggered when selecting a tag
function changed_check(item) {
    fetch(`https://${GetParentResourceName()}/updateTags`, {
        method: "POST",
        body: JSON.stringify({
            identifier: player_identifier.innerHTML,
            tag: item.id,
            action: item.checked
        })
    }).then(resp => resp.json()).then(function(newTags) {
        ownedTags = newTags
    })
}

// -------------------------------------------------------------------------- \\