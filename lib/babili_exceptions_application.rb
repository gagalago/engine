class BabiliExceptionsApplication
  def self.call
    lambda do |env|
      exception     = env["action_dispatch.exception"]
      status_code   = ActionDispatch::ExceptionWrapper.new(env, exception).status_code
      error_message = Rack::Utils::HTTP_STATUS_CODES.fetch(status_code, Rack::Utils::HTTP_STATUS_CODES[500])
      body          = { errors: [{ status: status_code, title: error_message}] }.to_json
      headers       = {
        "Content-Type"   => "application/json; charset=UTF-8",
        "Content-Length" => body.bytesize.to_s
      }

      [status_code, headers, [body]]
    end
  end
end
