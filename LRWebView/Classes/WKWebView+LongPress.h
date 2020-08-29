
#import "LAWebView.h"

/**
 为 BaseWKWebView 添加网页中图片长按手势
 */
@interface LAWebView (LongPress)<UIGestureRecognizerDelegate>

/**
 添加长按手势 - 返回图片的url
 */
- (void)addGestureRecognizerObserverWebElements:(void(^)(NSString *imageUrl))event;

@end
