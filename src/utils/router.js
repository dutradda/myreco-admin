/* MIT License

  Copyright (c) 2016 Diogo Dutra

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE. */

'use strict;'


class MyrecoRouter {
  constructor(title, apiUriPrefix) {
    document.title = title
    this.title = title
    this.loginPage = '/login'
    this.setUser(store.get('myrecoUser'))
    this.setMyrecoClient(apiUriPrefix)
  }

  setUser(user) {
    this.user = user

    if (this.user != undefined) {
      store.set('myrecoUser', this.user)
      if (this.user.selectedStore == undefined && this.user.stores.length > 0)
        this.user.selectedStore = this.user.stores[0].id
    } else
      this.logout()
  }

  setMyrecoClient(apiUriPrefix) {
      if (this.user != undefined) {
        this.myrecoApi = new MyrecoClient(
          apiUriPrefix,
          this.user.email,
          this.user.password,
          this.failureDecorator)
      } else
        this.myrecoApi = new MyrecoClient(
          apiUriPrefix,
          undefined, undefined,
          this.failureDecorator)
  }

  logout() {
    this.user = undefined
    store.remove('myrecoUser')
    if (!document.location.href.includes(this.loginPage))
      this.route(this.loginPage)
  }

  route(uri) {
    document.location.href = uri
  }

  success(uri) {
    return () => {this.route(uri)}
  }

  failureDecorator(failure) {
    return (error) => {
      console.log(error)
      if (error.response.status == 401)
        this.logout()
      else if (failure != undefined)
        return failure(error)
    }
  }

  findCallback(id) {
    return (item) => { return (item.id == id) }
  }

  login(email, password) {
    this.myrecoApi.setUser(email, password)
    this.myrecoApi.get(`/users/${email}`, this.getLoginCallback(password))
  }

  getLoginCallback(password) {
    return (response) => {
      response.body.password = password
      router.setUser(response.body)
      router.route('/placements')
    }
  }
}

var router = new MyrecoRouter(CONFIG.title, CONFIG.apiUriPrefix)
