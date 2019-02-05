Pod::Spec.new do |s|
  s.name             = 'AMZUtils'
  s.version          = '1.0.6'
  s.summary          = 'AMZUtils is a starter kit that can be used in any project.'

  s.description      = <<-DESC
AMZUtils is a starter kit that can be used in any project. It contains a set of methods and functions that are very helpful and shorten the amount of time to implement them.
                       DESC

  s.homepage         = 'https://github.com/AliZahr/AMZUtils'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'AliZahr' => 'ali_zahr@hotmail.com' }
  s.source           = { :git => 'https://github.com/AliZahr/AMZUtils.git', :tag => s.version.to_s }
  s.platform = :ios, '9.0'

  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'AMZUtils/**/*'

  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
