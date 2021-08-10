require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name              = 'react-native-svg'
  s.version           = package['version']
  s.summary           = package['description']
  s.license           = package['license']
  s.homepage          = package['homepage']
  s.authors           = 'Horcrux Chen'
  s.platforms         = { :ios => "10.0" }
  s.source            = { :git => 'https://github.com/RichieZhl/react-native-svg.git', :tag => "v#{s.version}" }
  s.source_files      = 'apple/**/*.{h,m,mm}'
  s.ios.exclude_files = '**/*.macos.{h,m,mm}'
  s.requires_arc      = true
  s.dependency          'React'
end
