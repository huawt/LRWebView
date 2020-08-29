
#import <Foundation/Foundation.h>

@interface LAJSActionSheetMenu: NSObject

@property (nonatomic, copy, readonly) NSString *text;
@property (nonatomic, assign, readonly) UIAlertActionStyle style;

- (instancetype)initWithText:(NSString *)text style:(UIAlertActionStyle)style;

@end

@interface LAJSCreatActionSheet : NSObject

/**
  创建action sheet

 @param menus 标题数组
 @param completeBlock 回传 selectIndex
 */
+ (void)creatActionSheetWithTitle:(NSString *)title content:(NSString *)content menus:(NSArray<LAJSActionSheetMenu *> *)menus completeBlock:(void (^) (BOOL success, NSInteger selectedIndex))completeBlock;

@end
