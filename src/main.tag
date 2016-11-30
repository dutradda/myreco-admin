<main>
  <h1>MyReco Admin</h1>
  <h2>{this.content_tag.title}</h2>
  <div id='content' style='padding:10px;background-color:#f2f2f2'></div>

  <script type="es6">
    'use strict;'

    if (opts.app == undefined || opts.app.user == undefined)
      riot.route(opts.app.pages.login)
    else if (opts.uri == undefined)
      this.content_tag = riot.mount(this.content, opts.app.collections.placements, {app: opts.app})[0]
    else {
      this.content_tag = riot.mount(this.content, opts.uri, {app: opts.app, uri: opts.uri, action: opts.action, id_: opts.id_})[0]
    }

  </script>
</main>
