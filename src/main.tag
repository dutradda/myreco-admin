<main>

    <br/>
    <label>Choose Store:</label>
    <stores-select user={ opts.app.user } onchange={ chooseStore }/>

    <br/><br/>
    <button onclick="{ logout }">LOGOUT</button>

    <h2>Menu</h2>
    <ul ref="menu">
        <li each={ menu in collections }>
            <a href="{ menu.href }">{ menu.title }</a>
        </li>
    </ul>

    <virtual ref="content"/>

    <script>
        'use strict;'

        this.collections = {
            placements : {
                title: 'Placements',
                href: `${opts.app.routeBase}placements`
            }
        }

        this.chooseStore = (event) => {
            opts.app.user.selectedStore = JSON.parse(event.target.options[event.target.selectedIndex].value)
            opts.app.setUser(opts.app.user)
            this.contentTag.updateView()
        }

        this.logout = () => {
            route(opts.app.pages.logout)
        }

        this.setContentTag = (uri, action, itemId) => {
            let tagName = null

            if (uri == '' && action == undefined && itemId == undefined)
                route('placements')

            else if (uri in this.collections) {
                if (action == undefined && itemId == undefined)
                    tagName = this.buildListTagName(uri)

                else if ((action == 'create' && itemId == undefined) || (action == 'edit' && itemId != undefined))
                    tagName = this.buildEditTagName(uri)
            }

            if (tagName != null)
                this.contentTag = riot.mount(this.refs.content, tagName, {app: opts.app, itemId: itemId, failure: this.failure})[0]
            else
                opts.app.setPageNotFound()
        }

        this.buildListTagName = (uri) => {
            return `${uri}-list`
        }

        this.buildEditTagName = (uri) => {
            return `${uri.substring(0, uri.length-1)}-edit`
        }

        this.failure = (error) => {
            if (error.response.status == 404)
                this.contentTag.updateViewCallback()
            else
                return opts.app.failure(error)
        }
    </script>

</main>


<stores-select>

    <select>
        <option each={ opts.user.stores } value="{ id }" selected="{ (id == user.selectedStore) }">{ name }</option>
    </select>

     <script>
         'use strict;'

         this.user = opts.user
     </script>

</stores-select>