import MyrecoClient from '../src/myreco_client'
import assert from 'assert'
import request from 'superagent'
import config from './superagent-mock-config'
import superagentMock from 'superagent-mock'

let SuperAgentMock = superagentMock(request, config)

describe('Array', function() {
  describe('#indexOf()', function() {
    it('should return -1 when the value is not present', function() {
      let m = new MyrecoClient('test')
      assert.equal(m.get('test'), 1);
    });
  });
});

SuperAgentMock.unset()