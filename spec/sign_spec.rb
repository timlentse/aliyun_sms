require 'aliyun_sms'

describe :AliyunSms do

  AliyunSms.configure do |config|
    config.access_key_id = 'testid'
    config.access_key_secret = 'testsecret'
    config.format = "XML"
    config.region_id = "cn-hangzhou"
  end

  let(:args){ {:timestamp=>"2016-10-20T05:37:52Z",:nonce=>"9e030f6b-03a2-40f0-a6ba-157d44532fd0", :phone=>"13098765432", :params=>{"name":"d","name1":"d"},:sign_name=>"标签测试",:tpl_id=>"SMS_1650053" } }

  subject { AliyunSms.build_params(args)  }

  it "should signed succeed" do
    signature = AliyunSms.signature(subject)
    expect(signature).to eql("ka8PDlV7S9sYqxEMRnmlBv%2FDoAE%3D")
  end

end
