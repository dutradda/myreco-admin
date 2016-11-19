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
      this.user = store.get('myrecoUser')
      this.registerRoutes()

      if (this.user != undefined) {
        this.myrecoApi = new MyrecoClient(
            opts.apiUriPrefix,
            this.user.email,
            this.user.password)
        riot.route(this.collections.placements)
      }
      else {
        this.myrecoApi = new MyrecoClient(opts.apiUriPrefix)
        riot.route(this.pages.login)
      }
    }

    this.registerRoutes = () => {
      riot.route.base(opts.routeBase)
      riot.route(this.route)
      riot.route.start()
    }

    this.route = (uri, action, id) => {
      if (uri == this.pages.login) {
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

    this.mountMain = (uri, action, id) => {
      riot.mount(this.content,
        this.pages.main, {
        app: this,
        uri: uri, action: action, id: id
      })
    }

    this.setUser = (user) => {
      this.user = user
      store.set('myrecoUser', user)
    }

    this.delUser = () => {
      this.user = undefined
      store.remove('myrecoUser')
    }

    this.init()
  </script>
</myreco-admin>
