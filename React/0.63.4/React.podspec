# Copyright (c) Facebook, Inc. and its affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))
version = package['version']

source = { :git => 'https://github.com/RichieZhl/react-native.git' }
if version == '1000.0.0'
  # This is an unpublished version, use the latest commit hash of the react-native repo, which we’re presumably in.
  source[:commit] = `git rev-parse HEAD`.strip
else
  source[:tag] = "v#{version}"
end

folly_compiler_flags = '-DFOLLY_NO_CONFIG -DFOLLY_MOBILE=1 -DFOLLY_USE_LIBCPP=1 -Wno-comma -Wno-shorten-64-to-32'
folly_version = '2020.01.13.00'
boost_compiler_flags = '-Wno-documentation'

header_subspecs = {
  'ARTHeaders'                  => 'Libraries/ART/**/*.h',
  'CoreModulesHeaders'          => 'React/CoreModules/**/*.h',
  'RCTActionSheetHeaders'       => 'Libraries/ActionSheetIOS/*.h',
  'RCTAnimationHeaders'         => 'Libraries/NativeAnimation/{Drivers/*,Nodes/*,*}.{h}',
  'RCTBlobHeaders'              => 'Libraries/Blob/*.h',
  'RCTImageHeaders'             => 'Libraries/Image/*.h',
  'RCTLinkingHeaders'           => 'Libraries/LinkingIOS/*.h',
  'RCTNetworkHeaders'           => 'Libraries/Network/*.h',
  'RCTPushNotificationHeaders'  => 'Libraries/PushNotificationIOS/*.h',
  'RCTSettingsHeaders'          => 'Libraries/Settings/*.h',
  'RCTTextHeaders'              => 'Libraries/Text/**/*.h',
  'RCTVibrationHeaders'         => 'Libraries/Vibration/*.h',
}

