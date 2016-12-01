<login>

	<form>
		<fieldset>
			<legend><h3>LOGIN</h3></legend>
			<br/>
			<label>Email:</label>
			<input type="text" name="email">
			<label>Password:</label>
			<input type="password" name="password">
			<br/><br/>
			<button onclick="{login}">OK</button>
		</fieldset>
	</form>

	<script type="es6">
		'use strict;'
		this.app = opts.app
		if (this.app.user != undefined)
			riot.route(this.app.collections.placements)

		this.login = () => {
			this.app.myrecoApi.set_user(this.email.value, this.password.value)
			this.app.myrecoApi.get(`/users/${this.email.value}`, this.loginCallback, this.failure)
		}

		this.loginCallback = (response) => {
			response.body.password = this.password.value
			this.app.setUser(response.body)
			riot.route(this.app.collections.placements)
		}

		this.failure = (response) => {
			console.log(response)
			this.app.delUser()
		}
	</script>

</login>