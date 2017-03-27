<page-menu>
    <div>
        <b>Menu</b>
        <ul>
            <li each={menuItem in this.menu}>
                <a href={menuItem.href} if={this.currentItem != menuItem.title}>{menuItem.title}</a>
                <a if={this.currentItem == menuItem.title}>{menuItem.title}</a>
            </li>
        </ul>
    </div>
    <script>
        this.currentItem = this.opts.current_item
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