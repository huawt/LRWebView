
#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface LAPPWKViewModel : NSObject

@property (nonatomic, copy) void(^wkWebViewDidStartProvisionalHandler)(WKWebView *webView, WKNavigation *navigation);
@property (nonatomic, copy) void(^wkWebViewDecidePolicyHandler)(WKWebView *webView, WKNavigationAction *navigationAction, void (^decisionHandler)(WKNavigationActionPolicy));
@property (nonatomic, copy) void(^wkWebViewDidFinishHandler)(WKWebView *webView, WKNavigation *navigation);
@property (nonatomic, copy) void(^wkWebViewDidFailHandler)(WKWebView *webView, WKNavigation *navigation, NSError *error);
@property (nonatomic, copy) void(^setTitleHandler)(NSString *title);
@property (nonatomic, copy) void(^exitHandler)(void);
@property (nonatomic, copy) void(^securityVerifyResult)(NSString *code);
@property (nonatomic, copy) void(^showWaterMark)(void);
@property (nonatomic, copy) void(^openWebUrl)(NSString *url);
@property (nonatomic, copy) void(^wkAllowBackForwardGesture)(BOOL allow);

//图片回调
@property (nonatomic, copy) void(^webImgClicked)(NSInteger index,NSArray *imgArr);

@end
