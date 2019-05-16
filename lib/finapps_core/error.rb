# frozen_string_literal: true

# Defines some errors to identify Exceptions within this gem
module FinAppsCore # :nodoc:
  # Base error class.
  class Error < StandardError; end

  # Raised for existing but invalid arguments.
  class InvalidArgumentsError < Error; end

  # Raised whenever a required argument is missing.
  class MissingArgumentsError < Error; end

  # Raised whenever there is a session timeout at the API.
  class ApiSessionTimeoutError < Error; end

  # Raised whenever the session is invalid or does not exist at the API.
  class ApiUnauthenticatedError < Error; end

  # Raised whenever the request specify an unsupported HTTP method.
  class UnsupportedHttpMethodError < Error; end

  # Raised whenever the connection fails.
  class ConnectionFailedError < Error; end

  # Raised whenever the user is locked out from sign in.
  class UserLockoutError < Error; end

  %i[InvalidArgumentsError MissingArgumentsError ApiSessionTimeoutError
     UnsupportedHttpMethodError ConnectionFailedError].each do |const|
    Error.const_set(const, FinAppsCore.const_get(const))
  end
end
