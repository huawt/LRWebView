
#import "LRWebView.h"

/**
 为 LRWebView 添加网页中图片长按手势
 */
@interface LRWebView (LongPress)<UIGestureRecognizerDelegate>

/**
 添加长按手势 - 返回图片的url
 */
- (void)addGestureRecognizerObserverWebElements:(void(^)(NSString *imageUrl))event;

@end
