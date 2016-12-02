<placements-list>

    <fieldset if={ placementsViewData != undefined }>
    <legend><h3>All Placements</h3></legend>
    <br/>
    <button onclick="{ createOnClick }">Create new placement</button>
    <br/><br/>
    <ul>
        <li each={ placementsViewData }>
            <fieldset>
                <b>Name:&nbsp;</b>{ name }
                <br/>
                <b>Hash:&nbsp;</b>{ hash }
                <br/>
                <b>Small Hash:&nbsp;</b>{ small_hash }
                <br/>
                <b>Distribute Recommendations:</b>
                <input type="checkbox" checked="{ distribute_recos }" disabled />
                <br/>
                <b>In A/B Test:</b>
                <input type="checkbox" checked="{ ab_testing }" disabled />
                <br/>
                <b>Show Recommendations Details:</b>
                <input type="checkbox" checked="{ show_details }" disabled />
                <br/>
                <b>Variations:</b>
                <ul>
                    <li each={ variations }>
                        <b>Id:&nbsp;</b>{ id }
                        <br/>
                        <b>Weight:&nbsp;</b>{ weight }
                        <br/><br/>
                        <b>Slots:</b>
                        <ul>
                            <li each={ slots }>
                                <b>Id:&nbsp;</b>{ id }
                                <br/>
                                <b>name:&nbsp;</b>{ name }
                            </li>
                        </ul>
                    </li>
                </ul>
                <button onclick="{ editOnClick }">Edit</button>&nbsp;
                <button onclick="{ deleteOnClick }">Delete</button>
            </fieldset>
            <br/>
        </li>
    </ul>
    </fieldset>

    <script>
        'use strict;'

        this.updateView = () => {
            let uri = `/placements?store_id=${opts.app.user.selectedStore}`
            opts.app.myrecoApi.get(uri, this.updateViewCallback, opts.failure)
        }

        this.updateViewCallback = (response) => {
            this.placementsViewData = (response != undefined) ? response.body : []
            this.update()
        }

        this.createOnClick = () => {
            route('placements/create')
        }

        this.editOnClick = (event) => {
            route(`placements/edit/${event.item.small_hash}`)
        }

        this.deleteOnClick = (event) => {
            uri = `/placements/${event.item.small_hash}`
            callback = () => { this.updateView() }
            opts.app.myrecoApi.delete(uri, callback, opts.app.failure)
        }

        this.on('mount', this.updateView)
    </script>

</placements-list>