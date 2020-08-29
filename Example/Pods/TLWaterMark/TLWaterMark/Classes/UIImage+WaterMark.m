
#import "UIImage+WaterMark.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation UIImage (WaterMark)

- (instancetype)addWaterMarkImage:(UIImage *)waterMarkImage
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 1.0);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    [waterMarkImage drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    UIImage * markedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return markedImage;
}

- (instancetype)addWaterMarkView:(UIView *)waterMarkView
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 1.0);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    [waterMarkView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * markedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return markedImage;
}


@end
