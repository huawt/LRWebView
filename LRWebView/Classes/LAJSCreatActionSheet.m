
#import "LAJSCreatActionSheet.h"
#import <LRTools/LRTools.h>

@implementation LAJSActionSheetMenu

- (instancetype)initWithText:(NSString *)text style:(UIAlertActionStyle)style {
    self = [super init];
    if (self) {
        _text = [text copy];
        _style = style;
    }
    return self;
}

@end

@implementation LAJSCreatActionSheet

+ (void)creatActionSheetWithTitle:(NSString *)title content:(NSString *)content menus:(NSArray<LAJSActionSheetMenu *> *)menus completeBlock:(void (^)(BOOL, NSInteger))completeBlock
{
    if (!menus.count) {
        if (completeBlock) {
            completeBlock(NO, 0);
        }
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleActionSheet];
    
    __block BOOL existCancelStyle = NO;
    
    [menus enumerateObjectsUsingBlock:^(LAJSActionSheetMenu * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL add = YES;
        if (obj.style == UIAlertActionStyleCancel) {
            if (!existCancelStyle) {
                existCancelStyle = YES;
            } else {
                add = NO;
            }
        }
        if (add) {
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:obj.text style:obj.style handler:^(UIAlertAction * _Nonnull action) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completeBlock) {
                        completeBlock(YES, idx);
                    }
                });
            }];
            [alertController addAction:alertAction];
        }
    }];
    
    UIViewController *controller = [LRTools getCurrentViewController];
    if (!controller.presentedViewController) {
        [controller presentAlertViewController:alertController];
    }else{
        if (completeBlock) {
            completeBlock(NO, 0);
        }
    }
}

@end
