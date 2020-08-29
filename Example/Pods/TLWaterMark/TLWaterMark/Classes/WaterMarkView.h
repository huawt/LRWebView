
#import <UIKit/UIKit.h>
#import "UIView+WaterMark.h"

extern NSString *const kWaterMarkWebViewObserverKeyPath;
extern NSString *const kWaterMarkScrollViewObserverKeyPath;

/**
 水印列数类型
 */
typedef NS_OPTIONS(NSInteger, WaterMarkViewType) {
    kMarkVIewType_Default = 1, //全屏水印 暂时两列
    kMarkViewType_TwoColumn = 1 << 1, //最多两列水印
    kMarkViewType_Image = 1 << 2, //给图片加水印
};

/**
 水印控制
 */
@interface WaterMarkView : UIView


/**
 配置默认水印
 */
+ (void)configureWaterMark:(NSString *)waterMark;

/**
 默认水印文字
 */
+ (NSString *)defaultWaterMark;

/**
 创建水印View - 默认为两列
 */
- (instancetype)initWithFrame:(CGRect)frame waterMarkString:(NSString *)waterMark markViewType:(WaterMarkViewType)markType;

/**
 给图片添加水印
 */
+ (UIImage *)markImage:(UIImage *)image;

@end

