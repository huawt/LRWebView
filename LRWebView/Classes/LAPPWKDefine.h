
#ifndef LAPPWKDefine_h
#define LAPPWKDefine_h

#define LAPPWeak(object)  __weak __typeof__(object) weak##_##object = object;
#define LAPPStrong(object) __strong __typeof__(object) object = weak##_##object;


static inline BOOL kLRIsIPhoneX() {
    if (@available(iOS 11.0, *)) {
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        if (window.safeAreaInsets.left > 0 || window.safeAreaInsets.bottom > 0) {
            return YES;
        }else{
            return NO;
        }
    } else {
        return NO;
    }
}

#define kStatusBarHeight (kLRIsIPhoneX() ? (20.0 + 24) : (20.0))
#define kNavigationBarHeight (44.0)
#define kTabBarHeight (kLRIsIPhoneX() ? (49.0 + 34) : (49.0))
#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define kDeviceHeight [UIScreen mainScreen].bounds.size.height

#endif /* LAPPWKDefine_h */
