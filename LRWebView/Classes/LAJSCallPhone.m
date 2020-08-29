
#import "LAJSCallPhone.h"

@implementation LAJSCallPhone

+ (void)callPhoneWithPhoneNumber:(NSString *)phoneNumber completeBlock:(void (^) (BOOL))completeBlock {
    if (![phoneNumber isKindOfClass:[NSString class]] || phoneNumber.length == 0) {
        if (completeBlock) {
            completeBlock(NO);
        }
        return;
    }
    NSMutableString *phoneStr = [[NSMutableString alloc] initWithFormat:@"tel://%@", phoneNumber];
    BOOL success = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
    if (completeBlock) {
        completeBlock(success);
    }
}

@end
