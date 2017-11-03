Pod::Spec.new do |s|
  s.name             = 'react-native-image-crop-picker'
  s.version          = '0.1.0'
  s.summary          = 'react-native-image-crop-picker copy'

  s.description      = <<-DESC
a copy of https://github.com/ivpusic/react-native-image-crop-picker
                       DESC

  s.homepage         = 'https://github.com/ivpusic/react-native-image-crop-picker'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'RichieZhl' => 'lylaut@163.com' }
  s.source           = { :git => 'https://github.com/RichieZhl/react-native-image-crop-picker.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'react-native-image-crop-picker/Classes/*.{h,m}'
  s.public_header_files = 'react-native-image-crop-picker/Classes/{ImageCropPicker,Compression}.h'
  s.dependency 'RSKImageCropper'
  s.dependency 'QBImagePickerController'
end
