<placement-edit>
    <edit-header></edit-header>
    <alert ref="alert"></alert>
    <div ref="content" style="margin-bottom:2em;">
        <div>
            <h3>{((this.create) ? 'New ' : 'Edit ') + 'Placement'}</h3>
        </div>
        <fieldset>
            <div if={this.placementViewData.hash}>
                <b>Hash:</b> {this.placementViewData.hash}
                <br/>
            </div>
            <div if={this.placementViewData.small_hash}>
                <b>Small Hash:</b> {this.placementViewData.small_hash}
                <br/>
            </div>
            <div>
                <label><b>Name:</b></label>
                <input id="name" value={this.placementViewData.name} onkeyup={this.onKeyUp}>
            </div>
            <div>
                <label><b>Store:</b></label>
                <stores-select user={this.user} onchange_callback={this.chooseStore} disabled={true} myreco_client={this.opts.myreco_client}/>
            </div>
            <div>
                <label>
                    <b>Distribute Recommendations:</b>
                    <input type="checkbox" id="distribute_recos" checked={this.placementViewData.distribute_recos} onclick={this.onCheckBoxClick}/>
                </label>
            </div>
            <div>
                <label>
                    <b>In A/B Test:</b>
                    <input type="checkbox" id="ab_testing" checked={this.placementViewData.ab_testing} onclick={this.onCheckBoxClick}/>
                </label>
            </div>
            <div>
                <label>
                    <b>Show Recommendations Details:</b>
                    <input type="checkbox" id="show_details" checked={this.placementViewData.show_details} onclick={this.onCheckBoxClick}/>
                </label>
            </div>
            <div style="margin-bottom:0.2em;" if={this.placementViewData.variations.length != 0}>
                <br/>
                <label><b>Variations:</b></label>
                <virtual each={variation in this.placementViewData.variations}>
                    <div>
                        <variation-edit variation={variation} myreco_client={this.parent.opts.myreco_client}/>
                        <br/>
                        <button onclick={this.deleteVariationOnClick}><b>Delete Variation</b></button>
                    </div>
                </virtual>
            </div>
        </fieldset>
        <div style="margin-left:1em;margin-bottom:1em;">
            <button onclick={this.addVariationOnClick}><b>Add Variation</b></button>
            <br/><br/><br/>
            <button onclick={this.cancelOnClick} style="margin-right:1em;"><b>Cancel</b></button>
            <button onclick={this.okOnClick}><b>OK</b></button>
        </div>
    </div>

    <script>
        'use strict;'

        this.placementPatch = {}
        this.patchedVariations = []
        this.placementViewData = {variations: []}
        // this.small_hash = route.query().small_hash
        this.user = opts.myreco_client.user

        updateView() {
            if (this.small_hash == undefined) {
                this.create = true
                this.placementPatch.store_id = JSON.parse(this.user.selectedStore)
                this.update()
            } else {
                this.placementViewData = {}
                let uri = `/placements/${this.small_hash}`
                this.opts.myreco_client.get(uri, this.updateViewCallback, this.failure)
            }
        }

        updateViewCallback(response) {
            this.placementViewData = response.body
            this.update()
        }

        onKeyUp(event) {
            let value = null
            if (event.target.id == 'name')
                value = event.target.value
            else if (event.target.value != '')
                value = JSON.parse(event.target.value)

            this.placementViewData[event.target.id] = value
            this.placementPatch[event.target.id] = value
        }

        chooseStore(event) {
            let value = JSON.parse(event.target.options[event.target.selectedIndex].value)
            this.placementViewData['store_id'] = value
            this.placementPatch['store_id'] = value
        }

        onCheckBoxClick(event) {
            this.placementViewData[event.target.id] = event.target.checked
            this.placementPatch[event.target.id] = event.target.checked
        }

        deleteVariationOnClick(event) {
            if (this.isNotNewVariation(event.item.variation))
                this.patchedVariations.push({id: event.item.variation.id, _operation: 'delete'})

            this.removeItemFromArray(this.placementViewData.variations, event.item.variation)
        }

        isNotNewVariation(variation) {
            return (variation.id != undefined)
        }

        removeItemFromArray(array, item) {
            let index = array.indexOf(item)
            if (index != -1)
                array.splice(index, 1)
        }

        addVariationOnClick() {
            this.placementViewData.variations.push({weight:null, _operation: 'insert'})
        }

        cancelOnClick() {
            route('/placements')
        }

        okOnClick() {
            small_hash = this.placementViewData.small_hash
            uri = null
            placementPatch = this.cloneObject(this.placementPatch)
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

            success = () => route('/placements')

            if (!Object.keys(placementPatch).length) {
                route('/placements')
            }

            else if (this.create) {
                uri = '/placements'
                this.opts.myreco_client.post(uri, success, this.failure, undefined, [placementPatch])
            }
            else {
                uri = `/placements/${small_hash}`
                this.opts.myreco_client.patch(uri, success, this.failure, undefined, placementPatch)
            }
        }

        cloneObject(object) {
            let newObject = {}
            for (let attrName of Object.keys(object))
                newObject[attrName] = object[attrName]
            return newObject
        }

        failure(error) {
            if (error.response.status == 400) {
                this.refs.alert.showAlert(error.response.body.message)
            } else if (error.response.status == 404) {
                this.refs.content.textContent = 'Placement not found'
            }
        }

        this.on('mount', this.updateView)
        this.on('route', small_hash => this.small_hash = small_hash)
    </script>

</placement-edit>