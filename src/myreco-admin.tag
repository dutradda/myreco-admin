<myreco-admin>
    <div>
        <img src="/images/logo.png" style="background-color:black; border:4px black solid;"/>
        <div>
            <h1>{this.title}</h1>
        </div>
    </div>
    <router>
        <placements-router myreco_client={this.parent.myrecoClient}/>
        <route path="">
            <placements-redirect />
        </route>
        <route path="login">
            <login myreco_client={this.parent.parent.myrecoClient}/>
        </route>
        <route path="logout">
            <logout myreco_client={this.parent.parent.myrecoClient}/>
        </route>
        <route path="*">
            <not-found name="PAGE"/>
        </route>
    </router>

    <script>
        route.base(CONFIG.routePrefix)
        this.title = CONFIG.title
        document.title = this.title
        this.myrecoClient = new MyrecoClient(CONFIG.apiUriPrefix, () => route('login'))
    </script>
</myreco-admin>

<placements-redirect>
    <script>
        route('placements')
    </script>
</placements-redirect>

<logout>
    <script>
        this.opts.myreco_client.delUser()
        route('login')
    </script>
</logout>
