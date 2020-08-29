

#import "KKWebView.h"

NS_ASSUME_NONNULL_BEGIN


@protocol LAWebViewDelegate <WKUIDelegate>

//// webView 中的提示弹窗
//- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler;
//
//// webView 中的确认弹窗
//- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler;
//
//// webView 中的输入框
//- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler;

@end

/// 轻应用的WebView
@interface LAWebView : KKWebView


/// 重写 KKWebView 部分 WKUIDelegate
@property (nonatomic, weak) id<LAWebViewDelegate>LADelegate;


/**
长按手势状态，如果添加了手势，长按识别后需置为 yes，处理完后请自便
*/
@property (nonatomic, assign) BOOL longpressEnable;

@end

NS_ASSUME_NONNULL_END
