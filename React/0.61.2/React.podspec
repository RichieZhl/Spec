# coding: utf-8
# Copyright (c) Facebook, Inc. and its affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))
version = package['version']

source = { :git => 'https://github.com/facebook/react-native.git' }
if version == '1000.0.0'
  # This is an unpublished version, use the latest commit hash of the react-native repo, which we’re presumably in.
  source[:commit] = `git rev-parse HEAD`.strip
else
  source[:tag] = "v#{version}"
end

folly_compiler_flags = '-DFOLLY_NO_CONFIG -DFOLLY_MOBILE=1 -DFOLLY_USE_LIBCPP=1 -Wno-comma -Wno-shorten-64-to-32'
folly_version = '2018.10.22.00'
boost_compiler_flags = '-Wno-documentation'

header_subspecs = {
  'ART'                  => 'Libraries/ART/**/*.{c,h,m,mm,S,cpp}',
  'CoreModules'          => 'React/CoreModules/**/*.{c,h,m,mm,S,cpp}',
  'RCTActionSheet'       => 'Libraries/ActionSheetIOS/*.{c,h,m,mm,S,cpp}',
  'RCTAnimation'         => 'Libraries/NativeAnimation/{Drivers/*,Nodes/*,*}.{c,h,m,mm,S,cpp}',
  'RCTBlob'              => 'Libraries/Blob/{RCTBlobManager,RCTFileReaderModule}.{c,h,m,mm,S,cpp}',
  'RCTImage'             => 'Libraries/Image/*.{c,h,m,mm,S,cpp}',
  'RCTLinking'           => 'Libraries/LinkingIOS/*.{c,h,m,mm,S,cpp}',
  'RCTNetwork'           => 'Libraries/Network/*.{c,h,m,mm,S,cpp}',
  'RCTPushNotification'  => 'Libraries/PushNotificationIOS/*.{c,h,m,mm,S,cpp}',
  'RCTSettings'          => 'Libraries/Settings/*.{c,h,m,mm,S,cpp}',
  'RCTText'              => 'Libraries/Text/**/*.{c,h,m,mm,S,cpp}',
  'RCTVibration'         => 'Libraries/Vibration/*.{c,h,m,mm,S,cpp}',
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
  s.platforms              = { :ios => "9.0", :tvos => "9.2" }
  s.source                 = source
  s.preserve_paths         = "package.json", "LICENSE", "LICENSE-docs"
  s.cocoapods_version      = ">= 1.2.0"

  s.subspec "Default" do |ss|
    ss.source_files           = "React/**/*.{c,h,m,mm,S,cpp}", 
                                "ReactCommon/cxxreact/*.{h,cpp}", 
                                "ReactCommon/jsi/**/*.{h,cpp}", 
                                "ReactCommon/jsiexecutor/jsireact/*.{cpp,h}", 
                                "Libraries/FBReactNativeSpec/**/*.{c,h,m,mm,S,cpp}",
                                "Libraries/RCTRequired/**/*.{c,h,m,mm,S,cpp}",
                                "Libraries/FBLazyVector/**/*.{c,h,m,mm,S,cpp}",
                                "Libraries/TypeSafety/**/*.{c,h,m,mm,S,cpp}"
    ss.exclude_files          = "React/CoreModules/**/*",
                                "React/DevSupport/**/*",
                                "React/Fabric/**/*",
                                "React/Inspector/**/*",
                                "ReactCommon/cxxreact/SampleCxxModule.*",
                                "ReactCommon/jsi/**/test/*"
    ss.ios.exclude_files      = "React/**/RCTTV*.*"
    ss.tvos.exclude_files     = "React/Modules/RCTClipboard*",
                                "React/Views/RCTDatePicker*",
                                "React/Views/RCTPicker*",
                                "React/Views/RCTRefreshControl*",
                                "React/Views/RCTSlider*",
                                "React/Views/RCTSwitch*",
    ss.private_header_files   = "React/Cxx*/*.h"
  end

  s.subspec "RCTWebSocket" do |ss|
    ss.source_files = "Libraries/WebSocket/*.{h,m}"
    ss.dependency "React/Default", version
  end

  # Add a subspec containing just the headers for each
  # pod that should live under <React/*.h>
  header_subspecs.each do |name, headers|
    s.subspec name do |ss|
      ss.source_files = headers
      ss.dependency "React/Default"
    end
  end

  s.subspec "DevSupport" do |ss|
    ss.source_files = "React/DevSupport/*.{h,mm,m}",
                      "React/Inspector/*.{h,mm,m}",
                      "ReactCommon/jsinspector/*.{cpp,h}"

    ss.dependency "React/Default", version
    ss.dependency "React/RCTWebSocket", version
    # ss.dependency "React-jsinspector", version
  end

  s.dependency "Folly", folly_version
  # s.dependency "React-cxxreact", version
  # s.dependency "React-jsi", version
  # s.dependency "React-jsiexecutor", version
  s.dependency "Yoga"
  s.dependency "glog"
end
