#
# Be sure to run `pod lib lint react-native-safe-area-context.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

folly_compiler_flags = '-DFOLLY_NO_CONFIG -DFOLLY_MOBILE=1 -DFOLLY_USE_LIBCPP=1 -Wno-comma -Wno-shorten-64-to-32'
folly_version = '2021.07.22.00'

Pod::Spec.new do |s|
  s.name             = 'react-native-safe-area-context'
  s.version          = '0.3.0'
  s.summary          = 'A short description of react-native-safe-area-context.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/richiezhl/react-native-safe-area-context'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'richiezhl' => 'lylaut@163.com' }
  s.source           = { :git => 'https://github.com/richiezhl/react-native-safe-area-context.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.4'
  
  s.source_files  = "react-native-safe-area-context/ios/**/*.{h,m,mm}"
  s.exclude_files = "react-native-safe-area-context/ios/Fabric"

  s.compiler_flags  = folly_compiler_flags
  
  s.pod_target_xcconfig    = {
      "HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/boost\" \"$(PODS_ROOT)/React/ReactCommon\" \"$(PODS_ROOT)/DoubleConversion\" \"$(PODS_ROOT)/RCT-Folly\" \"$(PODS_ROOT)/Yoga\"",
      "CLANG_CXX_LANGUAGE_STANDARD" => "c++17",
  }
  
  s.dependency "React/React-Core"
  s.dependency "RCT-Folly", folly_version
  s.dependency "React/RCTRequired"
  s.dependency "React/RCTTypeSafety"
  s.dependency "React/ReactCommon/turbomodule/core"
  
  s.subspec "common" do |ss|
    ss.source_files         = "react-native-safe-area-context/cpp/**/*.{cpp,h}"
    ss.header_dir           = "react/renderer/components/safeareacontext"
    ss.pod_target_xcconfig  = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/react-native-safe-area-context/cpp\"" }
  end

  s.subspec "fabric" do |ss|
    ss.dependency "React/React-RCTFabric"
    ss.dependency "react-native-safe-area-context/common"
    ss.source_files         = "react-native-safe-area-context/ios/Fabric/**/*.{h,m,mm}"
    ss.pod_target_xcconfig  = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/react-native-safe-area-context/cpp\"" }
  end
  
  # s.resource_bundles = {
  #   'react-native-safe-area-context' => ['react-native-safe-area-context/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'React'
end
