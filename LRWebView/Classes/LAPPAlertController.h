
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSInteger, LAPPAlertType) {
    AlertType_AlertPanelType = 1,
    AlertType_ConfirmPanelType = 1 << 1,
    AlertType_TextinputPanelType = 1 << 2,
};

/**
 轻应用弹框
 */
@interface LAPPAlertController : UIAlertController

@property (nonatomic, assign, readonly) LAPPAlertType alertType;
@property (nonatomic, copy) dispatch_block_t alertHander;
@property (nonatomic, copy) void (^confirmHandler)(BOOL confirmHandler);
@property (nonatomic, copy) void (^textinputHandler)(NSString *text);

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle alertType:(LAPPAlertType)alertType;

@end

NS_ASSUME_NONNULL_END
