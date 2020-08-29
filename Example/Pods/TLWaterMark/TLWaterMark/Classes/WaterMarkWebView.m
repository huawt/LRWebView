
#import "WaterMarkWebView.h"
#import "WaterMarkView.h"

@implementation WaterMarkWebView

- (void)addWebViewWaterMark
{
    for (UIView *subView in self.scrollView.subviews) {
        if ([subView isKindOfClass:[WaterMarkView class]]) {
            return;
        }
    }
    WaterMarkView *markView = [self.scrollView addWaterMark];
    [self addObserver:markView forKeyPath:kWaterMarkWebViewObserverKeyPath options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
}

- (void)dealloc
{
    for (UIView *subView in self.scrollView.subviews) {
        if ([subView isKindOfClass:[WaterMarkView class]]) {
            @try {
                [self removeObserver:subView forKeyPath:kWaterMarkWebViewObserverKeyPath];
            } @catch (NSException *exception) {

            } @finally {

            }
        }
    }
}

@end
