#
# Be sure to run `pod lib lint UpgradePod.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'UpgradePod'
  s.version          = '1.0.5'
  s.summary          = '检测App版本升级的库'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
检测App版本升级的库，同时检测苹果应用商店的版本号，以苹果运营商店的版本为准。
                       DESC

  s.homepage         = 'https://github.com/yzeaho/UpgradePod'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yzeaho' => 'y-zeaho@qq.com' }
  s.source           = { :git => 'https://github.com/yzeaho/UpgradePod.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  s.source_files = 'UpgradePod/Classes/**/*'
  s.resource_bundles = {
    'UpgradePod' => ['UpgradePod/Assets/**/*']
  }
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'AFNetworking', '~> 4.0'
  s.dependency 'MJExtension'
  
end
