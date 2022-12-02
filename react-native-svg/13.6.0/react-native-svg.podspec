#
# Be sure to run `pod lib lint react-native-svg.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

folly_compiler_flags = '-DFOLLY_NO_CONFIG -DFOLLY_MOBILE=1 -DFOLLY_USE_LIBCPP=1 -Wno-comma -Wno-shorten-64-to-32'
folly_version = '2021.07.22.00'

Pod::Spec.new do |s|
  s.name             = 'react-native-svg'
  s.version          = '13.6.0'
  s.summary          = 'A short description of react-native-svg.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/richiezhl/react-native-svg'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'richiezhl' => 'lylaut@163.com' }
  s.source           = { :git => 'https://github.com/richiezhl/react-native-svg.git', :tag => "v#{s.version}" }
  s.pod_target_xcconfig = {
    'HEADER_SEARCH_PATHS' => '"$(PODS_ROOT)/boost" "$(PODS_ROOT)/React/ReactCommon" "$(PODS_ROOT)/DoubleConversion" "$(PODS_ROOT)/RCT-Folly" "$(PODS_ROOT)/Yoga" ',
    "CLANG_CXX_LANGUAGE_STANDARD" => "c++17",
  }
  s.platforms       = { ios: '12.4', tvos: '11.0' }
  s.compiler_flags  = folly_compiler_flags + ' -DRN_FABRIC_ENABLED'
  s.source_files    = 'react-native-svg/Classes/apple/**/*.{h,m,mm,cpp}'
  s.ios.exclude_files = 'react-native-svg/Classes/**/*.macos.{h,m,mm,cpp}'
  s.tvos.exclude_files = 'react-native-svg/Classes/**/*.macos.{h,m,mm,cpp}'
  s.osx.exclude_files = 'react-native-svg/Classes/**/*.ios.{h,m,mm,cpp}'
  s.requires_arc    = true

  s.subspec "common" do |ss|
    ss.source_files         = "react-native-svg/Classes/common/**/*.{cpp,mm,h}"
    ss.header_dir           = "rnsvg"
    ss.pod_target_xcconfig  = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/react-native-svg/Classes/common\"" }
  end
  
  s.dependency "React"
  s.dependency "React/React-RCTFabric"
  s.dependency "RCT-Folly", folly_version
  s.dependency "React/RCTRequired"
  s.dependency "React/RCTTypeSafety"
  s.dependency "React/ReactCommon/turbomodule/core"
end
