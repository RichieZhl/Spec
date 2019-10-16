# Copyright (c) Facebook, Inc. and its affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

Pod::Spec.new do |spec|
  spec.name = 'Folly'
  spec.version = '2018.10.22.00'
  spec.license = { :type => 'Apache License, Version 2.0' }
  spec.homepage = 'https://github.com/facebook/folly'
  spec.summary = 'An open-source C++ library developed and used at Facebook.'
  spec.authors = 'Facebook'
  spec.source = { :git => 'https://github.com/facebook/folly.git',
                  :tag => "v#{spec.version}" }
  spec.module_name = 'folly'
  spec.dependency 'boost-for-react-native'
  spec.dependency 'DoubleConversion'
  spec.dependency 'glog'
  spec.compiler_flags = '-DFOLLY_HAVE_PTHREAD=1 -DFOLLY_NO_CONFIG -DFOLLY_MOBILE=1 -DFOLLY_USE_LIBCPP=1 -DFOLLY_HAVE_LIBGFLAGS=0 -DFOLLY_HAVE_LIBJEMALLOC=0 -DFOLLY_HAVE_PREADV=0 -DFOLLY_HAVE_PWRITEV=0 -DFOLLY_HAVE_TFO=0 -DFOLLY_USE_SYMBOLIZER=0  -frtti
    -fexceptions
    -std=c++14
    -Wno-error
    -Wno-unused-local-typedefs
    -Wno-unused-variable
    -Wno-sign-compare
    -Wno-comment
    -Wno-return-type
    -Wno-global-constructors'
  spec.source_files = 'folly/Executor.cpp',
                      'folly/memory/detail/MallocImpl.cpp',
                      'folly/String.cpp',
                      'folly/*.cpp',
                      'folly/detail/*.cpp',
                      'folly/hash/*.cpp',
                      'folly/portability/*.cpp',
                      'folly/ScopeGuard.h',
                      'folly/lang/ColdClass.cpp',
                      'folly/lang/Assume.h',
                      'folly/lang/Assume.cpp',
                      'folly/io/async/*.cpp',
                      'folly/io/async/ssl/*.cpp',
                      'folly/io/*.cpp',
                      'folly/synchronization/*.cpp',
                      'folly/lang/*.cpp',
                      'folly/memory/*.cpp',
                      'folly/futures/*.cpp',
                      'folly/futures/detail/*.cpp',
                      'folly/experimental/hazptr/*.cpp',
                      'folly/executors/*.cpp',
                      'folly/concurrency/*.cpp',
                      'folly/ssl/*.cpp',
                      'folly/ssl/detail/*.cpp',
                      'folly/system/*.cpp'

  # workaround for https://github.com/facebook/react-native/issues/14326
  spec.preserve_paths = 'folly/*.h',
                        'folly/portability/*.h',
                        'folly/lang/*.h',
                        'folly/functional/*.h',
                        'folly/detail/*.h',
                        'folly/hash/*.h',
                        'folly/memory/*.h',
                        'folly/**/*.h',
                        'folly/futures/detail/*.h',
                        'folly/futures/*.h'

  spec.header_mappings_dir = 'folly'
  spec.header_dir = 'folly'
  spec.libraries           = "stdc++"
  spec.private_header_files = 'folly/portability/Stdlib.h',
                              'folly/portability/Stdio.h'

  spec.public_header_files = 'folly/portability/Config.h',
                              'folly/Executor.h',
                              'folly/Function.h',
                              'folly/Utility.h',
                              'folly/Portability.h',
                              'folly/Traits.h',
                              'folly/functional/Invoke.h',
                              'folly/CPortability.h',
                              'folly/dynamic.h',
                              'folly/json_pointer.h',
                              'folly/Expected.h',
                              'folly/Preprocessor.h',
                              'folly/Optional.h',
                              'folly/Unit.h',
                              'folly/Utility.h',
                              'folly/lang/ColdClass.h',
                              'folly/CppAttributes.h',
                              'folly/json.h',
                              'folly/Range.h',
                              'folly/hash/SpookyHashV2.h',
                              'folly/lang/Exception.h',
                              'folly/portability/Constexpr.h',
                              'folly/CpuId.h',
                              'folly/Likely.h',
                              'folly/detail/RangeCommon.h',
                              'folly/detail/RangeSse42.h',
                              'folly/portability/String.h',
                              'folly/dynamic-inl.h',
                              'folly/Conv.h',
                              'folly/Demangle.h',
                              'folly/FBString.h',
                              'folly/hash/Hash.h',
                              'folly/memory/Malloc.h',
                              'folly/io/async/AsyncTimeout.h',
                              'folly/**/*.h',
                              'folly/memory/detail/MallocImpl.h',
                              'folly/String.h',
                              'folly/*.h',
                              'folly/portability/PThread.h',
                              'folly/futures/*.h',
                              'folly/futures/detail/*.h'
                              
  spec.libraries           = "stdc++"
  spec.pod_target_xcconfig = { "USE_HEADERMAP" => "NO",
                               "CLANG_CXX_LANGUAGE_STANDARD" => "c++14",
                               "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)\" \"$(PODS_ROOT)/boost-for-react-native\" \"$(PODS_ROOT)/DoubleConversion\"" }

  spec.default_subspec = 'Default'

  spec.subspec 'Default' do
    # no-op
  end

  spec.subspec 'Fabric' do |fabric|
    fabric.source_files = 'folly/portability/SysUio.cpp',
                          'folly/FileUtil.cpp',
                          'folly/SharedMutex.cpp',
                          'folly/concurrency/CacheLocality.cpp',
                          'folly/detail/Futex.cpp',
                          'folly/lang/SafeAssert.cpp',
                          'folly/synchronization/ParkingLot.cpp',
                          'folly/portability/Malloc.cpp'
    fabric.preserve_paths = 'folly/concurrency/CacheLocality.h',
                            'folly/synchronization/ParkingLot.h',
                            'folly/synchronization/SanitizeThread.h',
                            'folly/system/ThreadId.h'
  end

  # Pinning to the same version as React.podspec.
  spec.platforms = { :ios => "9.0", :tvos => "9.2" }
end
