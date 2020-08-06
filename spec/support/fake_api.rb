# frozen_string_literal: true

require 'sinatra/base'

# the FakeApi class is used to mock API requests while testing.
class FakeApi < Sinatra::Base
  def self.version_path
    "v#{FinAppsCore::REST::Defaults::API_VERSION}"
  end

  # timeout
  get("/#{version_path}/resources/timeout") { status 419 }

  # resource
  post("/#{version_path}/resources") { json_response 201, 'resource.json' }
  get("/#{version_path}/resources/:id") { json_response 200, 'resource.json' }
  get("/#{version_path}/resources") { json_response 200, 'resources.json' }
  put("/#{version_path}/resources") { json_response 201, 'resource.json' }
  delete("/#{version_path}/resources/:id") { status 202 }

  # version
  get("/#{version_path}/version") { 'Version => 2.1.29-.20161208.172810' }

  # errors
  get("/#{version_path}/client_error") { json_response 400, 'error.json' }
  get("/#{version_path}/server_error") { status 500 }
  get("/#{version_path}/proxy_error") { status 407 }

  # relevance
  get("/#{version_path}/relevance/ruleset/names") { json_response 200, 'relevance_ruleset_names.json' }

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open("#{File.dirname(__FILE__)}/fixtures/#{file_name}", 'rb').read
  end

  def version; end
end
