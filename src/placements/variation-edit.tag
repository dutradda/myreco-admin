<variation-edit>
    <fieldset style="width:40em;">
        <div if={this.opts.variation.id}>
            Id: {this.opts.variation.id}
            <br/>
        </div>
        <div style="width:3em;">
            <label>Weight:</label>
            <input type="text" id="weight" value={this.opts.variation.weight} onkeyup={this.onWeightKeyUp}/>
        </div>
        <div>
            <div style="margin-bottom:0.2em;" if={this.opts.variation.slots}>
                <br/>
                <div><b>Slots</b></div>
                <div each={slot in this.opts.variation.slots}>
                    <div>
                        <div>
                            {slot.id} - {slot.name}
                            <button onclick={this.removeSlotOnClick}><b>Remove</b></button>
                        </div>
                    </div>
                </div>
            </div>
            <select ref="slotsSelect" hidden>
                <option each={slot in this.available_slots} ref={'slot_' + slot.id} value={slot.id}>{slot.name}</option>
            </select>
            <b><button ref="addSlotButton" onclick={this.addSlotButtonOnClick} hidden>Add Slot</button></b>
        </div>
    </fieldset>

    <script>
        'use strict;'

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
            patchedVariation = this.parent.patchedVariations.find(router.findCallback(opts.variation.id))
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

                patchedVariation.slots.push({id: event.item.slot.id, _operation: 'remove'})
            }

            this.parent.removeItemFromArray(opts.variation.slots, event.item.slot)
            this.deleteEmptySlots(opts.variation)
            this.setAvailableSlots(this.getSlotsCallback)
        }

        this.removeSlotFromPatchedVariation = (patchedVariation, slotId) => {
            let slotFound = patchedVariation.slots.find(router.findCallback(slotId))
            this.parent.removeItemFromArray(patchedVariation.slots, slotFound)
            this.deleteEmptySlots(patchedVariation)
        }

        this.deleteEmptySlots = (variation) => {
            if (!variation.slots.length)
                delete variation.slots
        }

        this.addSlotButtonOnClick = (event) => {
            if (opts.variation.slots == undefined)
                opts.variation.slots = []

            if (this.refs.addSlotButton.textContent === 'Add Slot')
                this.setAvailableSlots(this.enableSlotsSelect)

            else {
                let slotId = JSON.parse(this.refs.slotsSelect.value)
                let slotName = this.refs['slot_'+slotId].textContent

                if (this.parent.isNotNewVariation(opts.variation)) {
                    patchedVariation = this.getPatchedVariation()
                    if (patchedVariation.slots == undefined) {
                        patchedVariation.slots = []
                        patchedVariation.slots.push({id: slotId, _operation: 'get'})
                    } else
                        this.removeSlotFromPatchedVariation(patchedVariation, slotId)
                }

                opts.variation.slots.push({id: slotId, name: slotName})
                this.setAvailableSlots(this.getSlotsCallback)
            }
        }

        this.setAvailableSlots = (callback) => {
            router.myrecoApi.get(`/slots?store_id=${router.user.selectedStore}`, callback, this.failure)
        }

        this.getSlotsCallback = (response) => {
            this.available_slots = []

            for (let slot of response.body) {
                if (opts.variation.slots == undefined || opts.variation.slots.find(router.findCallback(slot.id)) == undefined)
                    this.available_slots.push(slot)
            }

            if (!this.available_slots.length)
                this.disableSlotsSelect()
            else
                this.enableSlotsAddButton()
        }

        this.enableSlotsAddButton = () => {
            this.refs.slotsSelect.hidden = true
            this.refs.addSlotButton.hidden = false
            this.refs.addSlotButton.textContent = 'Add Slot'
            this.refs.addSlotButton.disabled = false
        }

        this.disableSlotsSelect = () => {
            this.refs.slotsSelect.hidden = true
            this.refs.addSlotButton.textContent = 'No slots found'
            this.refs.addSlotButton.disabled = true
            this.refs.addSlotButton.hidden = false
        }

        this.enableSlotsSelect = (response) => {
            this.getSlotsCallback(response)

            if (this.available_slots.length) {
                this.refs.addSlotButton.textContent = 'OK'
                this.refs.slotsSelect.hidden = false
                this.update()
            }
        }

        this.failure = (error) => {
            if (error.response.status == 404)
                this.disableSlotsSelect()
            else
                router.failure(error)
        }

        this.on('mount', () => {this.setAvailableSlots(this.getSlotsCallback)})
    </script>

</variation-edit>
