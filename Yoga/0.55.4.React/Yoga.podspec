Pod::Spec.new do |spec|
  spec.name = 'Yoga'
  spec.version = '0.55.4.React'
  spec.license =  { :type => 'MIT', :file => "LICENSE" }
  spec.homepage = 'https://yogalayout.com/'
  spec.documentation_url = 'https://yogalayout.com/docs'

  spec.summary = 'Yoga is a cross-platform layout engine which implements Flexbox.'
  spec.description = 'Yoga is a cross-platform layout engine enabling maximum collaboration within your team by implementing an API many designers are familiar with, and opening it up to developers across different platforms.'

  spec.authors = 'Facebook'
  spec.source = {
    :git => 'https://github.com/RichieZhl/yoga',
    :tag => spec.version.to_s,
  }
  spec.platforms = { :ios => "8.0", :tvos => "10.0" }
  spec.module_name = 'yoga'
  spec.requires_arc = false
  spec.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES'
  }
  spec.compiler_flags = [
      '-fno-omit-frame-pointer',
      '-fexceptions',
      '-Wall',
      '-Werror',
      '-std=c++1y',
      '-fPIC'
  ]
  spec.source_files = 'yoga/**/*.{c,h,cpp}'
  spec.public_header_files = 'yoga/{Yoga,YGEnums,YGMacros}.h'

end
