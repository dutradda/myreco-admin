<slot-edit>
    <edit-header></edit-header>
    <alert ref="alert"></alert>
    <div ref="content" style="margin-bottom:2em;">
        <div>
            {((this.create) ? 'New ' : 'Edit ') + 'Slot'}
        </div>
        <fieldset>
            <div if={this.slotViewData.id}>
                <b>ID:</b> {this.slotViewData.id}
                <br/>
            </div>
            <div>
                <label><b>Name:</b></label>
                <input id="name" value={this.slotViewData.name} onkeyup={this.onKeyUp}>
            </div>
            <div>
                <label><b>Store:</b></label>
                <stores-select user={this.opts.myreco_client.user} disabled={true}/>
            </div>
            <div>
                <label>
                    <b>Maximum Recommendations:</b>
                    <input id="name" value={this.slotViewData.max_recos} onkeyup={this.onKeyUp}>
                </label>
            </div>
            <div>
                <label>
                    <b>Test Radio:</b>
                    <input type="radio" ref="radio" value={this.slotViewData.max_recos} onkeyup={this.onKeyUp}>
                </label>
            </div>
            <div>
                <label><b>Engine:</b></label>
                <engines-select ref="engineSelect" onchange={this.onEngineSelect}>
                </engines-select>
            </div>
            <div style="margin-bottom:0.2em;" if={this.slotViewData.slot_variables.length != 0}>
                <br/>
                <label><b>Slot Variables:</b></label>
                <virtual each={slotVariable in this.slotViewData.slot_variables}>
                    <div>
                        <slot-variable-edit slot_variable={slotVariable} slot={this.slotViewData}>
                            <br/>
                            <button onclick={this.parent.deleteSlotVariableOnClick}><b>Delete Slot Variable</b></button>
                        </slot-variable-edit>
                    </div>
                </virtual>
            </div>
            <br/>
            <br/>
            <div style="margin-left:1em;margin-bottom:1em;">
                <button onclick={this.addSlotVariableOnClick}><b>Add Slot Variable</b></button>
                <br/><br/><br/>
            </div>
            <div style="margin-bottom:0.2em;" if={this.slotViewData.fallbacks.length != 0}>
                <br/>
                <div>
                    <div style="font-weight:700;text-align:center;">
                        <div>Fallbacks</div>
                    </div>
                </div>
                <virtual each={fallback in this.slotViewData.fallbacks}>
                    <div>
                        {fallback.id} - {fallback.name}
                        <br/>
                        <button onclick={this.removeFallbackOnClick}><b>Remove Fallback</b></button>
                    </div>
                </virtual>
            </div>
            <div style="margin-left:1em;margin-bottom:1em;">
                <button onclick={this.addFallbackOnClick}><b>Add Fallback</b></button>
            </div>
            <br/><br/><br/>
            <button onclick={this.cancelOnClick} style="margin-right:1em;"><b>Cancel</b></button>
            <button onclick={this.okOnClick}><b>OK</b></button>
        </fieldset>
    </div>

    <script>
        'use strict;'

        this.slotPatch = {}
        this.patchedVariations = []
        this.slotViewData = {slot_variables: [], fallbacks: [], engine: {variables: []}}
        this.id = simpleQueryString.parse(document.location.href).id

        updateView() {
            if (this.id == undefined) {
                this.create = true
                this.slotPatch.store_id = JSON.parse(this.opts.myreco_client.user.selectedStore)
                this.update()
            } else {
                this.slotViewData = {}
                let uri = `/slots/${this.id}`
                this.opts.myreco_client.get(uri, this.updateViewCallback, this.failure)
            }
        }

        updateViewCallback(response) {
            this.update({slotViewData: response.body})
            this.refs.engineSelect.update({selectedEngine: this.slotViewData.engine_id})
            this.old_engine = this.slotViewData.engine
            this.old_slot_variables = this.slotViewData.slot_variables
        }

        addSlotVariableOnClick() {
            this.slotViewData.slot_variables.push({_operation: 'insert'})
        }

        deleteSlotVariableOnClick(event) {
            if (utils.hasKey(event.item.slotVariable, 'id'))
                this.patchedVariations.push({id: event.item.slotVariable.id, _operation: 'delete'})

            utils.removeItemFromArray(this.slotViewData.slot_variables, event.item.slotVariable)
            this.update()
        }

        onEngineSelect(event) {
            new_engine = utils.getSelectValue(event)
            if (new_engine.id != this.old_engine.id) {
                this.slotPatch.engine_id = new_engine.id
                this.slotViewData.engine_id = new_engine.id
                this.slotViewData.engine = new_engine
                this.slotViewData.slot_variables = []
                this.update()
            } else {
                this.slotPatch.engine_id = undefined
                this.slotViewData.engine_id = this.old_engine.id
                this.slotViewData.engine = this.old_engine
                this.slotViewData.slot_variables = this.old_slot_variables
            }
        }

        this.on('mount', this.updateView)
    </script>

</slot-edit>