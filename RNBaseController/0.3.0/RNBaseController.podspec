#
# Be sure to run `pod lib lint RNBaseController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RNBaseController'
  s.version          = '0.3.0'
  s.summary          = 'React Native 基础控制器'

  s.description      = <<-DESC
React Native 基础控制器，并支持metro 分包
                       DESC

  s.homepage         = 'https://github.com/richiezhl/RNBaseController'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'richiezhl' => 'lylaut@163.com' }
  s.source           = { :git => 'https://github.com/richiezhl/RNBaseController.git', :tag => s.version.to_s }

  s.xcconfig = { 'OTHER_LDFLAGS' => '-ObjC', 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
      'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386 arm64' }
  
  s.ios.deployment_target = '12.4'
  
  s.pod_target_xcconfig = { "HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/boost\" \"$(PODS_ROOT)/RCT-Folly\" \"$(PODS_ROOT)/DoubleConversion\" \"$(PODS_ROOT)/React\"  \"$(PODS_ROOT)/React/ReactCommon\" \"$(PODS_ROOT)/React/React\"",
      "CLANG_CXX_LANGUAGE_STANDARD" => "c++17", "OTHER_CPLUSPLUSFLAGS" => "$(inherited) -DRCT_NEW_ARCH_ENABLED=1" }
  s.user_target_xcconfig = { "HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/React\"" }
    
  s.source_files = 'RNBaseController/Classes/*.{h,m,mm}'

  s.public_header_files = 'RNBaseController/Classes/*.h'

  s.dependency 'React'
end
