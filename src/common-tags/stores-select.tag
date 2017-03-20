<stores-select>
    <select id="store" disabled={this.opts.disabled}>
        <option each={store in this.stores} value={store.id} selected="{(store.id == router.user.selectedStore)}">{store.name}</option>
    </select>

     <script>
        'use strict;'

        getStores(event) {
            router.myrecoApi.get('/stores', this.getStoresCallback, this.parent.failure)
        }

        getStoresCallback(response) {
            this.update({stores: response.body})
        }

        this.on('mount', this.getStores)
     </script>
</stores-select>