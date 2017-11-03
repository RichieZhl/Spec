require 'json'
version = JSON.parse(File.read('package.json'))["version"]

Pod::Spec.new do |s|

s.name           = "react-native-smart-barcode"
s.version        = version
s.summary        = "Customizable Icons for React Native with support for NavBar/TabBar, image source and full styling."
s.homepage       = "https://github.com/react-native-component/react-native-smart-barcode"
s.license        = "MIT"
s.author         = { "Joel Arvidsson" => "joel@oblador.se" }
s.platform       = :ios, "7.0"
s.source         = { :git => "https://github.com/RichieZhl/react-native-smart-barcode.git", :tag => "v#{s.version}" }
s.source_files   = 'ios/RCTBarcode/**/*.{h,m}'
s.exclude_files = "ios/RCTBarcode/**/ScannerRect.*"                                       
s.resources      = "ios/raw/*.wav"
s.preserve_paths = "**/*.js"
s.dependency 'React'

end
