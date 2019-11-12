
#import <KKJSBridge/KKJSBridge.h>

NS_ASSUME_NONNULL_BEGIN


@protocol LRWebViewDelegate <WKUIDelegate>

//// webView 中的提示弹窗
//- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler;
//
//// webView 中的确认弹窗
//- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler;
//
//// webView 中的输入框
//- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler;

@end

@interface LRWebView : KKWebView

@property (nonatomic, weak) id<LRWebViewDelegate>lrDelegate;

@property (nonatomic, assign) BOOL longpressEnable;

@end

NS_ASSUME_NONNULL_END
