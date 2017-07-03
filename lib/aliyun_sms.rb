require 'aliyun_sms/version'
require 'json'
require 'openssl'
require 'base64'
require 'rest-client'

module AliyunSms
  class Configuration
    attr_accessor :access_key_id, :access_key_secret, :format, :signature_method, :signature_version, :version, :region_id

    def initialize
      @access_key_id = ''
      @access_key_secret = ''
      @region_id = ''
      @format = 'JSON'
      @signature_method = 'HMAC-SHA1'
      @signature_version = '1.0'
      @version = '2016-09-27'
    end
  end

  API_URL = 'https://sms.aliyuncs.com/'

  class << self
    def configure
      yield(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def to(opts = {})
      params = build_params(opts)
      params = params.delete_if { |_k, v| v.nil? || v.to_s.empty? }
      begin
        res = RestClient.post(API_URL, generate_query_body_str(params), headers: { 'Content-Type': 'application/x-www-form-urlencoded' })
        result = JSON.parse(res)
        if res.code == 200 && result['Model'] && result['RequestId']
          { code: 0, msg: '发送成功' }
        else
          { code: res.code, msg: '发送失败' }
        end
      rescue => e
        { code: -1, msg: e.message }
      end
    end

    def signature(params = {})
      canonicalized_query_string = URI.encode_www_form_component URI.encode_www_form(params)
      hmac_result = OpenSSL::HMAC.digest('sha1', "#{configuration.access_key_secret}&", "POST&%2F&#{canonicalized_query_string}")
      URI.encode_www_form_component Base64.encode64(hmac_result).chomp
    end

    def build_params(args = {})
      {
        "Format": configuration.format,
        "SignatureMethod": configuration.signature_method,
        "SignatureVersion": configuration.signature_version,
        "Version": configuration.version,
        "AccessKeyId": configuration.access_key_id,
        "Action": 'SingleSendSms',
        "ParamString": args[:params].to_json,
        "SignName": args[:sign_name],
        "RegionId": configuration.region_id,
        "SignatureNonce": args[:nonce] || SecureRandom.uuid,
        "TemplateCode": args[:tpl_id],
        "Timestamp": args[:timestamp] || timestamp,
        "RecNum": args[:phone]
      }.sort.to_h
    end

    private

    def timestamp
      Time.now.utc.strftime('%FT%TZ')
    end

    def generate_query_body_str(params = {})
      str = params.map { |k, v| "#{k}=#{v}" }.join('&')
      "Signature=#{signature(params)}&#{str}"
    end
  end
end
