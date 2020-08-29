
Pod::Spec.new do |s|
  s.name             = 'LRWebView'
  s.version          = '1.0.3'
  s.summary          = 'LRWebView. dependency KKJSBridge'
  s.homepage         = 'https://github.com/huawt/LRWebView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'huawt' => 'ghost263sky@163.com' }
  s.source           = { :git => 'https://github.com/huawt/LRWebView.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
    s.ios.deployment_target = '8.0'

  s.source_files = 'LRWebView/Classes/**/*'
  s.resource = 'LRWebView/Lapp.bundle'
  
  s.frameworks = 'UIKit', 'Foundation', 'WebKit', 'CoreLocation', 'CoreGraphics', 'MobileCoreServices', 'AssetsLibrary', 'Photos', 'QuartzCore', 'AVFoundation'
  s.dependency 'Masonry'
  s.dependency 'TLToastHUD'
  s.dependency 'KKJSBridge'
  s.dependency 'TLWaterMark'
  s.dependency 'LRTools'
  
end
