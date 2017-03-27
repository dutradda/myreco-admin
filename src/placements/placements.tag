<placements>
    <route path="placements" router={this.parent}>
        <items-list myreco_client={this.parent.opts.myreco_client} config={this.parent.config}/>
    </route>
    <route path="placements/create" router={this.parent}>
        <placement-edit action="create" myreco_client={this.parent.opts.myreco_client}/>
    </route>
    <route path="placements/edit/*" router={this.parent}>
        <placement-edit action="edit" myreco_client={this.parent.opts.myreco_client}/>
    </route>

    <script>
        this.config = {
            collectionName: 'Placement',
            collectionUri: 'placements',
            currentMenuItem: 'Placements',
            itemId: 'small_hash',
            properties: {
                names: ['Name', 'Small Hash', 'Distribute', 'Show Details', 'In A/B Test'],
                ids: ['name', 'small_hash', 'distribute_recos', 'show_details', 'ab_testing']
            },
            details: {
                colspan: 7,
                tagName: 'placement-details'
            }
        }
    </script>
</placements>

<placement-details>
    Variations:
    <table style="margin-left:2em;">
        <thead>
            <tr>
                <th>ID</th>
                <th>Weight</th>
            </tr>
        </thead>
        <tbody each={variation in this.opts.data.variations}>
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
</placement-details>
