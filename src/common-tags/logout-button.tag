<logout-button>
    <button onclick={this.logout}><b>Logout</b></button>
    <script>
        logout() {
            router.logout()
        }
    </script>
</logout-button>