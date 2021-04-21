require 'parseconfig'
require 'plivo'

##
# Plivotwofactorauth Class to Send Verification code via SMS.
class PlivoTwoFactor
  include Plivo
  include Plivo::Exceptions
  # Initialize auth credentials and SRC number for Send SMS method.
  def initialize(credentials, app_number, phlo_id)
    @client = RestClient.new(credentials['auth_id'], credentials['auth_token'])
    @phloclient = Phlo.new(credentials['auth_id'], credentials['auth_token'])
    @app_number = app_number
    @phlo_id = phlo_id
  end

  ##
  # Send SMS method.
  # The message text should contain a `__code__` construct in the message text.
  # Message text will be replaced by the code generated before sending the SMS
  # @param [String] dst_number
  # @param [String] message
  # @return [int] code
  def send_verification_code_sms(dst_number, message)
    code = rand(999_999)
    @client.messages.create(
      @app_number,
      [dst_number],
      message.gsub('__code__', code.to_s)
    )
    code
  rescue PlivoRESTError => e
    puts 'Exception: ' + e.message
  end

  # Make a Call method.
  def send_verification_code_call(dst_number)
    code = rand(999_999)
    @client.calls.create(
      @app_number,
      [dst_number],
      "https://twofa-answerurl.herokuapp.com/answer_url/#{code}"
    )
    code
  rescue PlivoRESTError => e
    puts 'Exception: ' + e.message
  end

  # Trigger PHLO
  def initiate_phlo(dst_number, mode)
    code = rand(999_999)
    begin
      phlo = @phloclient.phlo.get(@phlo_id)
      # parameters set in PHLO - params
      params = {
        from: @app_number,
        to: dst_number,
        otp: code,
        mode: mode
      }
      phlo.run(params)
      code
    rescue PlivoRESTError => e
      puts 'Exception: ' + e.message
    end
  end
end
