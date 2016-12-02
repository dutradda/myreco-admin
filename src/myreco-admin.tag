<myreco-admin>

    <style type="text/css">
        ul {
            list-style: none;
        }
    </style>

    <h1>{ opts.title }</h1>

    <div style='padding:1px;background-color:#f2f2f2'>
        <virtual ref="page"/>
    </div>

    <script>
        'use strict;'

        this.init = () => {
            document.title = opts.title
            this.routeBase = opts.routeBase

            this.pages = {
                login: 'login',
                logout: 'logout',
                main: 'main',
                notFound: 'not-found'
            }

            this.setUser(store.get('myrecoUser'))
            this.setMyrecoClient()
            this.registerRoutes()
        }

        this.setUser = (user) => {
            this.user = user

            if (this.user != undefined) {
                store.set('myrecoUser', this.user)
                if (this.user.selectedStore == undefined && this.user.stores.length > 0)
                    this.user.selectedStore = this.user.stores[0].id
            }
        }

        this.setMyrecoClient = () => {
            if (this.user != undefined) {
                this.myrecoApi = new MyrecoClient(
                    opts.apiUriPrefix,
                    this.user.email,
                    this.user.password)
            } else
                this.myrecoApi = new MyrecoClient(opts.apiUriPrefix)
        }

        this.registerRoutes = () => {
          route.base(this.routeBase)
          route(this.route)
          route.start(true)
        }

        this.route = (uri, action, id) => {
            if (uri == this.pages.login)
                this.mountPage(uri)

            else if (this.user == undefined || uri == this.pages.logout)
                this.logout()

            else  {
                this.mountPage(this.pages.main)
                this.page.setContentTag(uri, action, id)
            }

        }

        this.mountPage = (tagName) => {
            this.page = riot.mount(this.refs.page, tagName, {app: this})[0]
        }

        this.logout = () => {
            this.user = undefined
            store.remove('myrecoUser')
            route(this.pages.login)
        }

        this.success = (uri) => {
            return () => {route(uri)}
        }

        this.failure = (error) => {
            console.log({status: error.response.status, body: error.response.body})
            if (error.response.status == 401)
                this.logout()
        }

        this.setPageNotFound = () => {
            this.mountPage(this.pages.notFound)
        }

        this.findCallback = (id) => {
            return (item) => { return (item.id == id) }
        }

        this.on('mount', this.init)
  </script>

</myreco-admin>