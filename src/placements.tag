<placements>

    <placements-list hidden></placements-list>
    <placement-edit hidden></placement-edit>

    <script type="es6">
        'use strict;'

        this.init = () => {
            this.app = opts.app
            this.title = 'Placements'
            this.allSlots = []

            if (opts.uri == undefined || opts.action == undefined || opts.id == undefined) {
                uri = `/placements?store_id=${this.app.user.selected_store}`
                this.app.myrecoApi.get(uri, this.getAllPlacementsCallback, this.failure)

            } else if (opts.uri == 'placements' && opts.action == 'edit' && opts.id_ != undefined) {
                uri = `/placements/${opts.id_}`
                callback = () => {
                    this.app.myrecoApi.get(uri, this.editPlacementCallback, this.failure)
                }
                this.getAllSlotsAndPlacements(callback)

            } else if (opts.uri == 'placements' && opts.action == 'create') {
                this.getAllSlotsAndPlacements(this.createPlacementCallback)

            } else {
                riot.route('not-found')
            }
        }

        this.getAllPlacementsCallback = (response) => {
            this.tags['placements-list'].setPlacements(response.body)
            this.tags['placements-list'].root.hidden = false
            this.tags['placement-edit'].root.hidden = true
        }

        this.getAllSlotsAndPlacements = (placementsCallback) => {
            callback = (response) => {
                this.getAllSlotsCallback(response)
                placementsCallback()
            }
            this.app.myrecoApi.get(`/slots?store_id=${this.app.user.selected_store}`, callback, this.failure)
        }

        this.getAllSlotsCallback = (response) => {
            this.allSlots = response.body
        }

        this.editPlacementCallback = (response) => {
            this.tags['placement-edit'].setPlacement(response.body)
            this.tags['placement-edit'].root.hidden = false
            this.tags['placements-list'].root.hidden = true
        }

        this.createPlacementCallback = (response) => {
            this.tags['placement-edit'].setPlacement()
            this.tags['placement-edit'].root.hidden = false
            this.tags['placements-list'].root.hidden = true
        }

        this.success = (response) => {
            riot.route('placements')
        }

        this.failure = (response) => {
          console.log(response)
        }

        this.init()
    </script>

</placements>

<placements-list>

    <form>
        <fieldset>
        <legend><h3>All Placements</h3></legend>
        <br/>
        <button onclick="{ createOnClick }">Create new placement</button>
        <br/><br/>
        <ul>
            <li each={ placementsViewData }>
                <fieldset>
                    <b>Name:&nbsp;</b>{ name }
                    <br/>
                    <b>Hash:&nbsp;</b>{ hash }
                    <br/>
                    <b>Small Hash:&nbsp;</b>{ small_hash }
                    <br/>
                    <b>Distribute Recommendations:</b>
                    <input type="checkbox" checked="{ distribute_recos }" disabled />
                    <br/>
                    <b>In A/B Test:</b>
                    <input type="checkbox" checked="{ ab_testing }" disabled />
                    <br/>
                    <b>Show Recommendations Details:</b>
                    <input type="checkbox" checked="{ show_details }" disabled />
                    <br/>
                    <b>Variations:</b>
                    <ul>
                        <li each={ variations }>
                            <b>Id:&nbsp;</b>{ id }
                            <br/>
                            <b>Weight:&nbsp;</b>{ weight }
                            <br/><br/>
                            <b>Slots:</b>
                            <ul>
                                <li each={ slots }>
                                    <b>Id:&nbsp;</b>{ id }
                                    <br/>
                                    <b>name:&nbsp;</b>{ name }
                                </li>
                            </ul>
                        </li>
                    </ul>
                    <button onclick="{ editOnClick }">Edit</button>&nbsp;
                    <button onclick="{ deleteOnClick }">Delete</button>
                </fieldset>
                <br/>
            </li>
        </ul>
        </fieldset>
    </form>

    <script type="es6">
        'use strict;'

        this.createOnClick = () => {
            riot.route('placements/create')
        }

        this.editOnClick = (event) => {
            riot.route(`placements/edit/${event.item.small_hash}`)
        }

        this.deleteOnClick = (event) => {
            uri = `/placements/${event.item.small_hash}`
            this.parent.app.myrecoApi.delete(uri, this.success(event.item), this.parent.failure)
        }

        this.success = (placement) => {
            return () => {
                index = this.placementsViewData.indexOf(placement)
                this.placementsViewData.splice(index, 1)
                this.update()
            }
        }

        this.setPlacements = (placements) => {
            this.placementsViewData = placements
            this.update()
        }
    </script>

