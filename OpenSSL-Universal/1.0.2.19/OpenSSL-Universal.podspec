#
# Be sure to run `pod lib lint OpenSSL-Universal.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'OpenSSL-Universal'
  s.version          = '1.0.2.19'
  s.summary          = 'A short description of OpenSSL-Universal.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/richiezhl/OpenSSL-Universal'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'richiezhl' => 'lylaut@163.com' }
  s.source           = { :git => 'https://github.com/richiezhl/OpenSSL-Universal.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  
  s.vendored_libraries = 'OpenSSL-Universal/lib/*.a'
  
  s.source_files = 'OpenSSL-Universal/include/**/*.h'
  
  # s.resource_bundles = {
  #   'OpenSSL-Universal' => ['OpenSSL-Universal/Assets/*.png']
  # }

  s.public_header_files = 'OpenSSL-Universal/include/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
