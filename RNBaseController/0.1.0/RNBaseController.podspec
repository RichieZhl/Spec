#
# Be sure to run `pod lib lint RNBaseController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RNBaseController'
  s.version          = '0.1.0'
  s.summary          = 'React Native 基础控制器'

  s.description      = <<-DESC
React Native 基础控制器
在 Pofile里加入以下代码
source 'https://github.com/RichieZhl/Spec.git'
source 'https://github.com/CocoaPods/Specs.git'
                       DESC

  s.homepage         = 'https://github.com/richiezhl/RNBaseController'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'richiezhl' => 'lylaut@163.com' }
  s.source           = { :git => 'https://github.com/richiezhl/RNBaseController.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  
  s.pod_target_xcconfig = { "HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/React\"" }
  s.user_target_xcconfig = { "HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/React\"" }
    
  s.source_files = 'RNBaseController/Classes/*.{h,m,mm}'

  s.public_header_files = 'RNBaseController/Classes/*.h'

  s.dependency 'React'
end