</placements-list>

<placement-edit>

    <form>
        <fieldset>
        <legend><h3>{ ((this.create) ? 'New ' : 'Edit ') + 'Placement'}</h3></legend>
        <label>Hash:</label>{ placementViewData.hash }
        <br/>
        <label>Small Hash:</label>{ placementViewData.small_hash }
        <br/>
        <label>Name:</label>
        <input type="text" id="name" value="{ placementViewData.name }" onkeyup="{ onKeyUp }"/>
        <br/>
        <label>Store Id:</label>
        <input type="text" id="store_id" value="{ placementViewData.store_id }" onkeyup="{ onKeyUp }"/>
        <br/>
        <label>Distribute Recommendations:</label>
        <input type="checkbox" id="distribute_recos" checked="{ placementViewData.distribute_recos }" onclick="{ onCheckBoxClick }"/>
        <br/>
        <label>In A/B Test:</label>
        <input type="checkbox" id="ab_testing" checked="{ placementViewData.ab_testing }" onclick="{ onCheckBoxClick }"/>
        <br/>
        <label>Show Recommendations Details:</label>
        <input type="checkbox" id="show_details" checked="{ placementViewData.show_details }" onclick="{ onCheckBoxClick }"/>
        <br/>
        <label>Variations:</label>
        <ul>
            <li each={ variation in placementViewData.variations }>
                <fieldset>
                    <variation-edit variation="{ variation }"/>
                    <button onclick="{ deleteVariationOnClick }">Delete Variation</button>
                </fieldset>
                <br/>
            </li>
        </ul>
        <br/>
        <button onclick="{ addVariationOnClick }">Add Variation</button>
        <br/>
        <button onclick="{ cancelOnClick }">Cancel</button>
        <button onclick="{ okOnClick }">OK</button>
        </fieldset>
    </form>

    <script type="es6">
        'use strict;'

        this.placementPatch = {}
        this.patchedVariations = []

        this.onKeyUp = (event) => {
            let value = null
            if (event.target.id == 'name')
                value = event.target.value
            else if (event.target.value != '')
                value = JSON.parse(event.target.value)

            this.placementViewData[event.target.id] = value
            this.placementPatch[event.target.id] = value
        }

        this.onCheckBoxClick = (event) => {
            this.placementViewData[event.target.id] = event.target.checked
            this.placementPatch[event.target.id] = event.target.checked
        }

        this.deleteVariationOnClick = (event) => {
            if (this.isNotNewVariation(event.item.variation))
                this.patchedVariations.push({id: event.item.variation.id, _operation: 'delete'})

            this.removeItemFromArray(this.placementViewData.variations, event.item.variation)
        }

        this.isNotNewVariation = (variation) => {
            return (variation.id != undefined)
        }

        this.findCallback = (id) => {
            return (item) => { return (item.id == id) }
        }

        this.removeItemFromArray = (array, item) => {
            let index = array.indexOf(item)
            if (index != -1)
                array.splice(index, 1)
        }

        this.addVariationOnClick = () => {
            this.placementViewData.variations.push({weight:null, _operation: 'insert'})
        }

        this.cancelOnClick = () => {
            riot.route('placements')
        }

        this.okOnClick = () => {
            let small_hash = this.placementViewData.small_hash
            let uri = null
            let placementPatch = this.cloneObject(this.placementPatch)
            placementPatch.variations = [].concat(this.patchedVariations)

            for (let variation of this.placementViewData.variations)
                if (variation.id == undefined) {
                    newVariation = {weight: variation.weight, _operation: variation._operation}

                    if (variation.slots != undefined && variation.slots.length) {
                        let slots = []
                        for (let slot of variation.slots)
                            slots.push({id: slot.id, _operation: 'get'})
                        newVariation.slots = slots
                    }

                    placementPatch.variations.push(newVariation)
                }

            if (!placementPatch.variations.length)
                delete placementPatch.variations

            console.log(JSON.stringify(placementPatch))

            if (!Object.keys(placementPatch).length) {
                this.parent.success()
            }

            else if (this.create) {
                uri = '/placements'
                this.parent.app.myrecoApi.post(uri, this.parent.success, this.parent.failure, undefined, [placementPatch])
            }
            else {
                uri = `/placements/${small_hash}`
                this.parent.app.myrecoApi.patch(uri, this.parent.success, this.parent.failure, undefined, placementPatch)
            }
        }

        this.cloneObject = (object) => {
            let newObject = {}
            for (let attrName of Object.keys(object))
                newObject[attrName] = object[attrName]
            return newObject
        }

        this.setPlacement = (placementViewData) => {
            if (placementViewData == undefined) {
                this.create = true
                this.placementViewData = {variations: []}
            } else
                this.placementViewData = placementViewData
            this.update()
        }
    </script>

