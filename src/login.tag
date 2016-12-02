<login>

	<fieldset>
		<legend><h3>LOGIN</h3></legend>
		<br/>
		<label>Email:</label>
		<input type="text" ref="email">
		<label>Password:</label>
		<input type="password" ref="password">
		<br/><br/>
		<button onclick="{login}">OK</button>
	</fieldset>

	<script>
		'use strict;'
		if (opts.app.user != undefined)
			route('placements')

		this.login = () => {
			opts.app.myrecoApi.setUser(this.refs.email.value, this.refs.password.value)
			opts.app.myrecoApi.get(`/users/${this.refs.email.value}`, this.loginCallback, opts.app.failure)
		}

		this.loginCallback = (response) => {
			response.body.password = this.refs.password.value
			opts.app.setUser(response.body)
			route('placements')
		}
	</script>

</login>