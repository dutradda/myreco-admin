<myreco-admin>
  <div id='content' style='padding:10px;background-color:#f2f2f2'></div>

  <script type="es6">
    'use strict;'

    // import store from 'store.js'
    // import riot from 'riot'

    this.init = () => {
      this.collections = {
        placements: 'placements'
      }
      this.pages = {
        main: 'main',
        login: 'login',
        logout: 'logout',
        notFound: 'not-found'
      }
      this.setUser(store.get('myrecoUser'))

      if (this.user != undefined) {
        this.myrecoApi = new MyrecoClient(
            opts.apiUriPrefix,
            this.user.email,
            this.user.password)
      }
      else {
        this.myrecoApi = new MyrecoClient(opts.apiUriPrefix)
      }

      this.registerRoutes()
    }

    this.registerRoutes = () => {
      riot.route.base(opts.routeBase)
      riot.route(this.route)
      riot.route.start(true)
    }

    this.route = (uri, action, id) => {
      if (uri == this.pages.login || uri == '') {
        this.mountLogin()
      }
      else if (uri == this.pages.logout) {
        this.delUser()
        riot.route(this.pages.login)
      }
      else if (uri in this.collections) {
        this.mountMain(uri, action, id)
      }
      else {
        riot.route(this.pages.notFound)
        riot.mount(this.content, this.pages.notFound)
      }
    }

    this.mountLogin = () => {
      riot.mount(this.content, this.pages.login, {app: this})
    }

    this.mountMain = (uri, action, id_) => {
      opts = {
        app: this,
        uri: uri,
        action: action,
        id_: id_
      }
      riot.mount(this.content, this.pages.main, opts)
    }

    this.setUser = (user) => {
      this.user = user

      if (this.user != undefined && this.user.selected_store == undefined && this.user.stores.length > 0)
        this.user.selected_store = this.user.stores[0].id

      if (this.user != undefined)
        store.set('myrecoUser', this.user)
    }

    this.delUser = () => {
      this.user = undefined
      store.remove('myrecoUser')
    }

    this.init()
  </script>
</myreco-admin>
