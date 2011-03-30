class AuthController < ApplicationController

  $api_key = "DNHQZkfdwF7o3QD8gnwvxxtN3JAXtStBCA4ZYScV9wFyLlooPuVVnlZ90Xidr0Ax"
  $api_secret = "pMQ-q83PjJf3tnldwllWwJdS0UD7aAnI5_Q9A5sJJ-nzZXxXkRjF_ok8554h6oUQ"

  def index
    # get your api keys at https://www.linkedin.com/secure/developer
    linked_in_client = LinkedIn::Client.new($api_key, $api_secret)
    request_token = linked_in_client.request_token(:oauth_callback =>
                                      "http://#{request.host_with_port}/auth/callback")
    session[:rtoken] = request_token.token
    session[:rsecret] = request_token.secret

    redirect_to linked_in_client.request_token.authorize_url
  end

  def callback
    linked_in_client = LinkedIn::Client.new($api_key, $api_secret)
    if session[:atoken].nil?
      pin = params[:oauth_verifier]
      atoken, asecret = linked_in_client.authorize_from_request(session[:rtoken], session[:rsecret], pin)
      session[:atoken] = atoken
      session[:asecret] = asecret
    else
      linked_in_client.authorize_from_access(session[:atoken], session[:asecret])
    end
    @connections = linked_in_client.connections
  end
end