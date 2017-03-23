<placements-router>
    <route path="placements" router={this.parent}>
        <placements-list myreco_client={this.parent.opts.myreco_client}/>
    </route>
    <route path="placements/create" router={this.parent}>
        <placement-edit action="create" myreco_client={this.parent.opts.myreco_client}/>
    </route>
    <route path="placements/edit/*" router={this.parent}>
        <placement-edit action="edit" myreco_client={this.parent.opts.myreco_client}/>
    </route>
</placements-router>
