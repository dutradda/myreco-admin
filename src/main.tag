<main>
  <h1>{ this.title }</h1>
  <div id='content' style='padding:10px;background-color:#f2f2f2'></div>

  <script type="es6">
    'use strict;'
    this.app = opts.app
    if (opts.uri == undefined || opts.uri == 'placements') {
      this.title = 'Placements'
      this.name = 'placements'
      this.uri = 'placements'
    }

  </script>
</main>
