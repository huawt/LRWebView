
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 图片添加水印
 */
@interface UIImage (WaterMark)

/**
 图片加水印
 */
- (instancetype)addWaterMarkImage:(UIImage *)waterMarkImage;
/**
 图片加水印
 */
- (instancetype)addWaterMarkView:(UIView *)waterMarkView;

@end

NS_ASSUME_NONNULL_END
