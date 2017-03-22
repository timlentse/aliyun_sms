# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aliyun_sms/version'

Gem::Specification.new do |spec|
  spec.name          = "aliyun_sms"
  spec.version       = AliyunSms::VERSION
  spec.authors       = ["timlentse"]
  spec.email         = ["tinglenxan@gmail.com"]

  spec.summary       = %q{Ruby SDK of Aliyun SMS service}
  spec.description   = %q{This is a ruby gem help to use aliyun sms in ruby way.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rest-client", "~> 2.0.1"
  spec.add_development_dependency "rspec"
end
