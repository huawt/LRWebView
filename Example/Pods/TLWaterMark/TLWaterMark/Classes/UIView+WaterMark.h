
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class WaterMarkView;

/**
 给 View 添加水印
 */
@interface UIView (WaterMark)

/**
 UIView添加水印 - 默认两列 -- 禁止非水印子类调用
 */
- (WaterMarkView *)addWaterMark;

@end

NS_ASSUME_NONNULL_END
