<store-chooser>
    Current Store:&nbsp;
    <stores-select onchange={this.chooseStore} myreco_client={this.opts.myreco_client}></stores-select>

     <script>
        'use strict;'

        chooseStore(event) {
            selectedStore = JSON.parse(event.target.options[event.target.selectedIndex].value)
            this.opts.myreco_client.setUserSelectedStore(selectedStore)
            document.location.reload()
        }
     </script>
</store-chooser>