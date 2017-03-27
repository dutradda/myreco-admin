<slots>
    <route path="slots" router={this.parent}>
        <items-list myreco_client={this.parent.opts.myreco_client} config={this.parent.config}/>
    </route>
    <route path="slots/create" router={this.parent}>
        <slot-edit action="create" myreco_client={this.parent.opts.myreco_client}/>
    </route>
    <route path="slots/edit/*" router={this.parent}>
        <slot-edit action="edit" myreco_client={this.parent.opts.myreco_client}/>
    </route>

    <script>
        this.config = {
            collectionName: 'Slot',
            collectionUri: 'slots',
            currentMenuItem: 'Slots',
            itemId: 'id',
            properties: {
                names: ['Name', 'Maximum Items', 'ID'],
                ids: ['name', 'max_items', 'id']
            },
            details: {
                colspan: 7,
                tagName: 'slot-details'
            }
        }
    </script>
</slots>

<slot-details>
    <virtual if={this.opts.data.slot_filters.length}>
        Filters:
        <table style="margin-left:2em;">
            <thead>
                <tr>
                    <th>Property Name</th>
                    <th>External Variable</th>
                    <th>Is Inclusive</th>
                    <th>Filter Type</th>
                    <th>ID</th>
                </tr>
            </thead>
            <tbody each={variable in this.opts.data.slot_filters}>
                <tr style="text-align:center;">
                    <td>{variable.property_name}</td>
                    <td>{variable.external_variable_name}</td>
                    <td>{variable.is_inclusive}</td>
                    <td>{variable.type_id}</td>
                    <td>{variable.id}</td>
                </tr>
            </tbody>
        </table>
    </virtual>

    <virtual if={this.opts.data.slot_variables.length}>
        <br/><br/>
        Variables:
        <table style="margin-left:2em;">
            <thead>
                <tr>
                    <th>Engine Variable</th>
                    <th>External Variable</th>
                    <th>ID</th>
                </tr>
            </thead>
            <tbody each={variable in this.opts.data.slot_variables}>
                <tr style="text-align:center;">
                    <td>{variable.engine_variable_name}</td>
                    <td>{variable.external_variable_name}</td>
                    <td>{variable.id}</td>
                </tr>
            </tbody>
        </table>
    </virtual>

    <virtual if={this.opts.data.fallbacks.length}>
        <br/><br/>
        Fallbacks:
        <table style="margin-left:2em;">
            <thead>
                <tr>
                    <th>Name</th>
                    <th>ID</th>
                    <th>Maximum Recos</th>
                </tr>
            </thead>
            <tbody each={fallback in this.opts.data.fallbacks}>
                <tr style="text-align:center;">
                    <td>{fallback.name}</td>
                    <td>{fallback.id}</td>
                    <td>{fallback.max_items}</td>
                </tr>
            </tbody>
        </table>
    </virtual>
</slot-details>
