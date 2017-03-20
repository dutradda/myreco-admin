<store-chooser>
    Current Store:&nbsp;
    <stores-select onchange={this.chooseStore}></stores-select>

     <script>
        'use strict;'

        chooseStore(event) {
            router.user.selectedStore = JSON.parse(event.target.options[event.target.selectedIndex].value)
            router.setUser(router.user)
            document.location.reload()
        }
     </script>
</store-chooser>