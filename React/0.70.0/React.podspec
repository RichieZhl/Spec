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
  source[:commit] = `git rev-parse HEAD`.strip if system("git rev-parse --git-dir > /dev/null 2>&1")
else
  source[:tag] = "v#{version}"
end

folly_compiler_flags = '-DFOLLY_NO_CONFIG -DFOLLY_MOBILE=1 -DFOLLY_USE_LIBCPP=1 -Wno-comma -Wno-shorten-64-to-32'
folly_version = '2021.07.22.00'
boost_compiler_flags = '-Wno-documentation'

header_subspecs = {
  'CoreModulesHeaders'          => 'React/CoreModules/**/*.h',
  'RCTActionSheetHeaders'       => 'Libraries/ActionSheetIOS/*.h',
  'RCTAnimationHeaders'         => 'Libraries/NativeAnimation/{Drivers/*,Nodes/*,*}.{h}',
  'RCTBlobHeaders'              => 'Libraries/Blob/{RCTBlobManager,RCTFileReaderModule}.h',
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
  s.platforms              = { :ios => "11.0" }
  s.source                 = source
  s.libraries              = 'c++.1'
  s.preserve_paths         = "package.json", "LICENSE", "LICENSE-docs"
  s.cocoapods_version      = ">= 1.2.0"

  s.subspec "React-jsi" do |ss|
    ss.platforms              = { :ios => "11.0" }
    ss.source_files           = "ReactCommon/jsi/**/*.{cpp,h}"
    ss.exclude_files          = "ReactCommon/jsi/**/test/*"
    ss.framework              = "JavaScriptCore"
    ss.compiler_flags         = folly_compiler_flags + ' ' + boost_compiler_flags
    ss.pod_target_xcconfig    = { "HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/boost\" \"$(PODS_ROOT)/RCT-Folly\" \"$(PODS_ROOT)/DoubleConversion\"" }
    ss.header_dir             = "jsi"
  
    ss.dependency "boost", "1.76.0"
    ss.dependency "DoubleConversion"
    ss.dependency "RCT-Folly", folly_version
    ss.dependency "glog"
  
    ss.subspec "Default" do
      # no-op
    end
  
    ss.subspec "Fabric" do |sss|
      sss.pod_target_xcconfig  = { "OTHER_CFLAGS" => "$(inherited) -DRN_FABRIC_ENABLED" }
    end
  end

  s.subspec "React-jsinspector" do |ss|
    ss.platforms              = { :ios => "11.0" }
    ss.source_files           = "ReactCommon/jsinspector/*.{cpp,h}"
    ss.header_dir             = 'jsinspector'
    ss.pod_target_xcconfig    = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/ReactCommon/jsinspector\"" }
  end

  s.subspec "React-callinvoker" do |ss|
    ss.platforms              = { :ios => "11.0" }
    ss.source_files           = "ReactCommon/callinvoker/ReactCommon/*.{cpp,h}"
    ss.header_dir             = "ReactCommon"
    ss.pod_target_xcconfig    = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/ReactCommon/callinvoker/ReactCommon\"" }
  end

  s.subspec "React-runtimeexecutor" do |ss|
    ss.platforms              = { :ios => "11.0" }
    ss.source_files           = "ReactCommon/runtimeexecutor/ReactCommon/*.{cpp,h}"
    ss.header_dir             = "ReactCommon"
    ss.dependency "React/React-jsi"
    ss.pod_target_xcconfig    = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/ReactCommon/runtimeexecutor/ReactCommon\"" }
  end

  s.subspec "React-perflogger" do |ss|
    ss.platforms              = { :ios => "11.0" }
    ss.source_files           = "ReactCommon/reactperflogger/reactperflogger/*.{cpp,h}"
    ss.header_dir             = "ReactCommon"
    ss.pod_target_xcconfig    = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/ReactCommon/reactperflogger/reactperflogger\"" }
  end

  s.subspec "FBReactNativeSpec" do |ss|
    ss.platforms              = { :ios => "11.0" }
    ss.source_files           = "React/FBReactNativeSpec/FBReactNativeSpec/*.{c,h,m,mm,cpp}"
    ss.header_dir             = "FBReactNativeSpec"

    s.pod_target_xcconfig    = {
                               "USE_HEADERMAP" => "YES",
                               "CLANG_CXX_LANGUAGE_STANDARD" => "c++17",
                               "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/React/FBReactNativeSpec\" \"$(PODS_ROOT)/RCT-Folly\""
                             }

    ss.dependency "RCT-Folly", folly_version
    ss.dependency "React/RCTRequired"
    ss.dependency "React/RCTTypeSafety"
    ss.dependency "React/React-Core"
    ss.dependency "React/React-jsi"
    ss.dependency "React/ReactCommon/turbomodule/core"
  end

  s.subspec "React-logger" do |ss|
    ss.platforms              = { :ios => "11.0" }
    ss.source_files           = "ReactCommon/logger/*.{cpp,h}"
    ss.compiler_flags         = folly_compiler_flags + ' ' + boost_compiler_flags
    ss.pod_target_xcconfig    = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/ReactCommon/logger\"" }
    ss.header_dir             = "logger"
    
    ss.dependency "glog"
  end

  s.subspec "React-cxxreact" do |ss|
    ss.platforms              = { :ios => "11.0" }
    ss.source_files           = "ReactCommon/cxxreact/*.{cpp,h}"
    ss.exclude_files          = "ReactCommon/cxxreact/SampleCxxModule.*"
    ss.compiler_flags         = folly_compiler_flags + ' ' + boost_compiler_flags
    ss.pod_target_xcconfig    = { "HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/boost\" \"$(PODS_ROOT)/RCT-Folly\" \"$(PODS_ROOT)/DoubleConversion\"" }
    ss.header_dir             = "cxxreact"

    ss.dependency "boost", "1.76.0"
    ss.dependency "DoubleConversion"
    ss.dependency "RCT-Folly", folly_version
    ss.dependency "glog"
    ss.dependency "React/React-jsinspector"
    ss.dependency "React/React-callinvoker"
    ss.dependency "React/React-runtimeexecutor"
    ss.dependency "React/React-perflogger"
    ss.dependency "React/React-jsi"
  end

  s.subspec "React-jsiexecutor" do |ss|
    ss.platforms              = { :ios => "11.0" }
    ss.source_files         = "ReactCommon/jsiexecutor/jsireact/*.{cpp,h}"
    ss.compiler_flags         = folly_compiler_flags + ' ' + boost_compiler_flags
    ss.pod_target_xcconfig    = { "HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/boost\" \"$(PODS_ROOT)/RCT-Folly\" \"$(PODS_ROOT)/DoubleConversion\"" }
    ss.header_dir             = "jsireact"

    ss.dependency "React/React-cxxreact"
    ss.dependency "React/React-jsi"
    ss.dependency "RCT-Folly", folly_version
    ss.dependency "DoubleConversion"
    ss.dependency "glog"
  end

  s.subspec "React-Core" do |ss|
    ss.resource_bundle        = { "AccessibilityResources" => ["React/AccessibilityResources/*.lproj"]}
    ss.compiler_flags         = folly_compiler_flags + ' ' + boost_compiler_flags
    ss.header_dir             = "React"
    ss.framework              = "JavaScriptCore"
    ss.pod_target_xcconfig    = {
      "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/ReactCommon\" \"$(PODS_ROOT)/boost\" \"$(PODS_ROOT)/DoubleConversion\" \"$(PODS_ROOT)/RCT-Folly\" \"${PODS_ROOT}/Headers/Public/React-hermes\" \"${PODS_ROOT}/Headers/Public/hermes-engine\" \"$(PODS_ROOT)/Yoga\" \"$(PODS_ROOT)/Headers/Public/ReactCommon\" \"$(PODS_ROOT)/Headers/Public/React-RCTFabric\"",
      "FRAMEWORK_SEARCH_PATHS" => "\"${PODS_CONFIGURATION_BUILD_DIR}/React-hermes\"",
      "DEFINES_MODULE" => "YES",
      "GCC_PREPROCESSOR_DEFINITIONS" => "RCT_METRO_PORT=${RCT_METRO_PORT}",
      "CLANG_CXX_LANGUAGE_STANDARD" => "c++17",
    }
    ss.user_target_xcconfig   = { "HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/Headers/Private/React-Core\""}
    ss.subspec "Default" do |sss|
      sss.source_files           = "React/**/*.{c,h,m,mm,S,cpp}"
      sss.exclude_files          = "React/CoreModules/**/*",
                                  "React/DevSupport/**/*",
                                  "React/Fabric/**/*",
                                  "React/FBReactNativeSpec/**/*",
                                  "React/Tests/**/*",
                                  "React/Inspector/**/*"
      sss.private_header_files   = "React/Cxx*/*.h"
    end
  
    ss.subspec "DevSupport" do |sss|
      ss.source_files = "React/DevSupport/*.{h,mm,m}",
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
  
    ss.dependency "RCT-Folly", folly_version
    ss.dependency "React/React-cxxreact"
    ss.dependency "React/React-perflogger"
    ss.dependency "React/React-jsi"
    ss.dependency "React/React-jsiexecutor"
    ss.dependency "Yoga", '1.14.2'
    ss.dependency "glog"
  end

  s.subspec "React-bridging" do |ss|
    ss.platforms              = { :ios => "11.0" }
    ss.source_files           = "ReactCommon/react/bridging/**/*.{cpp,h}"
    ss.exclude_files          = "ReactCommon/react/bridging/tests"
    ss.header_dir             = "react/bridging"
    ss.compiler_flags         = folly_compiler_flags
    ss.pod_target_xcconfig    = { "HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/RCT-Folly\"",
                                "USE_HEADERMAP" => "YES",
                                "CLANG_CXX_LANGUAGE_STANDARD" => "c++17" }

    ss.dependency "RCT-Folly", folly_version
    ss.dependency "React/React-jsi"
  end

  s.subspec "ReactCommon" do |ss|
    ss.platforms              = { :ios => "11.0" }
    ss.header_dir             = "ReactCommon" # Use global header_dir for all subspecs for use_frameworks! compatibility
    ss.compiler_flags         = folly_compiler_flags + ' ' + boost_compiler_flags
    ss.pod_target_xcconfig    = { "HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/boost\" \"$(PODS_ROOT)/RCT-Folly\" \"$(PODS_ROOT)/DoubleConversion\" \"$(PODS_ROOT)/Headers/Private/React-Core\" \"$(PODS_ROOT)/Headers/Private/React-bridging/react/bridging\" \"$(PODS_CONFIGURATION_BUILD_DIR)/React-bridging/react_bridging.framework/Headers\"",
                                  "USE_HEADERMAP" => "YES",
                                  "CLANG_CXX_LANGUAGE_STANDARD" => "c++17" }
  
    ss.subspec "turbomodule" do |sss|
      sss.dependency "React/React-bridging"
      sss.dependency "React/React-callinvoker"
      sss.dependency "React/React-perflogger"
      sss.dependency "React/React-Core"
      sss.dependency "React/React-cxxreact"
      sss.dependency "React/React-jsi"
      sss.dependency "RCT-Folly", folly_version
      sss.dependency "React/React-logger"
      sss.dependency "DoubleConversion"
      sss.dependency "glog"
  
      sss.subspec "core" do |ssss|
        ssss.source_files = "ReactCommon/react/nativemodule/core/ReactCommon/**/*.{cpp,h}",
                            "ReactCommon/react/nativemodule/core/platform/ios/**/*.{mm,cpp,h}"
        ssss.pod_target_xcconfig = {"HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/ReactCommon/react/nativemodule/core/ReactCommon\" \"$(PODS_ROOT)/ReactCommon/react/nativemodule/core/platform/ios\""}
      end

      sss.subspec "react_debug_core" do |ssss|
        ssss.source_files = "ReactCommon/react/debug/*.{cpp,h}"
      end
  
      sss.subspec "samples" do |ssss|
        ssss.source_files = "ReactCommon/react/nativemodule/samples/ReactCommon/**/*.{cpp,h}",
                            "ReactCommonreact/nativemodule/samples/platform/ios/**/*.{mm,cpp,h}"
        ssss.dependency "React/ReactCommon/turbomodule/core"
      end
    end
  end

  s.subspec "FBLazyVector" do |ss|
    ss.platforms              = { :ios => "11.0" }
    ss.source_files           = "Libraries/FBLazyVector/**/*.{c,h,m,mm,cpp}"
    ss.header_dir             = "FBLazyVector"
  end

  s.subspec "RCTRequired" do |ss|
    ss.platforms              = { :ios => "11.0" }
    ss.source_files           = "Libraries/RCTRequired/**/*.{c,h,m,mm,cpp}"
    ss.header_dir             = "RCTRequired"
  end

  s.subspec "RCTTypeSafety" do |ss|
    ss.platforms              = { :ios => "11.0" }
    ss.source_files           = "Libraries/TypeSafety/**/*.{c,h,m,mm,cpp}"
    ss.compiler_flags         = folly_compiler_flags
    ss.header_dir             = "RCTTypeSafety"
    ss.pod_target_xcconfig    = {
                                  "USE_HEADERMAP" => "YES",
                                  "CLANG_CXX_LANGUAGE_STANDARD" => "c++17",
                                  "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/Libraries/TypeSafety\""
                                }
  
    ss.dependency "React/FBLazyVector"
    ss.dependency "React/RCTRequired"
    ss.dependency "React/React-Core"
  end

  s.subspec "React-RCTActionSheet" do |ss|
    ss.platforms              = { :ios => "11.0" }
    ss.source_files           = "Libraries/ActionSheetIOS/*.{m}"
    ss.preserve_paths          = "package.json", "LICENSE", "LICENSE-docs"
    ss.header_dir             = "RCTActionSheet"
    ss.dependency "React/React-Core/RCTActionSheetHeaders"
  end

  s.subspec "React-RCTAnimation" do |ss|
    ss.platforms              = { :ios => "11.0" }
    ss.compiler_flags         = folly_compiler_flags + ' -Wno-nullability-completeness'
    ss.source_files           = "Libraries/NativeAnimation/{Drivers/*,Nodes/*,*}.{m,mm}"
    ss.preserve_paths         = "package.json", "LICENSE", "LICENSE-docs"
    ss.header_dir             = "RCTAnimation"
    ss.pod_target_xcconfig    = {
                                 "USE_HEADERMAP" => "YES",
                                 "CLANG_CXX_LANGUAGE_STANDARD" => "c++17",
                                 "HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/RCT-Folly\""
                               }
  
    ss.dependency "RCT-Folly", folly_version
    ss.dependency "React/FBReactNativeSpec"
    ss.dependency "React/RCTTypeSafety"
    ss.dependency "React/ReactCommon/turbomodule/core"
    ss.dependency "React/React-jsi"
    ss.dependency "React/React-Core/RCTAnimationHeaders"
  end

  s.subspec "React-RCTBlob" do |ss|
    ss.platforms              = { :ios => "11.0" }
    ss.compiler_flags         = folly_compiler_flags + ' -Wno-nullability-completeness'
    ss.source_files           = "Libraries/Blob/*.{h,m,mm}"
    ss.preserve_paths         = "package.json", "LICENSE", "LICENSE-docs"
    ss.header_dir             = "RCTBlob"
    ss.pod_target_xcconfig    = {
                                "USE_HEADERMAP" => "YES",
                                "CLANG_CXX_LANGUAGE_STANDARD" => "c++17",
                                "HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/RCT-Folly\""
                              }

    ss.dependency "RCT-Folly", folly_version
    ss.dependency "React/FBReactNativeSpec"
    ss.dependency "React/ReactCommon/turbomodule/core"
    ss.dependency "React/React-Core/RCTBlobHeaders"
    ss.dependency "React/React-Core/RCTWebSocket"
    ss.dependency "React/React-RCTNetwork"
    ss.dependency "React/React-jsi"
  end

  s.subspec "React-RCTImage" do |ss|
    ss.platforms              = { :ios => "11.0" }
    ss.compiler_flags         = folly_compiler_flags + ' -Wno-nullability-completeness'
    ss.source_files           = "Libraries/Image/*.{m,mm}"
    ss.preserve_paths         = "package.json", "LICENSE", "LICENSE-docs"
    ss.header_dir             = "RCTImage"
    ss.pod_target_xcconfig    = {
                                "USE_HEADERMAP" => "YES",
                                "CLANG_CXX_LANGUAGE_STANDARD" => "c++17",
                                "HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/RCT-Folly\""
                              }

    ss.dependency "RCT-Folly", folly_version
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
                                "CLANG_CXX_LANGUAGE_STANDARD" => "c++17",
                                "HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/RCT-Folly\""
                              }
                              
    ss.dependency "React/FBReactNativeSpec"
    ss.dependency "React/React-Core/RCTLinkingHeaders"
    ss.dependency "React/ReactCommon/turbomodule/core"
    ss.dependency "React/React-jsi"
  end

  s.subspec "React-RCTNetwork" do |ss|
    ss.platforms              = { :ios => "11.0" }
    ss.compiler_flags         = folly_compiler_flags + ' -Wno-nullability-completeness'
    ss.source_files           = "Libraries/Network/*.{m,mm}"
    ss.preserve_paths         = "package.json", "LICENSE", "LICENSE-docs"
    ss.header_dir             = "RCTNetwork"
    ss.pod_target_xcconfig    = {
                                "USE_HEADERMAP" => "YES",
                                "CLANG_CXX_LANGUAGE_STANDARD" => "c++17",
                                "HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/RCT-Folly\""
                              }
    ss.frameworks             = "MobileCoreServices"

    ss.dependency "RCT-Folly", folly_version
    ss.dependency "React/FBReactNativeSpec"
    ss.dependency "React/RCTTypeSafety"
    ss.dependency "React/ReactCommon/turbomodule/core"
    ss.dependency "React/React-jsi"
    ss.dependency "React/React-Core/RCTNetworkHeaders"
  end

  s.subspec "React-RCTSettings" do |ss|
    ss.platforms              = { :ios => "11.0" }
    ss.compiler_flags         = folly_compiler_flags + ' -Wno-nullability-completeness'
    ss.source_files           = "Libraries/Settings/*.{m,mm}"
    ss.preserve_paths         = "package.json", "LICENSE", "LICENSE-docs"
    ss.header_dir             = "RCTSettings"
    ss.pod_target_xcconfig    = {
                                "USE_HEADERMAP" => "YES",
                                "CLANG_CXX_LANGUAGE_STANDARD" => "c++17",
                                "HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/RCT-Folly\""
                              }

    ss.dependency "RCT-Folly", folly_version
    ss.dependency "React/FBReactNativeSpec"
    ss.dependency "React/RCTTypeSafety"
    ss.dependency "React/ReactCommon/turbomodule/core"
    ss.dependency "React/React-jsi"
    ss.dependency "React/React-Core/RCTSettingsHeaders"
  end

  s.subspec "React-RCTText" do |ss|
    ss.platforms              = { :ios => "11.0" }
    ss.source_files           = "Libraries/Text/**/*.{h,m}"
    ss.preserve_paths         = "package.json", "LICENSE", "LICENSE-docs"
    ss.header_dir             = "RCTText"

    ss.dependency "React/React-Core/RCTTextHeaders"
  end

  s.subspec "React-RCTVibration" do |ss|
    ss.platforms              = { :ios => "11.0" }
    ss.compiler_flags         = folly_compiler_flags + ' -Wno-nullability-completeness'
    ss.source_files           = "Libraries/Vibration/*.{m,mm}"
    ss.preserve_paths         = "package.json", "LICENSE", "LICENSE-docs"
    ss.header_dir             = "RCTVibration"
    ss.pod_target_xcconfig    = {
                                "USE_HEADERMAP" => "YES",
                                "CLANG_CXX_LANGUAGE_STANDARD" => "c++17",
                                "HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/RCT-Folly\""
                              }
    ss.frameworks             = "AudioToolbox"

    ss.dependency "RCT-Folly", folly_version
    ss.dependency "React/FBReactNativeSpec"
    ss.dependency "React/ReactCommon/turbomodule/core"
    ss.dependency "React/React-jsi"
    ss.dependency "React/React-Core/RCTVibrationHeaders"
  end

  s.subspec "React-CoreModules" do |ss|
    ss.platforms              = { :ios => "11.0" }
    ss.compiler_flags         = folly_compiler_flags + ' -Wno-nullability-completeness'
    ss.source_files           = "React/CoreModules/**/*.{c,m,mm,cpp}"
    ss.preserve_paths         = "package.json", "LICENSE", "LICENSE-docs"
    ss.header_dir             = "CoreModules"
    
    ss.pod_target_xcconfig    = {
                                  "USE_HEADERMAP" => "YES",
                                  "CLANG_CXX_LANGUAGE_STANDARD" => "c++17",
                                  "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/React/CoreModules\" \"$(PODS_ROOT)/RCT-Folly\""
                                }

    ss.dependency "React/FBReactNativeSpec"
    ss.dependency "RCT-Folly", folly_version
    ss.dependency "React/RCTTypeSafety"
    ss.dependency "React/React-Core/CoreModulesHeaders"
    ss.dependency "React/React-RCTImage", version
    ss.dependency "React/ReactCommon/turbomodule/core"
    ss.dependency "React/React-jsi"
  end

  s.subspec "Hermes" do |ss|
    ss.platforms = { :osx => "10.14", :ios => "11.0" }
    ss.source_files           = "ReactCommon/hermes/executor/*.{cpp,h}",
                                "ReactCommon/hermes/inspector/*.{cpp,h}",
                                "ReactCommon/hermes/inspector/chrome/*.{cpp,h}",
                                "ReactCommon/hermes/inspector/detail/*.{cpp,h}"
    ss.public_header_files    = "ReactCommon/hermes/executor/HermesExecutorFactory.h"
    ss.compiler_flags         = folly_compiler_flags + ' ' + boost_compiler_flags
    ss.pod_target_xcconfig    = {
                                "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/..\" \"$(PODS_ROOT)/boost\" \"$(PODS_ROOT)/RCT-Folly\" \"$(PODS_ROOT)/DoubleConversion\" \"$(PODS_ROOT)/libevent/include\"",
                                "GCC_PREPROCESSOR_DEFINITIONS" => "HERMES_ENABLE_DEBUGGER=1",
                              }
    ss.header_dir             = "reacthermes"
    ss.dependency "React/React-cxxreact"
    ss.dependency "React/React-jsi"
    ss.dependency "React/React-jsiexecutor"
    ss.dependency "React/React-jsinspector"
    ss.dependency "React/React-perflogger"
    ss.dependency "RCT-Folly", folly_version
    ss.dependency "DoubleConversion"
    ss.dependency "glog"
    ss.dependency "RCT-Folly/Futures", folly_version
    ss.dependency "hermes-engine"
  end

  s.subspec "React-graphics" do |ss|
    ss.platforms              = { :ios => "12.4", :tvos => "12.4" }
    ss.compiler_flags         = folly_compiler_flags + ' ' + boost_compiler_flags
    ss.source_files           = "ReactCommon/react/renderer/graphics/**/*.{m,mm,cpp,h}"
    ss.exclude_files          = "ReactCommon/react/renderer/graphics/tests",
                                "ReactCommon/react/renderer/graphics/platform/android",
                                "ReactCommon/react/renderer/graphics/platform/cxx"
    ss.header_dir             = "react/renderer/graphics"
    ss.pod_target_xcconfig  = { "USE_HEADERMAP" => "NO", "HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/boost\" \"$(PODS_TARGET_SRCROOT)/ReactCommon\" \"$(PODS_ROOT)/RCT-Folly\"" }

    ss.dependency "RCT-Folly/Fabric", folly_version
    ss.dependency "React/React-Core/Default"
  end

  s.subspec "React-Fabric" do |ss|
    ss.platforms = { :ios => "11.0" }
    ss.exclude_files        = "ReactCommon/react/renderer/graphics"
    ss.header_dir             = "react/renderer/graphics"
    ss.pod_target_xcconfig = { "USE_HEADERMAP" => "YES", "CLANG_CXX_LANGUAGE_STANDARD" => "c++17", "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/ReactCommon\" \"$(PODS_ROOT)/RCT-Folly\"" }

    ss.dependency "RCT-Folly/Fabric", folly_version
    ss.dependency "React/React-graphics"
    ss.dependency "React/React-jsiexecutor"
    ss.dependency "React/RCTRequired"
    ss.dependency "React/RCTTypeSafety"
    ss.dependency "React/ReactCommon/turbomodule/core"
    ss.dependency "React/React-jsi"

    ss.subspec "animations" do |sss|
      sss.dependency             "RCT-Folly/Fabric", folly_version
      sss.compiler_flags       = folly_compiler_flags
      sss.source_files         = "ReactCommon/react/renderer/animations/**/*.{m,mm,cpp,h}"
      sss.exclude_files        = "ReactCommon/react/renderer/animations/tests"
      sss.header_dir           = "react/renderer/animations"
      sss.pod_target_xcconfig  = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/ReactCommon\" \"$(PODS_ROOT)/RCT-Folly\"" }
    end
  
    ss.subspec "attributedstring" do |sss|
      sss.dependency             "RCT-Folly/Fabric", folly_version
      sss.compiler_flags       = folly_compiler_flags
      sss.source_files         = "ReactCommon/react/renderer/attributedstring/**/*.{m,mm,cpp,h}"
      sss.exclude_files        = "ReactCommon/react/renderer/attributedstring/tests"
      sss.header_dir           = "react/renderer/attributedstring"
      sss.pod_target_xcconfig  = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/ReactCommon\" \"$(PODS_ROOT)/RCT-Folly\"" }
    end
  
    ss.subspec "butter" do |sss|
      sss.dependency             "RCT-Folly/Fabric", folly_version
      sss.compiler_flags       = folly_compiler_flags
      sss.source_files         = "ReactCommon/butter/**/*.{m,mm,cpp,h}"
      sss.exclude_files        = "ReactCommon/butter/tests"
      sss.header_dir           = "butter"
      sss.pod_target_xcconfig  = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/ReactCommon\" \"$(PODS_ROOT)/RCT-Folly\"" }
    end
  
    ss.subspec "config" do |sss|
      sss.source_files         = "ReactCommon/react/config/*.{m,mm,cpp,h}"
      sss.header_dir           = "react/config"
      sss.pod_target_xcconfig  = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/ReactCommon\"" }
    end
  
    ss.subspec "core" do |sss|
      sss.dependency             "RCT-Folly/Fabric", folly_version
      sss.compiler_flags       = folly_compiler_flags + ' ' + boost_compiler_flags
      sss.source_files         = "ReactCommon/react/renderer/core/**/*.{m,mm,cpp,h}"
      sss.exclude_files        = "ReactCommon/react/renderer/core/tests"
      sss.header_dir           = "react/renderer/core"
      sss.pod_target_xcconfig  = { "HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/boost\" \"$(PODS_TARGET_SRCROOT)/ReactCommon\" \"$(PODS_ROOT)/RCT-Folly\"" }
    end
  
    ss.subspec "componentregistry" do |sss|
      sss.dependency             "RCT-Folly/Fabric", folly_version
      sss.compiler_flags       = folly_compiler_flags
      sss.source_files         = "ReactCommon/react/renderer/componentregistry/**/*.{m,mm,cpp,h}"
      sss.header_dir           = "react/renderer/componentregistry"
      sss.pod_target_xcconfig  = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/ReactCommon\" \"$(PODS_ROOT)/RCT-Folly\"" }
    end
  
    ss.subspec "componentregistrynative" do |sss|
      sss.dependency             "RCT-Folly/Fabric", folly_version
      sss.compiler_flags       = folly_compiler_flags
      sss.source_files         = "ReactCommon/react/renderer/componentregistry/native/**/*.{m,mm,cpp,h}"
      sss.header_dir           = "react/renderer/componentregistry/native"
      sss.pod_target_xcconfig  = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/ReactCommon\" \"$(PODS_ROOT)/RCT-Folly\"" }
    end
  
    ss.subspec "components" do |sss|
      sss.subspec "activityindicator" do |ssss|
        ssss.dependency             "RCT-Folly/Fabric", folly_version
        ssss.compiler_flags       = folly_compiler_flags
        ssss.source_files         = "ReactCommon/react/renderer/components/activityindicator/**/*.{m,mm,cpp,h}"
        ssss.exclude_files        = "ReactCommon/react/renderer/components/activityindicator/tests"
        ssss.header_dir           = "react/renderer/components/activityindicator"
        ssss.pod_target_xcconfig  = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/ReactCommon\" \"$(PODS_ROOT)/RCT-Folly\"" }
      end
  
      sss.subspec "image" do |ssss|
        ssss.dependency             "RCT-Folly/Fabric", folly_version
        ssss.compiler_flags       = folly_compiler_flags
        ssss.source_files         = "ReactCommon/react/renderer/components/image/**/*.{m,mm,cpp,h}"
        ssss.exclude_files        = "ReactCommon/react/renderer/components/image/tests"
        ssss.header_dir           = "react/renderer/components/image"
        ssss.pod_target_xcconfig  = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/ReactCommon\" \"$(PODS_ROOT)/RCT-Folly\"" }
      end
  
      sss.subspec "inputaccessory" do |ssss|
        ssss.dependency             "RCT-Folly/Fabric", folly_version
        ssss.compiler_flags       = folly_compiler_flags
        ssss.source_files         = "ReactCommon/react/renderer/components/inputaccessory/**/*.{m,mm,cpp,h}"
        ssss.exclude_files        = "ReactCommon/react/renderer/components/inputaccessory/tests"
        ssss.header_dir           = "react/renderer/components/inputaccessory"
        ssss.pod_target_xcconfig  = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/ReactCommon\" \"$(PODS_ROOT)/RCT-Folly\"" }
      end
  
      sss.subspec "legacyviewmanagerinterop" do |ssss|
        ssss.dependency             "RCT-Folly/Fabric", folly_version
        ssss.compiler_flags       = folly_compiler_flags
        ssss.source_files         = "ReactCommon/react/renderer/components/legacyviewmanagerinterop/**/*.{m,mm,cpp,h}"
        ssss.exclude_files        = "ReactCommon/react/renderer/components/legacyviewmanagerinterop/tests"
        ssss.header_dir           = "react/renderer/components/legacyviewmanagerinterop"
        ssss.pod_target_xcconfig  = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/ReactCommon\" \"$(PODS_ROOT)/RCT-Folly\" \"$(PODS_ROOT)/Headers/Private/React-Core\"" }
      end
  
      sss.subspec "modal" do |ssss|
        sss.dependency             "RCT-Folly/Fabric", folly_version
        sss.compiler_flags       = folly_compiler_flags
        sss.source_files         = "ReactCommon/react/renderer/components/modal/**/*.{m,mm,cpp,h}"
        sss.exclude_files        = "ReactCommon/react/renderer/components/modal/tests"
        sss.header_dir           = "react/renderer/components/modal"
        sss.pod_target_xcconfig  = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/ReactCommon\" \"$(PODS_ROOT)/RCT-Folly\"" }
      end
  
      sss.subspec "root" do |ssss|
        sss.dependency             "RCT-Folly/Fabric", folly_version
        sss.compiler_flags       = folly_compiler_flags
        sss.source_files         = "ReactCommon/react/renderer/components/root/**/*.{m,mm,cpp,h}"
        sss.exclude_files        = "ReactCommon/react/renderer/components/root/tests"
        sss.header_dir           = "react/renderer/components/root"
        sss.pod_target_xcconfig  = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/ReactCommon\" \"$(PODS_ROOT)/RCT-Folly\"" }
      end
  
      sss.subspec "safeareaview" do |ssss|
        ssss.dependency             "RCT-Folly/Fabric", folly_version
        ssss.compiler_flags       = folly_compiler_flags
        ssss.source_files         = "ReactCommon/react/renderer/components/safeareaview/**/*.{m,mm,cpp,h}"
        ssss.exclude_files        = "ReactCommon/react/renderer/components/safeareaview/tests"
        ssss.header_dir           = "react/renderer/components/safeareaview"
        ssss.pod_target_xcconfig  = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/ReactCommon\" \"$(PODS_ROOT)/RCT-Folly\"" }
      end
  
      sss.subspec "scrollview" do |ssss|
        ssss.dependency             "RCT-Folly/Fabric", folly_version
        ssss.compiler_flags       = folly_compiler_flags
        ssss.source_files         = "ReactCommon/react/renderer/components/scrollview/**/*.{m,mm,cpp,h}"
        ssss.exclude_files        = "ReactCommon/react/renderer/components/scrollview/tests"
        ssss.header_dir           = "react/renderer/components/scrollview"
        ssss.pod_target_xcconfig  = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/ReactCommon\" \"$(PODS_ROOT)/RCT-Folly\"" }
      end
  
      sss.subspec "slider" do |ssss|
        ssss.dependency             "RCT-Folly/Fabric", folly_version
        ssss.compiler_flags       = folly_compiler_flags
        ssss.source_files         = "ReactCommon/react/renderer/components/slider/**/*.{m,mm,cpp,h}"
        ssss.exclude_files        = "ReactCommon/react/renderer/components/slider/tests/**/*",
                                   "react/renderer/components/slider/platform/android"
        ssss.header_dir           = "react/renderer/components/slider"
        ssss.pod_target_xcconfig  = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/ReactCommon\" \"$(PODS_ROOT)/RCT-Folly\"" }
      end
  
      sss.subspec "text" do |ssss|
        ssss.dependency             "RCT-Folly/Fabric", folly_version
        ssss.compiler_flags       = folly_compiler_flags
        ssss.source_files         = "ReactCommon/react/renderer/components/text/**/*.{m,mm,cpp,h}"
        ssss.exclude_files        = "ReactCommon/react/renderer/components/text/tests"
        ssss.header_dir           = "react/renderer/components/text"
        ssss.pod_target_xcconfig  = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/ReactCommon\" \"$(PODS_ROOT)/RCT-Folly\"" }
      end
  
      sss.subspec "textinput" do |ssss|
        ssss.dependency             "RCT-Folly/Fabric", folly_version
        ssss.compiler_flags       = folly_compiler_flags
        ssss.source_files         = "ReactCommon/react/renderer/components/textinput/iostextinput/**/*.{m,mm,cpp,h}"
        ssss.exclude_files        = "ReactCommon/react/renderer/components/textinput/iostextinput/tests"
        ssss.header_dir           = "react/renderer/components/iostextinput"
        ssss.pod_target_xcconfig  = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/ReactCommon\" \"$(PODS_ROOT)/RCT-Folly\"" }
      end
  
      sss.subspec "unimplementedview" do |ssss|
        ssss.dependency             "RCT-Folly/Fabric", folly_version
        ssss.compiler_flags       = folly_compiler_flags
        ssss.source_files         = "ReactCommon/react/renderer/components/unimplementedview/**/*.{m,mm,cpp,h}"
        ssss.exclude_files        = "ReactCommon/react/renderer/components/unimplementedview/tests"
        ssss.header_dir           = "react/renderer/components/unimplementedview"
        ssss.pod_target_xcconfig  = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/ReactCommon\" \"$(PODS_ROOT)/RCT-Folly\"" }
      end
  
      sss.subspec "view" do |ssss|
        ssss.dependency             "RCT-Folly/Fabric", folly_version
        ssss.dependency             "Yoga"
        ssss.compiler_flags       = folly_compiler_flags
        ssss.source_files         = "ReactCommon/react/renderer/components/view/**/*.{m,mm,cpp,h}"
        ssss.exclude_files        = "ReactCommon/react/renderer/components/view/tests"
        ssss.header_dir           = "react/renderer/components/view"
        ssss.pod_target_xcconfig  = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/ReactCommon\" \"$(PODS_ROOT)/RCT-Folly\"" }
      end
    end
  
    ss.subspec "debug_core" do |sss|
      sss.dependency             "RCT-Folly/Fabric", folly_version
      sss.compiler_flags       = folly_compiler_flags
      sss.source_files         = "ReactCommon/react/debug/**/*.{m,mm,cpp,h}"
      sss.exclude_files        = "ReactCommon/react/debug/tests"
      sss.header_dir           = "react/debug"
      sss.pod_target_xcconfig  = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/ReactCommon\" \"$(PODS_ROOT)/RCT-Folly\"" }
    end
  
    ss.subspec "debug_renderer" do |sss|
      sss.dependency             "RCT-Folly/Fabric", folly_version
      sss.compiler_flags       = folly_compiler_flags
      sss.source_files         = "ReactCommon/react/renderer/debug/**/*.{m,mm,cpp,h}"
      sss.exclude_files        = "ReactCommon/react/renderer/debug/tests"
      sss.header_dir           = "react/renderer/debug"
      sss.pod_target_xcconfig  = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/ReactCommon\" \"$(PODS_ROOT)/RCT-Folly\"" }
    end
  
    ss.subspec "imagemanager" do |sss|
      sss.dependency             "React/React-RCTImage"
      sss.dependency             "RCT-Folly/Fabric", folly_version
      sss.compiler_flags       = folly_compiler_flags
      sss.source_files         = "ReactCommon/react/renderer/imagemanager/**/*.{m,mm,cpp,h}"
      sss.exclude_files        = "ReactCommon/react/renderer/imagemanager/tests",
                                "ReactCommon/react/renderer/imagemanager/platform/android",
                                "ReactCommon/react/renderer/imagemanager/platform/cxx"
      sss.header_dir           = "react/renderer/imagemanager"
      sss.pod_target_xcconfig  = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/ReactCommon\" \"$(PODS_ROOT)/RCT-Folly\"" }
    end
  
    ss.subspec "mounting" do |sss|
      sss.dependency             "RCT-Folly/Fabric", folly_version
      sss.compiler_flags       = folly_compiler_flags
      sss.source_files         = "ReactCommon/react/renderer/mounting/**/*.{m,mm,cpp,h}"
      sss.exclude_files        = "ReactCommon/react/renderer/mounting/tests"
      sss.header_dir           = "react/renderer/mounting"
      sss.pod_target_xcconfig  = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/ReactCommon\" \"$(PODS_ROOT)/RCT-Folly\"" }
    end
  
    ss.subspec "scheduler" do |sss|
      sss.dependency             "RCT-Folly/Fabric", folly_version
      sss.compiler_flags       = folly_compiler_flags
      sss.source_files         = "ReactCommon/react/renderer/scheduler/**/*.{m,mm,cpp,h}"
      sss.header_dir           = "react/renderer/scheduler"
      sss.pod_target_xcconfig  = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/ReactCommon\" \"$(PODS_ROOT)/RCT-Folly\"" }
    end
  
    ss.subspec "templateprocessor" do |sss|
      sss.dependency             "RCT-Folly/Fabric", folly_version
      sss.compiler_flags       = folly_compiler_flags
      sss.source_files         = "ReactCommon/react/renderer/templateprocessor/**/*.{m,mm,cpp,h}"
      sss.exclude_files        = "ReactCommon/react/renderer/templateprocessor/tests"
      sss.header_dir           = "react/renderer/templateprocessor"
      sss.pod_target_xcconfig  = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/ReactCommon\" \"$(PODS_ROOT)/RCT-Folly\"" }
    end
  
    ss.subspec "textlayoutmanager" do |sss|
      sss.dependency             "RCT-Folly/Fabric", folly_version
      sss.dependency             "React/React-Fabric/uimanager"
      sss.compiler_flags       = folly_compiler_flags
      sss.source_files         = "ReactCommon/react/renderer/textlayoutmanager/platform/ios/**/*.{m,mm,cpp,h}",
                                "ReactCommon/react/renderer/textlayoutmanager/*.{m,mm,cpp,h}"
      sss.exclude_files        = "ReactCommon/react/renderer/textlayoutmanager/tests",
                                "ReactCommon/react/renderer/textlayoutmanager/platform/android",
                                "ReactCommon/react/renderer/textlayoutmanager/platform/cxx"
      sss.header_dir           = "react/renderer/textlayoutmanager"
      sss.pod_target_xcconfig  = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/ReactCommon\" \"$(PODS_ROOT)/RCT-Folly\"" }
    end
  
    ss.subspec "uimanager" do |sss|
      sss.dependency             "RCT-Folly/Fabric", folly_version
      sss.compiler_flags       = folly_compiler_flags
      sss.source_files         = "ReactCommon/react/renderer/uimanager/**/*.{m,mm,cpp,h}"
      sss.exclude_files        = "ReactCommon/react/renderer/uimanager/tests"
      sss.header_dir           = "react/renderer/uimanager"
      sss.pod_target_xcconfig  = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/ReactCommon\" \"$(PODS_ROOT)/RCT-Folly\"" }
    end
  
    ss.subspec "telemetry" do |sss|
      sss.dependency             "RCT-Folly/Fabric", folly_version
      sss.compiler_flags       = folly_compiler_flags
      sss.source_files         = "ReactCommon/react/renderer/telemetry/**/*.{m,mm,cpp,h}"
      sss.exclude_files        = "ReactCommon/react/renderer/telemetry/tests"
      sss.header_dir           = "react/renderer/telemetry"
      sss.pod_target_xcconfig  = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/ReactCommon\" \"$(PODS_ROOT)/RCT-Folly\"" }
    end
  
    ss.subspec "leakchecker" do |sss|
      sss.dependency             "RCT-Folly/Fabric", folly_version
      sss.compiler_flags       = folly_compiler_flags
      sss.source_files         = "ReactCommon/react/renderer/leakchecker/**/*.{cpp,h}"
      sss.exclude_files        = "ReactCommon/react/renderer/leakchecker/tests"
      sss.header_dir           = "react/renderer/leakchecker"
      sss.pod_target_xcconfig  = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/ReactCommon\" \"$(PODS_ROOT)/RCT-Folly\"" }
    end
  
    ss.subspec "runtimescheduler" do |sss|
      sss.dependency             "RCT-Folly/Fabric", folly_version
      sss.compiler_flags       = folly_compiler_flags
      sss.source_files         = "ReactCommon/react/renderer/runtimescheduler/**/*.{cpp,h}"
      sss.exclude_files        = "ReactCommon/react/renderer/runtimescheduler/tests"
      sss.header_dir           = "react/renderer/runtimescheduler"
      sss.pod_target_xcconfig  = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/ReactCommon\" \"$(PODS_ROOT)/RCT-Folly\"" }
    end
  
    ss.subspec "utils" do |sss|
      sss.source_files         = "ReactCommon/react/utils/*.{m,mm,cpp,h}"
      sss.header_dir           = "react/utils"
      sss.pod_target_xcconfig  = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/ReactCommon\" \"$(PODS_ROOT)/RCT-Folly\"" }
    end

    ss.subspec "rncore" do |sss|
      sss.dependency             "RCT-Folly/Fabric", folly_version
      sss.dependency             "React/React-Fabric/core"
      sss.dependency             "React/React-Fabric/components/view"
      sss.dependency             "React/React-Fabric/components/image"
      sss.dependency             "React/React-Fabric/imagemanager"

      sss.compiler_flags       = folly_compiler_flags
      sss.source_files         = "ReactCommon/react/renderer/components/rncore/*.{m,mm,cpp,h}"
      sss.header_dir           = "react/renderer/components/rncore"
      sss.pod_target_xcconfig  = { "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/ReactCommon\" \"$(PODS_ROOT)/RCT-Folly\"" }
    end
    
  end

end
