
#import "LAJSSetTitle.h"
#import "LAPPWKView.h"

@implementation LAJSSetTitle

+ (void)setTitle:(NSString *)title on:(UIView *)view completeBlock:(void (^)(BOOL))completeBlock {
    if (!title.length || !view) {
        if (completeBlock) {
            completeBlock(NO);
            return;
        }
    }
    
    UIView *superview = nil;
    do {
        superview = view.superview;
    } while (superview && ![superview isKindOfClass:[LAPPWKView class]]);
    if ([superview isKindOfClass:[LAPPWKView class]]) {
        if (((LAPPWKView *)superview).viewModel.setTitleHandler) {
            ((LAPPWKView *)superview).viewModel.setTitleHandler(title);
        }
    } else {
        if (completeBlock) {
            completeBlock(NO);
        }
    }
}

@end
