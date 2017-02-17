<stores-select>
    <select id="store" onchange={this.chooseStore}>
        <option each={store in this.user.stores} value={store.id} selected="{(store.id == user.selectedStore)}">{name}</option>
    </select>

     <script>
         'use strict;'
         this.user = this.opts.user

        chooseStore(event) {
            this.user.selectedStore = JSON.parse(event.target.options[event.target.selectedIndex].value)
            router.setUser(this.user)
        }
     </script>
</stores-select>