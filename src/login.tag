<login>
	<div>
	    <h1>Please login</h1>
    	<input type="text" ref="email">
    	<br/>
        <input type="password" ref="password">
        <br/><br/>
        <button onclick={this.login}><b>Login</b></button>
	</div>

	<script>
        'use strict;'

        init() {
            if (this.opts.myreco_client.user != undefined)
                this._successCb()   
        }

        login() {
            user = {
                email: this.refs.email.value,
                password: this.refs.password.value
            }
            this.opts.myreco_client.setUser(user)
            this.opts.myreco_client.validateUser(this._successCb, this._failureCb)
        }

        _successCb() { 
            route('/placements')
        }

        _failureCb(response, user) {
            if (user)
                alert('This user cannot be used in admin interface!')
            else
                alert('Invalid email or password!')
        }

        this.on('mount', this.init)
	</script>
</login>