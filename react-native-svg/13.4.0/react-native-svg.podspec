require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

folly_compiler_flags = '-DFOLLY_NO_CONFIG -DFOLLY_MOBILE=1 -DFOLLY_USE_LIBCPP=1 -Wno-comma -Wno-shorten-64-to-32'
folly_version = '2021.07.22.00'

Pod::Spec.new do |s|
  s.name              = 'react-native-svg'
  s.version           = package['version']
  s.summary           = package['description']
  s.license           = package['license']
  s.homepage          = package['homepage']
  s.authors           = 'Horcrux Chen'
  s.source            = { :git => 'https://github.com/RichieZhl/react-native-svg.git', :tag => "v#{s.version}" }

  s.pod_target_xcconfig = {
    'HEADER_SEARCH_PATHS' => '"$(PODS_ROOT)/boost" "$(PODS_ROOT)/React/ReactCommon" "$(PODS_ROOT)/DoubleConversion" "$(PODS_ROOT)/RCT-Folly" "$(PODS_ROOT)/Yoga" ',
    "CLANG_CXX_LANGUAGE_STANDARD" => "c++17",
  }
  s.platforms       = { ios: '12.4', tvos: '11.0' }
  s.compiler_flags  = folly_compiler_flags + ' -DRN_FABRIC_ENABLED'
  s.source_files    = 'apple/**/*.{h,m,mm,cpp}'
  s.ios.exclude_files = '**/*.macos.{h,m,mm,cpp}'
  s.tvos.exclude_files = '**/*.macos.{h,m,mm,cpp}'
  s.osx.exclude_files = '**/*.ios.{h,m,mm,cpp}'
  s.requires_arc    = true

  s.subspec "common" do |ss|
    ss.source_files         = "common/**/*.{cpp,h}"
    ss.header_dir           = "rnsvg"
    ss.pod_target_xcconfig  = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/common\"" }
  end

  s.dependency "React"
  s.dependency "React/React-RCTFabric"
  s.dependency "RCT-Folly", folly_version
  s.dependency "React/RCTRequired"
  s.dependency "React/RCTTypeSafety"
  s.dependency "React/ReactCommon/turbomodule/core"
end