</placement-edit>


<variation-edit>

    <label>Id:</label>{ opts.variation.id }
    <br/>
    <label>Weight:</label>
    <input type="text" id="weight" value="{ opts.variation.weight }" onkeyup="{ onWeightKeyUp }"/>
    <br/>
    <label>Slots:</label>
    <ul id="slotsList">
        <li each={ opts.variation.slots }>
            {id} - { name }
            <button onclick="{ removeSlotOnClick }">Remove Slot</button>
        </li>
    </ul>
    <br/>
    <select id="addSlotSelect" hidden>
        <option each={ available_slots } value="{ id }">{ name }</option>
    </select>
    <button id="addSlotButton" onclick="{ addSlotButtonOnClick }">Add Slot</button>

    <script type="es6">
        'use strict;'

        this.setAvailableSlots = () => {
            this.available_slots = []
            for (let slot of this.parent.parent.allSlots) {
                if (opts.variation.slots == undefined || opts.variation.slots.find(this.parent.findCallback(slot.id)) == undefined)
                    this.available_slots.push(slot)
            }

            if (this.available_slots.length)
                this.addSlotButton.disabled = false
            else
                this.addSlotButton.disabled = true
        }

        this.setAvailableSlots()

        this.onWeightKeyUp = (event) => {
            if ((event.target.value == '' && opts.variation.weight != null) || event.target.value != '') {
                let newWeight = event.target.value == '' ? null : JSON.parse(event.target.value)

                if (this.parent.isNotNewVariation(opts.variation)) {
                    patchedVariation = this.getPatchedVariation()
                    patchedVariation.weight = newWeight
                }

                opts.variation.weight = newWeight
            }
        }

        this.getPatchedVariation = () => {
            patchedVariation = this.parent.patchedVariations.find(this.parent.findCallback(opts.variation.id))
            if (patchedVariation == undefined) {
                patchedVariation = {id: opts.variation.id, _operation: 'update'}
                this.parent.patchedVariations.push(patchedVariation)
            }
            return patchedVariation
        }

        this.removeSlotOnClick = (event) => {
            if (this.parent.isNotNewVariation(opts.variation)) {
                patchedVariation = this.getPatchedVariation()

                if (patchedVariation.slots == undefined)
                    patchedVariation.slots = []

                patchedVariation.slots.push({id: event.item.id, _operation: 'remove'})
            }

            this.parent.removeItemFromArray(opts.variation.slots, event.item)
            this.setAvailableSlots()
        }

        this.removeSlotFromPatchedVariation = (patchedVariation, slotId) => {
            let slotFound = patchedVariation.slots.find(this.parent.findCallback(slotId))
            this.parent.removeItemFromArray(patchedVariation.slots, slotFound)
        }

        this.addSlotButtonOnClick = (event) => {
            if (this.addSlotButton.textContent != 'OK') {
                this.addSlotSelect.hidden = false
                this.addSlotButton.textContent = 'OK'
            } else {
                let slotId = JSON.parse(this.addSlotSelect.value)

                if (this.parent.isNotNewVariation(opts.variation)) {
                    patchedVariation = this.getPatchedVariation()
                    if (patchedVariation.slots == undefined) {
                        patchedVariation.slots = []
                        patchedVariation.slots.push({id: slotId, _operation: 'get'})
                    } else
                        this.removeSlotFromPatchedVariation(patchedVariation, slotId)
                }

                if (opts.variation.slots == undefined)
                    opts.variation.slots = []
                opts.variation.slots.push({id: slotId, name: this.addSlotSelect.textContent})

                this.setAvailableSlots()
                this.addSlotSelect.hidden = true
                this.addSlotButton.textContent = 'Add Slot'
            }
        }
    </script>

</variation-edit>
