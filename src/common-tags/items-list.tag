<items-list>
    <virtual if={placementsViewData != undefined}>
        <button onclick={createOnClick}><b>New Placement</b></button>
        <br/><br/>
        <table style="border: 1px solid;">
            <thead>
                <tr>
                    <th style="border-top: 1px solid;">Name</th>
                    <th style="border-top: 1px solid;">Small Hash</th>
                    <th style="border-top: 1px solid;">Distribute</th>
                    <th style="border-top: 1px solid;">Show Details</th>
                    <th style="border-top: 1px solid;">In A/B Test</th>
                    <th style="border-top: 1px solid;">Edit</th>
                    <th style="border-top: 1px solid;">Delete</th>
                </tr>
            </thead>
            <tbody each={placement in placementsViewData}>
                <tr style="text-align:center;">
                    <th style="border-top: 1px solid;">{placement.name}</th>
                    <th style="border-top: 1px solid;">{placement.small_hash}</th>
                    <th style="border-top: 1px solid;">{placement.distribute_recos}</th>
                    <th style="border-top: 1px solid;">{placement.show_details}</th>
                    <th style="border-top: 1px solid;">{placement.ab_testing}</th>
                    <th style="border-top: 1px solid;"><button onclick={this.editOnClick}>Edit</button></th>
                    <th style="border-top: 1px solid;"><button onclick={this.deleteOnClick}>Delete</button></th>
                </tr>
                <tr>
                    <td colspan="7" style="border: 1px solid;">
                        Variations:
                        <table style="margin-left:2em;">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Weight</th>
                                </tr>
                            </thead>
                            <tbody each={variation in placement.variations}>
                                <tr style="text-align:center;">
                                    <td>{variation.id}</td>
                                    <td>{variation.weight ? JSON.stringify(variation.weigth) : 'null'}</td>
                                </tr>
                                <tr>
                                    <td colspan="2" style="border: 1px solid;">
                                        Slots:
                                        <table style="margin-left:2em;">
                                            <thead>
                                                <tr>
                                                    <th>ID</th>
                                                    <th>Name</th>
                                                </tr>
                                            </thead>
                                            <tbody each={slot in variation.slots}>
                                                <tr style="text-align:center;">
                                                    <td>{slot.id}</td>
                                                    <td>{slot.name}</td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2">
                                                        
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
            </tbody>
        </table>
    </virtual>

    <script>
        'use strict;'

        this.updateView = () => {
            let uri = `/${this.opts.itemsName}?store_id=${this.opts.myreco_client.user.selectedStore}`
            this.opts.myreco_client.get(uri, this.updateViewCallback)
        }

        updateViewCallback(response) {
            this.placementsViewData = (response != undefined) ? response.body : {}
            this.update()
        }

        createOnClick() {
            route('/${this.opts.itemsName}/create')
        }

        editOnClick(event) {
            queryString.stringify
            route(`/${this.opts.itemsName}/edit?small_hash=${event.item.item.small_hash}`)
        }

        deleteOnClick(event) {
            uri = `/${this.opts.itemsName}/${event.item.item.small_hash}`
            callback = () => { this.updateView() }
            this.opts.myreco_client.delete(uri, callback)
        }

        this.on('mount', this.updateView)
    </script>

</items-list>
