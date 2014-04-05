class Api::V1::ApiController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  layout false
  respond_to :json, :xml
  after_action :global_request_logging

  rescue_from Mongoid::Errors::DocumentNotFound do |ex|
    head :not_found
  end

  def global_request_logging
    Visit.new(session_id: request.session_options[:id],
              method: request.method,
              url: request.url,
              ip: request.remote_ip,
              params: params,
              http_headers: request.env.select { |key| request.env[key] if key.match('^HTTP.*') }
             ).save
  end

  def respond_custom(resource, options = {})
    respond_with :api, resource do |format|
      format.json { render json: resource.to_json(root: :error), status: options[:status] }
      format.xml { render xml: resource.to_xml(root: :error), status: options[:status] }
    end
  end

end
