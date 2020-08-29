
#import <Foundation/Foundation.h>

@interface LAJSCallPhone : NSObject

+(void)callPhoneWithPhoneNumber:(NSString *)phoneNumber completeBlock:(void (^) (BOOL))completeBlock;

@end
