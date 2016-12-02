<placement-edit>

    <fieldset if={ placementViewData != undefined }>
        <legend><h3>{ ((this.create) ? 'New ' : 'Edit ') + 'Placement'}</h3></legend>
        <label>Hash:</label>{ placementViewData.hash }
        <br/>
        <label>Small Hash:</label>{ placementViewData.small_hash }
        <br/>
        <label>Name:</label>
        <input type="text" id="name" value="{ placementViewData.name }" onkeyup="{ onKeyUp }"/>
        <br/>
        <label>Store:</label>
        <stores-select user={ opts.app.user } onchange={ chooseStore }/>
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
                    <variation-edit variation="{ variation }" app="{ app }"/>
                    <br/>
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

    <script>
        'use strict;'

        this.placementPatch = {}
        this.patchedVariations = []
        this.app = opts.app

        this.updateView = () => {
            if (opts.itemId == undefined) {
                this.create = true
                this.placementViewData = {variations: []}
                this.placementPatch.store_id = JSON.parse(opts.app.user.selectedStore)
                this.update()
            } else {
                this.placementViewData = {}
                let uri = `/placements/${opts.itemId}`
                opts.app.myrecoApi.get(uri, this.updateViewCallback, opts.failure)
            }
        }

        this.updateViewCallback = (response) => {
            if (response == undefined)
                opts.app.setPageNotFound()
            else {
                this.placementViewData = response.body
                this.update()
            }
        }

        this.onKeyUp = (event) => {
            let value = null
            if (event.target.id == 'name')
                value = event.target.value
            else if (event.target.value != '')
                value = JSON.parse(event.target.value)

            this.placementViewData[event.target.id] = value
            this.placementPatch[event.target.id] = value
        }

        this.chooseStore = (event) => {
            let value = JSON.parse(event.target.options[event.target.selectedIndex].value)
            this.placementViewData['store_id'] = value
            this.placementPatch['store_id'] = value
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

        this.removeItemFromArray = (array, item) => {
            let index = array.indexOf(item)
            if (index != -1)
                array.splice(index, 1)
        }

        this.addVariationOnClick = () => {
            this.placementViewData.variations.push({weight:null, _operation: 'insert'})
        }

        this.cancelOnClick = () => {
            route('placements')
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
                opts.app.success('placements')()
            }

            else if (this.create) {
                uri = '/placements'
                opts.app.myrecoApi.post(uri, opts.app.success('placements'), opts.app.failure, undefined, [placementPatch])
            }
            else {
                uri = `/placements/${small_hash}`
                opts.app.myrecoApi.patch(uri, opts.app.success('placements'), opts.app.failure, undefined, placementPatch)
            }
        }

        this.cloneObject = (object) => {
            let newObject = {}
            for (let attrName of Object.keys(object))
                newObject[attrName] = object[attrName]
            return newObject
        }

        this.on('mount', this.updateView)
    </script>

</placement-edit>