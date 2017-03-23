<engines-select>
    <select ref="engine" disabled={this.opts.disabled}>
        <option each={engine in this.engines} value={JSON.stringify(engine)} selected={this.selectedEngine == engine.id}>{engine.name}</option>
    </select>

     <script>
        'use strict;'

        this.selectedEngine = undefined

        getEngines(event) {
            this.opts.myreco_client.get(`/engines?store_id=${this.opts.myreco_client.user.selectedStore}`, this.getEnginesCallback, this.parent.failure)
        }

        getEnginesCallback(response) {
            this.update({engines: response.body})
        }

        this.on('mount', this.getEngines)
     </script>
</engines-select>