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


class MyrecoClient {
  constructor(api_uri, user, password, failureDecorator) {
    this.api_uri = api_uri
    this.user = user
    this.password = password
    this.failureDecorator = failureDecorator
  }

  setUser(user, password) {
    this.user = user
    this.password = password
  }

  get(sufix, success, failure, query, data) {
    let url = this._processUrl(sufix)
    return this._processRequest(superagent.get(url), query, data, success, failure)
  }

  _processUrl(sufix) {
    return `${this.api_uri}${sufix}`
  }

  _processRequest(req, query, data, success, failure) {
    if (this.user != undefined && this.password != undefined)
      req = req.auth(this.user, this.password)
    return req.query(query).send(data).then(success, this.failureDecorator(failure))
  }

  post(sufix, success, failure, query, data) {
    let url = this._processUrl(sufix)
    return this._processRequest(superagent.post(url), query, data, success, failure)
  }

  patch(sufix, success, failure, query, data) {
    let url = this._processUrl(sufix)
    return this._processRequest(superagent.patch(url), query, data, success, failure)
  }

  delete(sufix, success, failure, query, data) {
    let url = this._processUrl(sufix)
    return this._processRequest(superagent.delete(url), query, data, success, failure)
  }
}
