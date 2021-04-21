require 'sinatra'
require 'yaml'
require_relative './models/twofactor.rb'
require 'redis'
require 'json'
require 'plivo'
require 'parseconfig'


set :public_folder, 'public'

config = YAML.load_file('./config/config.yaml')
credentials = config['credentials']

r = Redis.new(host: config['redis_url'])

##
# render config
# 2fa class init to use 2fa class methods in the routes for local server
twofactor = PlivoTwoFactor.new(credentials, config['app_number'], config['phlo_id'])

# Application landing page
get '/' do
  ##
  # render the landing page of the application.
  #
  erb :index
end

# Number verification initiation
get '/verify/:number' do
  number = params['number']
  ##
  # verify(number) accepts a number and initiates verification for it.
  #
  code = if config['phlo_id'].nil?
           twofactor.send_verification_code_sms(number, 'Your verification code is __code__. Code will expire in 1 minute.')
         else
           twofactor.initiate_phlo(number, 'sms')
         end
  r.setex('number:%s:code' % number, 60, code) # Verification code is valid for 1 min
  content_type :json
  { status: 'success', message: 'verification initiated' }.to_json
end

get '/verify_voice/:number' do
  number = params['number']
  ##
  # verify(number) accepts a number and initiates verification for it.
  #
  code = if config['phlo_id'].nil?
           twofactor.send_verification_code_call(number)
         else
           twofactor.initiate_phlo(number, 'call')
         end
  r.setex('number:%s:code' % number, 60, code) # Verification code is valid for 1 min
  content_type :json
  { status: 'success', message: 'verification initiated' }.to_json
end

# Code validation endpoint
get '/checkcode/:number/:code' do
  ##
  # Validates the code entered by the user.
  #
  number = params['number']
  code = params['code']
  original_code = r.get('number:%s:code' % number)
  content_type :json
  if original_code == code
    r.del('number:%s:code' % number)  # verification successful, delete the code
    return { status: 'success', message: 'codes match! number verified' }.to_json
  elsif original_code != code
    return { status: 'failure', message: 'codes do not match! number not verified' }.to_json
  else
    return { status: 'rejected', message: 'number not found!' }.to_json
  end
end
