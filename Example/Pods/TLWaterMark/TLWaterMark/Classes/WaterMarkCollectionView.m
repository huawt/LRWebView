
#import "WaterMarkCollectionView.h"
#import "WaterMarkView.h"

@implementation WaterMarkCollectionView

- (void)addScrollViewWaterMark
{
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[WaterMarkView class]]) {
            return;
        }
    }
    WaterMarkView *markView = [self addWaterMark];
    [self addObserver:markView forKeyPath:kWaterMarkScrollViewObserverKeyPath options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
}

- (void)dealloc
{
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[WaterMarkView class]]) {
            @try {
                [self removeObserver:subView forKeyPath:kWaterMarkScrollViewObserverKeyPath];
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
        }
    }
}

@end
