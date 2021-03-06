--[[
Copyright 2012 The Luvit Authors. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS-IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
]]--
require('helper')
local fixture = require('./fixture-tls')
local tls = require('tls')

local options = {
  key = fixture.loadPEM('agent1-key'),
  cert = fixture.loadPEM('agent1-cert')
}


local server = tls.createServer(options, function(s)
  assert(s:address().address == s.socket:address().address)
  assert(s:address().port == s.socket:address().port)
  assert(s.remoteAddress == s.socket.remoteAddress)
  assert(s.remotePort == s.socket.remotePort)
  s:done()
end)

server:listen(fixture.commonPort, '127.0.0.1', function()
  assert(server:address().address == '127.0.0.1')
  assert(server:address().port == fixture.commonPort)

  local c
  c = tls.connect({port = fixture.commonPort, host = '127.0.0.1'}, function()
    assert(c:address().address == c.socket:address().address)
    assert(c:address().port == c.socket:address().port)
  end)
  c:on('end', function()
    server:close()
  end)
end)

