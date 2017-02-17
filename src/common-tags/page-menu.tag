<page-menu>
    <div>
        <b>Menu</b>
        <ul>
            <li each={menuItem in this.menu}><a href={menuItem.href}>{menuItem.title}</a></li>
        </ul>
    </div>
    <script>
        this.menu = {
            placements : {
                title: 'Placements',
                href: `/placements`
            },
            slots : {
                title: 'Slots',
                href: `/slots`
            }
        }
    </script>
</page-menu>