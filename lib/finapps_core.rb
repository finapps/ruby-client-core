# frozen_string_literal: true
require 'finapps_core/version' unless defined?(FinAppsCore::VERSION)

require 'faraday'
require 'faraday_middleware'
require 'typhoeus'
require 'typhoeus/adapters/faraday'

require 'core_extensions/object/blank'
require 'core_extensions/object/is_integer'
require 'core_extensions/string/json_to_hash'

require 'finapps_core/utils/loggeable'
require 'finapps_core/utils/parameter_filter'
require 'finapps_core/error'

require 'finapps_core/middleware/request/tenant_authentication'
require 'finapps_core/middleware/request/no_encoding_basic_authentication'
require 'finapps_core/middleware/request/accept_json'
require 'finapps_core/middleware/request/user_agent'
require 'finapps_core/middleware/response/raise_error'
require 'finapps_core/middleware/middleware'

require 'finapps_core/rest/defaults'
require 'finapps_core/rest/resources'

require 'finapps_core/rest/version'

require 'finapps_core/rest/configuration'
require 'finapps_core/rest/credentials'
require 'finapps_core/rest/connection'
require 'finapps_core/rest/base_client'
require 'finapps_core/rest/client'
