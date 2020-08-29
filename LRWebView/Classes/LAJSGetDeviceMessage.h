
#import <Foundation/Foundation.h>

@interface LAJSGetDeviceMessage : NSObject

+(void)getDeviceMessageCompleteBlock:(void (^) (NSDictionary *deviceInfo))completeBlock;

@end
