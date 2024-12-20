#
# Be sure to run `pod lib lint HouJia.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HouJia'
  s.version          = '0.0.7'
  s.summary          = 'A short description of HouJia.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/JeromeTW/HouJia'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'JeromeTW' => 'jerome.developer.tw@gmail.com' }
  s.source           = { :git => 'https://github.com/JeromeTW/HouJia.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'
  s.platform     = :ios, '13.0'
  s.swift_version = '5.0'

  s.source_files = 'HouJia/Classes/**/*'
  
  # s.resource_bundles = {
  #   'HouJia' => ['HouJia/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'WebKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'DeviceGuru', '10.0.8'
  s.dependency 'SwiftyUtils', '5.2.0'
  s.dependency 'AFDateHelper', '4.3.0'
  s.dependency 'SSZipArchive', '2.4.3'
  s.dependency 'MBProgressHUD', '1.2.0'
  
end
