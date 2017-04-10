class ApplicationController < ActionController::API
  before_action :deep_underscorize_params!

  def authentication_failed!
    render json: {
      errors: [
        { status: 401, title: "Unauthorized", code: "invalid_token" }
      ]
    }, status: :unauthorized
  end

  def authorization_header_valid?
    !authorization_header.nil? && !authorization_header.last.nil?
  end

  def authorization_header
    @authorization_header ||= request.headers["Authorization"].try(:split, " ")
  end

  private

  def deep_underscorize_params!(value = params)
    case value
    when Array
      value.map { |v| deep_underscorize_params! v }
    when ActionController::Parameters
      value.keys.each do |k, v = value[k]|
        value.delete k
        value[k.underscore] = deep_underscorize_params! v
      end
      value
    when Hash
      value.keys.each do |k, v = value[k]|
        value.delete k
        value[k.underscore] = deep_underscorize_params! v
      end
      value
    else
      value
    end
  end
end
