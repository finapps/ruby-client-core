# frozen_string_literal: true

require 'sinatra/base'

# the FakeApi class is used to mock API requests while testing.
class FakeApi < Sinatra::Base
  # timeout
  get('/v3/resources/timeout') { status 419 }

  # resource
  post('/v3/resources') { json_response 201, 'resource.json' }
  get('/v3/resources/:id') { json_response 200, 'resource.json' }
  get('/v3/resources') { json_response 200, 'resources.json' }
  put('/v3/resources') { json_response 201, 'resource.json' }
  delete('/v3/resources/:id') { status 202 }

  # version
  get('/v3/version') { 'Version => 2.1.29-.20161208.172810' }

  # errors
  get('/v3/client_error') { json_response 400, 'error.json' }
  get('/v3/server_error') { status 500 }
  get('/v3/proxy_error') { status 407 }

  # relevance
  get('/v3/relevance/ruleset/names') { json_response 200, 'relevance_ruleset_names.json' }

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end
