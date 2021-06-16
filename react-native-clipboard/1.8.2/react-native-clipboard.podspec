
Pod::Spec.new do |s|
    s.name             = "react-native-clipboard"
    s.version          = '1.8.2'
    s.summary          = 'React Native Clipboard API for macOS, iOS, Android, and Windows'
    s.license          = 'MIT'
  
    s.authors          = 'M.Haris Baig <harisbaig100@gmail.com>'
    s.homepage         = 'https://github.com/react-native-clipboard/clipboard'
    s.platforms        = { :ios => "9.0", :osx => "10.14" }
  
    s.source           = { :git => "https://github.com/RichieZhl/clipboard.git", :tag => "v#{s.version}" }
    s.ios.source_files = "ios/**/*.{h,m,mm}"
    s.osx.source_files = "macos/**/*.{h,m,mm}"
  
    s.dependency 'React'
  end
  