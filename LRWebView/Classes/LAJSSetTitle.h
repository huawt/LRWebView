
#import <Foundation/Foundation.h>

@interface LAJSSetTitle : NSObject

+(void)setTitle:(NSString *)title on:(UIView *)view completeBlock:(void (^) (BOOL success))completeBlock;

@end
