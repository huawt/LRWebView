
#import <Foundation/Foundation.h>

@interface LAJSCreatActionAlert : NSObject

/**
 显示弹框

 @param title 标题
 @param content 信息
 @param confirmText 是否需要确定操作
 @param completeBlock if comfirm == YES ,点击确定 回传YES , 点击取消回传NO   else 点击确定 回传NO
 */
+ (void)creatActionAlertWithTitle:(NSString *)title content:(NSString *)content confirmText:(NSString *)confirmText showCancel:(BOOL)showCancel cancelText:(NSString *)cancelText completeBlock:(void (^) (BOOL success, BOOL confirm))completeBlock;

@end
