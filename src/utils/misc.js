
function hasKey(item, key) {
    return (item[key] != undefined)
}

function removeItemFromArray(array, item) {
    let index = array.indexOf(item)
    if (index != -1)
        array.splice(index, 1)
}

function bindSelectValue(item, key_name, skip_json) {
    callback = (event) => {
        value = event.target.options[event.target.selectedIndex].value
        value = _setValue(item, key_name, value, skip_json)
    }
    return callback
}

function _setValue(item, key_name, value, skip_json) {
    if (!skip_json)
        value = JSON.parse(value)
    item[key_name] = value
    item._operation = 'update'
}

function bindInputTextValue(item, key_name, skip_json) {
    callback = (event) => {
        value = event.target.value
        value = _setValue(item, key_name, value, skip_json)
    }
    return callback
}

function bindCheckBoxValue(item, key_name, skip_json) {
    callback = (event) => {
        value = event.target.checked
        value = _setValue(item, key_name, value, skip_json)
    }
    return callback
}

function getInputTextValue(event) {
    return JSON.parse(event.target.options[event.target.selectedIndex].value)
}

function findCallback(key, key_name) {
    return (item) => { return (item[key_name] == key) }
}

var utils = {
    hasKey: hasKey,
    removeItemFromArray: removeItemFromArray,
    findCallback: findCallback
}