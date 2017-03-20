<login>
    <simple-header title={this.opts.title}></simple-header>
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

		if (router.user != undefined)
			router.route('/placements')

		login() {
			router.login(this.refs.email.value, this.refs.password.value)
		}

	</script>
</login>