
Pod::Spec.new do |s|
  s.name             = 'LRWebView'
  s.version          = '1.0.0'
  s.summary          = 'LRWebView. dependency KKJSBridge'
  s.homepage         = 'https://github.com/huawt/LRWebView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'huawt' => 'ghost263sky@163.com' }
  s.source           = { :git => 'https://github.com/huawt/LRWebView.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'LRWebView/Classes/**/*'
  s.frameworks = 'UIKit', 'WebKit'
  s.dependency 'KKJSBridge'
end
