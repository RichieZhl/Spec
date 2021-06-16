require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name           = 'react-native-camera'
  s.version        = package['version']
  s.summary        = package['description']
  s.description    = package['description']
  s.license        = package['license']
  s.author         = package['author']
  s.homepage       = package['homepage']
  s.source         = { :git => 'https://github.com/RichieZhl/react-native-camera.git', :tag => s.version }

  s.requires_arc   = true
  s.platform       = :ios, '9.0'

  s.subspec "RCT" do |ss|
    ss.source_files = "ios/RCT/**/*.{h,m,mm}"
  end

  s.subspec "RN" do |ss|
    ss.source_files = "ios/RN/**/*.{h,m,mm}"
  end

  s.subspec "TextDetector" do |ss|
    ss.dependency 'react-native-camera/RN'
    ss.dependency 'react-native-camera/RCT'
    ss.dependency 'Firebase/MLVision'
    ss.dependency 'Firebase/MLVisionTextModel'
  end

  s.subspec "FaceDetectorMLKit" do |ss|
    ss.dependency 'react-native-camera/RN'
    ss.dependency 'react-native-camera/RCT'
    ss.dependency 'Firebase/MLVision'
    ss.dependency 'Firebase/MLVisionFaceModel'
  end
  
  s.subspec "BarcodeDetectorMLKit" do |ss|
    ss.dependency 'react-native-camera/RN'
    ss.dependency 'react-native-camera/RCT'
    ss.dependency 'Firebase/MLVision'
    ss.dependency 'Firebase/MLVisionBarcodeModel'
  end

  s.default_subspecs = "RN", "RCT"

  s.preserve_paths = 'LICENSE', 'README.md', 'package.json', 'index.js'

  s.dependency 'React'
end
