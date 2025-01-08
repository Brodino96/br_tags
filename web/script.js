var regExp = /[a-zA-Z]/g;

window.addEventListener("message", function(event) {
    let data = event.data
    switch (data.action) {
        case "open":
            showUi(data.players)
            break
        case "update":
            updateList(data.newList)
            break
        case "showInfo":
            displayInfo(data.info)
            break
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

function showUi(list) {
    updateList(list)
}

function updateList(list) {
    document.getElementById("list_buttons").innerHTML = ""
    for (let i = 0; i < Object.keys(list).length; i++) {
        document.getElementById("list_buttons").innerHTML +=
        `<button id="${list[i].identifier}" class="plist_button" onclick="selectPlayer(this.id)">${list[i].name}</button>`
    }
}

function displayInfo(info) {
    // `firstname`, `lastname`, `group`, `job`, `job_grade`, `dateofbirth`, `tags`
    if (!info) {
        return
    }
    document.getElementById("player_name").innerHTML = `${info.firstname} ${info.lastname}`
    document.getElementById("player_group").innerHTML = info.group
    document.getElementById("player_info").innerHTML = `${info.dateofbirth} - ${info.job} - ${info.jobgrade}`
    document.getElementById("player_identifier").innerHTML = info.identifier
}