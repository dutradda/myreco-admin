<logout-button>
    <button onclick={this.logout}><b>Logout</b></button>

    <script>
        logout() {
            route('logout')
        }
    </script>
</logout-button>