Pod::Spec.new do |s|
  s.name                   = "React"
  s.version                = version
  s.summary                = package["description"]
  s.description            = <<-DESC
                               React Native apps are built using the React JS
                               framework, and render directly to native UIKit
                               elements using a fully asynchronous architecture.
                               There is no browser and no HTML. We have picked what
                               we think is the best set of features from these and
                               other technologies to build what we hope to become
                               the best product development framework available,
                               with an emphasis on iteration speed, developer
                               delight, continuity of technology, and absolutely
                               beautiful and fast products with no compromises in
                               quality or capability.
                             DESC
  s.homepage               = "http://facebook.github.io/react-native/"
  s.license                = package["license"]
  s.author                 = "Facebook, Inc. and its affiliates"
  s.platforms              = { :ios => "10.0", :tvos => "10.0" }
  s.source                 = source
  s.preserve_paths         = "package.json", "LICENSE", "LICENSE-docs"
  s.cocoapods_version      = ">= 1.2.0"

  s.subspec "FBLazyVector" do |ss|
    ss.platforms              = { :ios => "10.0", :tvos => "10.0" }
    ss.source_files           = "Libraries/FBLazyVector/**/*.{c,h,m,mm,cpp}"
    ss.header_dir             = "FBLazyVector"
    ss.pod_target_xcconfig    = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/Libraries/FBLazyVector\"", "CLANG_CXX_LANGUAGE_STANDARD" => "c++14" }
  end

  s.subspec "React-jsi" do |ss|
    ss.platforms              = { :ios => "10.0", :tvos => "10.0" }
    ss.source_files           = "ReactCommon/jsi/**/*.{cpp,h}"
    ss.exclude_files          = "ReactCommon/jsi/**/test/*"
    ss.framework              = "JavaScriptCore"
    ss.compiler_flags         = folly_compiler_flags + ' ' + boost_compiler_flags
    ss.pod_target_xcconfig    = { "HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/boost-for-react-native\" \"$(PODS_ROOT)/Folly\" \"$(PODS_ROOT)/DoubleConversion\" \"$(PODS_TARGET_SRCROOT)/ReactCommon/jsi\"" }
    ss.header_dir             = "jsi"
  
    ss.dependency "boost-for-react-native", "1.63.0"
    ss.dependency "DoubleConversion"
    ss.dependency "Folly", folly_version
    ss.dependency "glog"
  
    ss.subspec "Default" do
      # no-op
    end
  
    ss.subspec "Fabric" do |sss|
      sss.pod_target_xcconfig  = { "OTHER_CFLAGS" => "$(inherited) -DRN_FABRIC_ENABLED" }
    end
  end

  s.subspec "FBReactNativeSpec" do |ss|
    ss.platforms              = { :ios => "10.0", :tvos => "10.0" }
    ss.compiler_flags         = folly_compiler_flags + ' -Wno-nullability-completeness'
    ss.source_files           = "Libraries/FBReactNativeSpec/**/*.{c,h,m,mm,cpp}"
    ss.header_dir             = "FBReactNativeSpec"

    ss.pod_target_xcconfig    = {
                                "USE_HEADERMAP" => "YES",
                                "CLANG_CXX_LANGUAGE_STANDARD" => "c++14",
                                "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/Libraries/FBReactNativeSpec\" \"$(PODS_ROOT)/Folly\""
                              }

    ss.dependency "Folly", folly_version
    ss.dependency "React/RCTRequired"
    ss.dependency "React/RCTTypeSafety"
    ss.dependency "React/React-Core"
    ss.dependency "React/React-jsi"
    ss.dependency "React/ReactCommon/turbomodule/core"
  end

  s.subspec "RCTRequired" do |ss|
    ss.platforms              = { :ios => "10.0", :tvos => "10.0" }
    ss.source_files           = "Libraries/RCTRequired/**/*.{c,h,m,mm,cpp}"
    ss.header_dir             = "RCTRequired"
    ss.pod_target_xcconfig    = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/Libraries/RCTRequired\"" }
  end

  s.subspec "React-jsinspector" do |ss|
    ss.platforms              = { :ios => "10.0", :tvos => "10.0" }
    ss.source_files           = "ReactCommon/jsinspector/*.{cpp,h}"
    ss.header_dir             = 'jsinspector'
    ss.pod_target_xcconfig    = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/ReactCommon/jsinspector\"" }
  end

  s.subspec "React-cxxreact" do |ss|
    ss.platforms              = { :ios => "10.0", :tvos => "10.0" }
    ss.source_files           = "ReactCommon/cxxreact/*.{cpp,h}"
    ss.exclude_files          = "ReactCommon/cxxreact/SampleCxxModule.*"
    ss.compiler_flags         = folly_compiler_flags + ' ' + boost_compiler_flags
    ss.pod_target_xcconfig    = { "HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/boost-for-react-native\" \"$(PODS_ROOT)/Folly\" \"$(PODS_ROOT)/DoubleConversion\" \"$(PODS_TARGET_SRCROOT)/ReactCommon/cxxreact\"" }
    ss.header_dir             = "cxxreact"

    ss.dependency "boost-for-react-native", "1.63.0"
    ss.dependency "DoubleConversion"
    ss.dependency "Folly", folly_version
    ss.dependency "glog"
    ss.dependency "React/React-jsinspector"
  end

  s.subspec "React-jsiexecutor" do |ss|
    ss.platforms              = { :ios => "10.0", :tvos => "10.0" }
    ss.source_files         = "ReactCommon/jsiexecutor/jsireact/*.{cpp,h}"
    ss.compiler_flags         = folly_compiler_flags + ' ' + boost_compiler_flags
    ss.pod_target_xcconfig    = { "HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/boost-for-react-native\" \"$(PODS_ROOT)/Folly\" \"$(PODS_ROOT)/DoubleConversion\" \"$(PODS_TARGET_SRCROOT)/ReactCommon/jsiexecutor\"" }
    ss.header_dir             = "jsireact"

    ss.dependency "React/React-cxxreact"
    ss.dependency "React/React-jsi"
    ss.dependency "Folly", folly_version
    ss.dependency "DoubleConversion"
    ss.dependency "glog"
  end

  s.subspec "React-Core" do |ss|
    ss.pod_target_xcconfig    = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/ReactCommon\" \"$(PODS_ROOT)/boost-for-react-native\" \"$(PODS_ROOT)/DoubleConversion\" \"$(PODS_ROOT)/Folly\"", "DEFINES_MODULE" => "YES" }
    ss.user_target_xcconfig   = { "HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/Headers/Private/React-Core\""}
    ss.subspec "Default" do |sss|
      sss.source_files           = "React/**/*.{c,h,m,mm,S,cpp}"
      sss.exclude_files          = "React/CoreModules/**/*",
                                  "React/DevSupport/**/*",
                                  "React/Fabric/**/*",
                                  "React/Inspector/**/*"
      sss.ios.exclude_files      = "React/**/RCTTV*.*"
      sss.tvos.exclude_files     = "React/Modules/RCTClipboard*",
                                  "React/Views/RCTDatePicker*",
                                  "React/Views/RCTPicker*",
                                  "React/Views/RCTRefreshControl*",
                                  "React/Views/RCTSlider*",
                                  "React/Views/RCTSwitch*",
      sss.private_header_files   = "React/Cxx*/*.h"
    end
  
    ss.subspec "DevSupport" do |sss|
      sss.source_files = "React/DevSupport/*.{h,mm,m}",
                        "React/Inspector/*.{h,mm,m}"
  
      sss.dependency "React/React-Core/Default"
      sss.dependency "React/React-Core/RCTWebSocket"
      sss.dependency "React/React-jsinspector"
    end
  
    ss.subspec "RCTWebSocket" do |sss|
      sss.source_files = "Libraries/WebSocket/*.{h,m}"
      sss.dependency "React/React-Core/Default"
    end
  
    # Add a subspec containing just the headers for each
    # pod that should live under <React/*.h>
    header_subspecs.each do |name, headers|
      ss.subspec name do |sss|
        sss.source_files = headers
        sss.dependency "React/React-Core/Default"
      end
    end
  
    ss.dependency "Folly", folly_version
    ss.dependency "React/React-cxxreact"
    ss.dependency "React/React-jsi"
    ss.dependency "React/React-jsiexecutor"
    ss.dependency "Yoga", '1.14.1'
    ss.dependency "glog"
  end

  s.subspec "RCTTypeSafety" do |ss|
    ss.platforms              = { :ios => "10.0", :tvos => "10.0" }
    ss.compiler_flags         = folly_compiler_flags
    ss.source_files           = "Libraries/TypeSafety/**/*.{c,h,m,mm,cpp}"
    ss.header_dir             = "RCTTypeSafety"
    ss.pod_target_xcconfig    = {
                                "USE_HEADERMAP" => "YES",
                                "CLANG_CXX_LANGUAGE_STANDARD" => "c++14",
                                "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/Libraries/TypeSafety\" \"$(PODS_ROOT)/Folly\""
                              }

    ss.dependency "React/FBLazyVector"
    ss.dependency "Folly", folly_version
    ss.dependency "React/RCTRequired"
    ss.dependency "React/React-Core"
  end

  s.subspec "ReactCommon" do |ss|
    ss.platforms              = { :ios => "10.0", :tvos => "10.0" }
    ss.header_dir             = "ReactCommon" # Use global header_dir for all subspecs for use_frameworks! compatibility
    ss.compiler_flags         = folly_compiler_flags + ' ' + boost_compiler_flags
    ss.pod_target_xcconfig = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/ReactCommon\" \"$(PODS_ROOT)/boost-for-react-native\" \"$(PODS_ROOT)/Folly\" \"$(PODS_ROOT)/DoubleConversion\" \"$(PODS_ROOT)/Headers/Private/React-Core\"",
                                "USE_HEADERMAP" => "YES",
                                "CLANG_CXX_LANGUAGE_STANDARD" => "c++14" }

    ss.subspec "callinvoker" do |sss|
      sss.source_files = "ReactCommon/callinvoker/**/*.{cpp,h}"

      sss.dependency "React/React-cxxreact"
      sss.dependency "DoubleConversion"
      sss.dependency "Folly", folly_version
      sss.dependency "glog"
    end

    ss.subspec "turbomodule" do |sss|
      sss.dependency "React/ReactCommon/callinvoker"
      sss.dependency "React/React-Core"
      sss.dependency "React/React-cxxreact"
      sss.dependency "React/React-jsi"
      sss.dependency "Folly", folly_version
      sss.dependency "DoubleConversion"
      sss.dependency "glog"

      sss.subspec "core" do |ssss|
        ssss.source_files = "ReactCommon/turbomodule/core/*.{cpp,h}",
                          "ReactCommon/turbomodule/core/platform/ios/*.{mm,cpp,h}"
      end
    end
  end

  s.subspec "React-CoreModules" do |ss|
    ss.platforms              = { :ios => "10.0", :tvos => "10.0" }
    ss.compiler_flags         = folly_compiler_flags + ' -Wno-nullability-completeness'
    ss.source_files           = "React/CoreModules/**/*.{c,m,mm,cpp}"
    ss.header_dir             = "CoreModules"
    ss.pod_target_xcconfig    = {
                                "USE_HEADERMAP" => "YES",
                                "CLANG_CXX_LANGUAGE_STANDARD" => "c++14",
                                "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/React/CoreModules\" \"$(PODS_ROOT)/Folly\""
                              }

    ss.dependency "React/FBReactNativeSpec", version
    ss.dependency "Folly", folly_version
    ss.dependency "React/RCTTypeSafety", version
    ss.dependency "React/React-Core/CoreModulesHeaders", version
    ss.dependency "React/React-RCTImage", version
    ss.dependency "React/ReactCommon/turbomodule/core", version
    ss.dependency "React/React-jsi"
  end

  s.subspec "React-RCTActionSheet" do |ss|
    ss.platforms              = { :ios => "10.0", :tvos => "10.0" }
    ss.source_files           = "Libraries/ActionSheetIOS/*.{m}"
    ss.preserve_paths          = "package.json", "LICENSE", "LICENSE-docs"
    ss.header_dir             = "RCTActionSheet"
    ss.dependency "React/React-Core/RCTActionSheetHeaders"
  end

  s.subspec "React-RCTAnimation" do |ss|
    ss.platforms              = { :ios => "10.0", :tvos => "10.0" }
    ss.compiler_flags         = folly_compiler_flags + ' -Wno-nullability-completeness'
    ss.source_files           = "Libraries/NativeAnimation/{Drivers/*,Nodes/*,*}.{m,mm}"
    ss.preserve_paths         = "package.json", "LICENSE", "LICENSE-docs"
    ss.header_dir             = "RCTAnimation"
    ss.pod_target_xcconfig    = {
                                 "USE_HEADERMAP" => "YES",
                                 "CLANG_CXX_LANGUAGE_STANDARD" => "c++14",
                                 "HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/Folly\""
                               }
  
    ss.dependency "Folly", folly_version
    ss.dependency "React/RCTTypeSafety"
    ss.dependency "React/ReactCommon/turbomodule/core"
    ss.dependency "React/FBReactNativeSpec"
    ss.dependency "React/React-Core/RCTAnimationHeaders"
  end

  s.subspec "React-RCTBlob" do |ss|
    ss.platforms              = { :ios => "10.0", :tvos => "10.0" }
    ss.compiler_flags         = folly_compiler_flags + ' -Wno-nullability-completeness'
    ss.source_files           = "Libraries/Blob/*.{m,mm}"
    ss.preserve_paths         = "package.json", "LICENSE", "LICENSE-docs"
    ss.header_dir             = "RCTBlob"
    ss.pod_target_xcconfig    = {
                                "USE_HEADERMAP" => "YES",
                                "CLANG_CXX_LANGUAGE_STANDARD" => "c++14",
                                "HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/Folly\""
                              }

    ss.dependency "Folly", folly_version
    ss.dependency "React/FBReactNativeSpec"
    ss.dependency "React/ReactCommon/turbomodule/core"
    ss.dependency "React/React-Core/RCTBlobHeaders"
    ss.dependency "React/React-Core/RCTWebSocket"
    ss.dependency "React/React-RCTNetwork"
    ss.dependency "React/React-jsi"
  end

  s.subspec "React-RCTImage" do |ss|
    ss.platforms              = { :ios => "10.0", :tvos => "10.0" }
    ss.compiler_flags         = folly_compiler_flags + ' -Wno-nullability-completeness'
    ss.source_files           = "Libraries/Image/*.{m,mm}"
    ss.preserve_paths         = "package.json", "LICENSE", "LICENSE-docs"
    ss.header_dir             = "RCTImage"
    ss.pod_target_xcconfig    = {
                                "USE_HEADERMAP" => "YES",
                                "CLANG_CXX_LANGUAGE_STANDARD" => "c++14",
                                "HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/Folly\""
                              }

    ss.dependency "Folly", folly_version
    ss.dependency "React/FBReactNativeSpec"
    ss.dependency "React/RCTTypeSafety"
    ss.dependency "React/ReactCommon/turbomodule/core"
    ss.dependency "React/React-Core/RCTImageHeaders"
    ss.dependency "React/React-RCTNetwork"
  end

  s.subspec "React-RCTLinking" do |ss|
    ss.source_files           = "Libraries/LinkingIOS/*.{m,mm}"
    ss.preserve_paths         = "package.json", "LICENSE", "LICENSE-docs"
    ss.header_dir             = "RCTLinking"
    ss.pod_target_xcconfig    = {
                                "USE_HEADERMAP" => "YES",
                                "CLANG_CXX_LANGUAGE_STANDARD" => "c++14",
                                "HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/Folly\""
                              }

    ss.dependency "React/FBReactNativeSpec"
    ss.dependency "React/React-Core/RCTLinkingHeaders"
    ss.dependency "React/ReactCommon/turbomodule/core"
  end

  s.subspec "React-RCTNetwork" do |ss|
    ss.platforms              = { :ios => "10.0", :tvos => "10.0" }
    ss.compiler_flags         = folly_compiler_flags + ' -Wno-nullability-completeness'
    ss.source_files           = "Libraries/Network/*.{m,mm}"
    ss.preserve_paths         = "package.json", "LICENSE", "LICENSE-docs"
    ss.header_dir             = "RCTNetwork"
    ss.pod_target_xcconfig    = {
                                "USE_HEADERMAP" => "YES",
                                "CLANG_CXX_LANGUAGE_STANDARD" => "c++14",
                                "HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/Folly\""
                              }
    ss.frameworks             = "MobileCoreServices"

    ss.dependency "Folly", folly_version
    ss.dependency "React/FBReactNativeSpec"
    ss.dependency "React/RCTTypeSafety"
    ss.dependency "React/ReactCommon/turbomodule/core"
    ss.dependency "React/React-Core/RCTNetworkHeaders"
  end

  s.subspec "React-RCTSettings" do |ss|
    ss.platforms              = { :ios => "10.0", :tvos => "10.0" }
    ss.compiler_flags         = folly_compiler_flags + ' -Wno-nullability-completeness'
    ss.source_files           = "Libraries/Settings/*.{m,mm}"
    ss.preserve_paths         = "package.json", "LICENSE", "LICENSE-docs"
    ss.header_dir             = "RCTSettings"
    ss.pod_target_xcconfig    = {
                                "USE_HEADERMAP" => "YES",
                                "CLANG_CXX_LANGUAGE_STANDARD" => "c++14",
                                "HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/Folly\""
                              }

    ss.dependency "Folly", folly_version
    ss.dependency "React/FBReactNativeSpec"
    ss.dependency "React/RCTTypeSafety"
    ss.dependency "React/ReactCommon/turbomodule/core"
    ss.dependency "React/React-Core/RCTSettingsHeaders"
  end

  s.subspec "React-RCTText" do |ss|
    ss.platforms              = { :ios => "10.0", :tvos => "10.0" }
    ss.source_files           = "Libraries/Text/**/*.{h,m}"
    ss.preserve_paths         = "package.json", "LICENSE", "LICENSE-docs"
    ss.header_dir             = "RCTText"

    ss.dependency "React/React-Core/RCTTextHeaders"
  end

  s.subspec "React-RCTVibration" do |ss|
    ss.platforms              = { :ios => "10.0", :tvos => "10.0" }
    ss.compiler_flags         = folly_compiler_flags + ' -Wno-nullability-completeness'
    ss.source_files           = "Libraries/Vibration/*.{m,mm}"
    ss.preserve_paths         = "package.json", "LICENSE", "LICENSE-docs"
    ss.header_dir             = "RCTVibration"
    ss.pod_target_xcconfig    = {
                                "USE_HEADERMAP" => "YES",
                                "CLANG_CXX_LANGUAGE_STANDARD" => "c++14",
                                "HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/Folly\""
                              }
    ss.frameworks             = "AudioToolbox"

    ss.dependency "Folly", folly_version
    ss.dependency "React/FBReactNativeSpec"
    ss.dependency "React/ReactCommon/turbomodule/core"
    ss.dependency "React/React-Core/RCTVibrationHeaders"
  end

end
