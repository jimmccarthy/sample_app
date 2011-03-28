class AuthController < ApplicationController

  def index

    @api_key = "DNHQZkfdwF7o3QD8gnwvxxtN3JAXtStBCA4ZYScV9wFyLlooPuVVnlZ90Xidr0Ax"
    @api_secret = "pMQ-q83PjJf3tnldwllWwJdS0UD7aAnI5_Q9A5sJJ-nzZXxXkRjF_ok8554h6oUQ"

    # get your api keys at https://www.linkedin.com/secure/developer
    client = LinkedIn::Client.new(@api_key, @api_secret)
    request_token = client.request_token(:oauth_callback =>
                                      "http://#{request.host_with_port}/auth/callback")
    session[:rtoken] = request_token.token
    session[:rsecret] = request_token.secret

    redirect_to client.request_token.authorize_url

  end

  def callback
    client = LinkedIn::Client.new(@api_key, @api_secret)
    if session[:atoken].nil?
      pin = params[:oauth_verifier]
      atoken, asecret = client.authorize_from_request(session[:rtoken], session[:rsecret], pin)
      session[:atoken] = atoken
      session[:asecret] = asecret
    else
      client.authorize_from_access(session[:atoken], session[:asecret])
    end
    @profile = client.profile
    @connections = client.connections
  end
end