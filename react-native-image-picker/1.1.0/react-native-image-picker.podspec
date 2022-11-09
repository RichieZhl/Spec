Pod::Spec.new do |s|
  s.name         = "react-native-image-picker"
  s.version      = "1.1.0"
  s.license      = "MIT"
  s.homepage     = "https://github.com/marcshilling/react-native-image-picker"
  s.authors      = { 'Marc Shilling' => 'marcshilling@gmail.com' }
  s.summary      = "A React Native module that allows you to use the native UIImagePickerController UI to select a photo from the device library or directly from the camera"
  s.source       = { :git => "https://github.com/RichieZhl/react-native-image-picker.git", :tag => s.version.to_s }
  s.source_files  = "ios/*.{h,m,mm}"

  s.libraries = "stdc++"
  
  s.platform     = :ios, "8.0"
  s.ios.framework = 'MobileCoreServices'
  s.dependency 'React'
end
