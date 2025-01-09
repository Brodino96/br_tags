
let allowedTags = null
let ownedTags = []
const player_name = document.getElementById("player_name")
const player_group = document.getElementById("player_group")
const player_identifier = document.getElementById("player_identifier")
const list_buttons = document.getElementById("list_buttons")
const tag_search = document.getElementById("tag_search")
const item_list = document.getElementById("item_list")
const htmlbody = document.getElementsByTagName("body")[0]

// Makes sure js has the config file
fetch(`https://${GetParentResourceName()}/loaded`, {
    method: "POST",
}).then(resp => resp.json()).then(function(tags) {
    allowedTags = tags
}).catch()

//let loremipsum = "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc."
//allowedTags = loremipsum.split(" ")

// Lua requests
window.addEventListener("message", function(event) {
    let data = event.data
    switch (data.action) {
        case "open":
            showUi(data.players)
            break
    }
})

function showUi(list) {
    updateList(list)
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

function search(text) {
    if (text.trim().length == 0) {
        fetch(`https://${GetParentResourceName()}/onlineList`, {
            method: "POST",
        }).then(resp => resp.json()).then(function(list) {
            updateList(list)
        })
    } else {
        fetch(`https://${GetParentResourceName()}/search`, {
            method: "POST",
            body: JSON.stringify({ name: text.split(" ")})
        }).then(resp => resp.json()).then(function(list) {
            updateList(list)
        })
    }
}

function selectPlayer(identifier) {
    fetch(`https://${GetParentResourceName()}/selectPlayer`, {
        method: "POST",
        body: JSON.stringify({ identifier: identifier })
    }).then(resp => resp.json()).then(function(info) {
        displayInfo(info)
    })
}

function updateList(list) {
    list_buttons.innerHTML = ""
    for (let i = 0; i < Object.keys(list).length; i++) {
        list_buttons.innerHTML +=
        `<button id="${list[i].identifier}" class="plist_button" onclick="selectPlayer(this.id)">${list[i].name}</button>`
    }
}

function displayInfo(info) {
    if (!info) { return }
    player_name.innerHTML = `${info.firstname} ${info.lastname}`
    player_group.innerHTML = info.group
    player_identifier.innerHTML = info.identifier
    player_identifier.title = info.identifier
    ownedTags = info.br_tags
    renderItems(allowedTags)
}

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

// Tag search

function renderItems(tagList) {
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

function filterItems(searchTerm) {
    return allowedTags.filter(item => 
        item.toLowerCase().includes(searchTerm.toLowerCase())
    )
}

tag_search.addEventListener("input", (e) => {
    const filteredItems = filterItems(e.target.value)
    renderItems(filteredItems)
})