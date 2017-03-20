<slots-select>
    <select ref="slotsSelect" onchange={this.chooseSlot} hidden>
        <option each={slot in this.availableSlots} value={slot.id}>{slot.name}</option>
    </select>

     <script>
        'use strict;'

        if (this.opts.buttonName == undefined)
            this.opts.buttonName == 'Slot'

        chooseSlot(event) {
            this.selectedSlotId = JSON.parse(event.target.options[event.target.selectedIndex].value)
        }

        setAvailableSlots(callback) {
            router.myrecoApi.get(`/slots?store_id=${router.user.selectedStore}`, callback, this.parent.failure)
        }

        getSlotsCallback(response) {
            this.available_slots = []

            for (let slot of response.body) {
                if (this.opts.currentSlotId != slot.id)
                    this.available_slots.push(slot)
            }

            if (this.available_slots.length)
                this.enableSlotsSelect()
        }

        enableSlotsSelect() {
            this.refs.slotsSelect.hidden = false
            this.selectedSlotId = this.available_slots[0].id
        }

        this.on('mount', () => {this.setAvailableSlots(this.getSlotsCallback)})
     </script>
</slots-select>
