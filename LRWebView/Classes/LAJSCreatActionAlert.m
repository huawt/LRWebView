
#import "LAJSCreatActionAlert.h"
#import <LRTools/LRTools.h>

@implementation LAJSCreatActionAlert
+ (void)creatActionAlertWithTitle:(NSString *)title content:(NSString *)content confirmText:(NSString *)confirmText showCancel:(BOOL)showCancel cancelText:(NSString *)cancelText completeBlock:(void (^)(BOOL, BOOL))completeBlock
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    
    if (showCancel) {
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:confirmText style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completeBlock) {
                    completeBlock(YES, YES);
                }
            });
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelText style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completeBlock) {
                    completeBlock(YES, NO);
                }
            });
        }];
        
        [alertController addAction:alertAction];
        [alertController addAction:cancelAction];
    }else {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:confirmText style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completeBlock) {
                    completeBlock(YES, YES);
                }
            });
        }];
        [alertController addAction:cancelAction];
    }
    
    UIViewController *controller = [LRTools getCurrentViewController];
    if (!controller.presentedViewController) {
        [controller presentAlertViewController:alertController];
    }else{
        if (completeBlock) {
            completeBlock(NO, NO);
        }
    }
}

@end
