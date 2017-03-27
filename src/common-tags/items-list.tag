<items-list>
    <list-header myreco_client={this.opts.myreco_client} current_menu_item={this.config.currentMenuItem}></list-header>
    <button onclick={this.createOnClick}><b>New {this.opts.config.collectionName}</b></button>
    <virtual if={this.collectionData}>
        <br/><br/>
        <table style="border: 1px solid;">
            <thead>
                <tr>
                    <th style="border-top: 1px solid;" each={propertyName in this.config.properties.names}>
                        {propertyName}
                    </th>
                    <th style="border-top: 1px solid;">Edit</th>
                    <th style="border-top: 1px solid;">Delete</th>
                </tr>
            </thead>
            <tbody each={item in collectionData}>
                <tr style="text-align:center;">
                    <th style="border-top: 1px solid;" each={propertyId in this.config.properties.ids}>
                        {item[propertyId]}
                    </th>
                    <th style="border-top: 1px solid;"><button onclick={this.editOnClick}>Edit</button></th>
                    <th style="border-top: 1px solid;"><button onclick={this.deleteOnClick}>Delete</button></th>
                </tr>
                <tr>
                    <td colspan={this.config.details.colspan}>
                        <div data-is={this.config.details.tagName} data={item}></div>
                    </td>
                </tr>
                <tr><td colspan={this.config.details.colspan}><br/></td></tr>
            </tbody>
        </table>
    </virtual>

    <script>
        'use strict;'
        this.config = this.opts.config

        this.updateView = () => {
            let uri = `/${this.opts.config.collectionUri}?store_id=${this.opts.myreco_client.user.selectedStore}`
            this.opts.myreco_client.get(uri, this.updateViewCallback)
        }

        updateViewCallback(response) {
            this.collectionData = (response != undefined) ? response.body : {}
            this.update()
        }

        this.createOnClick = () => {
            route(`${this.opts.config.collectionUri}/create`)
        }

        editOnClick(event) {
            route(`${this.opts.config.collectionUri}/edit/${event.item.item[this.opts.config.itemId]}`)
        }

        deleteOnClick(event) {
            uri = `/${this.opts.config.collectionUri}/${event.item.item[this.opts.config.itemId]}`
            this.opts.myreco_client.delete(uri, this.updateView)
        }

        this.on('mount', this.updateView)
    </script>

</items-list>
