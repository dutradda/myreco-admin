<alert>
    <div ref="alert" hidden>
      <button onclick={this.closeAlert}>×</button>
      <div ref="alertContent"></div>
    </div>

    <script>
        closeAlert() {
            this.refs.alert.hidden = true
            this.refs.alertContent.textContent = ''
            if (this.timeout != undefined) {
                clearTimeout(this.timeout)
                this.timeout = undefined
            }
        }

        showAlert(message) {
            this.closeAlert()
            this.refs.alertContent.textContent = message
            this.refs.alert.hidden = false
            this.timeout = setTimeout(this.closeAlert, 7000)
        }
    </script>
</alert>