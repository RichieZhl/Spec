#
# Be sure to run `pod lib lint WebViewJsBridge.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WebViewJsBridge'
  s.version          = '0.1.0'
  s.summary          = 'webview js bridge'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/RichieZhl/WebViewJsBridge'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'richiezhl' => 'lylaut@163.com' }
  s.source           = { :git => 'https://github.com/RichieZhl/WebViewJsBridge.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'WebViewJsBridge/Classes/**/*'
  
  s.frameworks = 'WebKit'
end
