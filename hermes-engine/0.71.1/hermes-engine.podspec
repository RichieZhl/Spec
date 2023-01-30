# Copyright (c) Meta Platforms, Inc. and affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

version = '0.71.1'

source = {}
git = "https://github.com/facebook/hermes.git"

source[:http] = "https://repo1.maven.org/maven2/com/facebook/react/react-native-artifacts/#{version}/react-native-artifacts-#{version}-hermes-ios-release.tar.gz"

Pod::Spec.new do |spec|
  spec.name        = "hermes-engine"
  spec.version     = version
  spec.summary     = "Hermes is a small and lightweight JavaScript engine optimized for running React Native."
  spec.description = "Hermes is a JavaScript engine optimized for fast start-up of React Native apps. It features ahead-of-time static optimization and compact bytecode."
  spec.homepage    = "https://hermesengine.dev"
  spec.license     = "MIT"
  spec.author      = "Facebook"
  spec.source      = source
  spec.platforms   = { :osx => "10.13", :ios => "12.4" }

  spec.subspec 'Pre-built' do |ss|
    ss.preserve_paths = ["destroot/bin/*"]
    ss.source_files = "destroot/include/**/*.h"
    ss.exclude_files = ["destroot/include/jsi/jsi/JSIDynamic.{h,cpp}", "destroot/include/jsi/jsi/jsilib-*.{h,cpp}"]
    ss.header_mappings_dir = "destroot/include"
    ss.ios.vendored_frameworks = "destroot/Library/Frameworks/universal/hermes.xcframework"
    ss.osx.vendored_frameworks = "destroot/Library/Frameworks/macosx/hermes.framework"
  end

  spec.xcconfig            = { "CLANG_CXX_LANGUAGE_STANDARD" => "c++17", "CLANG_CXX_LIBRARY" => "compiler-default" }
end
