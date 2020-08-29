
#import "LAPPWKEngine.h"
#import "LAPPModules.h"
#import "LAPPWKView.h"
#import "LAPPWKDefine.h"
#import <TLToastHUD/TLToastHUD.h>
#import <objc/runtime.h>
#import "LAModuleContext.h"

@interface LAPPWKEngine ()

@end

@implementation LAPPWKEngine


+ (nonnull NSString *)moduleName {
    return @"default";
}

+ (BOOL)isSingleton
{
    return YES;
}

- (instancetype)initWithEngine:(KKJSBridgeEngine *)engine context:(id)context
{
    if (self = [super init]) {
        _context = context;
    }
    return self;
}


- (LAPPWKView *)getLAPPWKView {
    return  (LAPPWKView *)self.context.webView.superview;
}

- (void)appCopyString:(KKJSBridgeEngine *)engine params:(NSDictionary *)params responseCallback:(void (^)(NSDictionary *))responseCallback{
    NSString *content = [params objectForKey:@"content"];
    [UIPasteboard generalPasteboard].string = content;
    [TLToast showToast:@"复制成功" duration:1 completion:nil];
}

- (void)allowWebBackForwardGesture:(KKJSBridgeEngine *)engine params:(NSDictionary *)params responseCallback:(void (^)(NSDictionary *))responseCallback
{
    if ([self getLAPPWKView].viewModel.wkAllowBackForwardGesture) {
        [self getLAPPWKView].viewModel.wkAllowBackForwardGesture([[params objectForKey:@"allow"] boolValue]);
    }
}

- (void)showLoading:(KKJSBridgeEngine *)engine params:(NSDictionary *)params responseCallback:(void (^)(NSDictionary *))responseCallback
{
    NSString *titleString = [params objectForKey:@"title"];
    titleString = titleString.length ? titleString : @"Loading";
    NSNumber *durationNumber = [params objectForKey:@"duration"];
    double duration = durationNumber.doubleValue;
    dispatch_async(dispatch_get_main_queue(), ^{
        [TLProcessHUD showWithStatus:titleString on:self.context.webView.superview autoDismissDelay:duration completion:^(BOOL success) {
            responseCallback(@{@"success": @(success)});
        }];
    });
}

- (void)hideLoading:(KKJSBridgeEngine *)engine params:(NSDictionary *)params responseCallback:(void (^)(NSDictionary *))responseCallback
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [TLProcessHUD dismissOn:self.context.webView.superview];
    });
}

- (void)showToast:(KKJSBridgeEngine *)engine params:(NSDictionary *)params responseCallback:(void (^)(NSDictionary *))responseCallback
{
    NSString *content = [params objectForKey:@"content"];
    NSNumber *durationNum = [params objectForKey:@"duration"];
    double duration = durationNum.doubleValue;
    dispatch_async(dispatch_get_main_queue(), ^{
        [TLToast showToast:content duration:duration completion:^(BOOL success) {
            responseCallback(@{@"success": @(success)});
        }];
    });
}



- (void)callPhone:(KKJSBridgeEngine *)engine params:(NSDictionary *)params responseCallback:(void (^)(NSDictionary *))responseCallback
{
    NSString *number = [NSString stringWithFormat:@"%@", [params objectForKey:@"number"]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [LAJSCallPhone callPhoneWithPhoneNumber:number completeBlock:^(BOOL success) {
            responseCallback(@{@"success": @(success)});
        }];
    });
}

- (void)showModal:(KKJSBridgeEngine *)engine params:(NSDictionary *)params responseCallback:(void (^)(NSDictionary *))responseCallback
{
    NSString *title = [params objectForKey:@"title"];
    NSString *content = [params objectForKey:@"content"];
    NSString *confirmText = [params objectForKey:@"confirmText"];
    NSNumber *showCancelBoolNum = [params objectForKey:@"showCancel"];
    NSString *cancelText = [params objectForKey:@"cancelText"];
    
    if (!title.length && !content.length) {
        responseCallback(@{@"success": @NO});
        return;
    }
    
    confirmText = confirmText.length ? confirmText :@"确定";
    BOOL showCancel = showCancelBoolNum.boolValue;
    cancelText = cancelText.length ? cancelText : @"取消";
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [LAJSCreatActionAlert creatActionAlertWithTitle:title content:content confirmText:confirmText showCancel:showCancel cancelText:cancelText completeBlock:^(BOOL success, BOOL confirm) {
            if (success) {
                NSDictionary *result = @{@"confirm" : @(confirm), @"cancel" : @((BOOL)!confirm)};
                responseCallback(result);
            } else {
                responseCallback(@{@"success": @NO});
            }
        }];
    });
}

- (void)showActionSheet:(KKJSBridgeEngine *)engine params:(NSDictionary *)params responseCallback:(void (^)(NSDictionary *))responseCallback
{
    NSString *titleValue = [params objectForKey:@"title"];
    NSString *contentValue = [params objectForKey:@"content"];
    NSArray *menusValue = [params objectForKey:@"menus"];
    NSString *title = titleValue.length == 0 ? nil : titleValue;
    NSString *content = contentValue.length == 0 ? nil : contentValue;
    NSArray<NSDictionary *> *menusInfo = menusValue.count == 0 ? nil : menusValue;
    NSMutableArray<LAJSActionSheetMenu *> *menus = [NSMutableArray array];
    [menusInfo enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id textValue = obj[@"text"];
        id styleValue = obj[@"style"];
        NSString *text = [textValue isKindOfClass:[NSString class]] ? textValue : nil;
        NSString *styleString = [styleValue isKindOfClass:[NSString class]] ? styleValue : nil;
        UIAlertActionStyle style = UIAlertActionStyleDefault;
        if ([styleString isEqualToString:@"cancel"]) {
            style = UIAlertActionStyleCancel;
        } else if ([styleString isEqualToString:@"destructive"]) {
            style = UIAlertActionStyleDestructive;
        }
        LAJSActionSheetMenu *menu = [[LAJSActionSheetMenu alloc] initWithText:text style:style];
        [menus addObject:menu];
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        [LAJSCreatActionSheet creatActionSheetWithTitle:title content:content menus:menus completeBlock:^(BOOL success, NSInteger selectedIndex) {
            if (success) {
                NSDictionary *result = @{@"selectIndex" : @(selectedIndex)};
                responseCallback(result);
            } else {
                responseCallback(@{@"success": @NO});
            }
        }];
    });
}

- (void)getInfo:(KKJSBridgeEngine *)engine params:(NSDictionary *)params responseCallback:(void (^)(NSDictionary *))responseCallback
{
    [LAJSGetDeviceMessage getDeviceMessageCompleteBlock:^(NSDictionary *deviceInfo) {
        NSString *SDKVersion = deviceInfo[@"SDKVersion"];
        NSString *model = deviceInfo[@"model"];
        NSString *platform = deviceInfo[@"platform"];
        NSString *systemVersion = deviceInfo[@"systemVersion"];
        NSString *appVersion = deviceInfo[@"appVersion"];
        if (![SDKVersion isKindOfClass:[NSString class]]) {
            SDKVersion = @"";
        }
        if (![model isKindOfClass:[NSString class]]) {
            model = @"";
        }
        if (![platform isKindOfClass:[NSString class]]) {
            platform = @"";
        }
        if (![systemVersion isKindOfClass:[NSString class]]) {
            systemVersion = @"";
        }
        if (![appVersion isKindOfClass:[NSString class]]) {
            appVersion = @"";
        }
        NSDictionary *result = @{@"SDKVersion" : SDKVersion, @"model" : model, @"platform" : platform, @"systemVersion" : systemVersion, @"appVersion" : appVersion};
        responseCallback(result);
    }];
}

- (void)setTitle:(KKJSBridgeEngine *)engine params:(NSDictionary *)params responseCallback:(void (^)(NSDictionary *))responseCallback
{
    NSString *title = [params objectForKey:@"title"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [LAJSSetTitle setTitle:title on:self.context.webView completeBlock:^(BOOL success) {
            responseCallback(@{@"success": @(success)});
        }];
    });
}

- (void)exit:(KKJSBridgeEngine *)engine params:(NSDictionary *)params responseCallback:(void (^)(NSDictionary *))responseCallback
{
    if ([self getLAPPWKView].viewModel.exitHandler) {
        [self getLAPPWKView].viewModel.exitHandler();
    }
}

- (void)showWaterMark:(KKJSBridgeEngine *)engine params:(NSDictionary *)params responseCallback:(void (^)(NSDictionary *))responseCallback
{
    if ([self getLAPPWKView].viewModel.showWaterMark) {
        [self getLAPPWKView].viewModel.showWaterMark();
    }
}
- (void)openWebUrl:(KKJSBridgeEngine *)engine params:(NSDictionary *)params responseCallback:(void (^)(NSDictionary *))responseCallback
{
    if ([self getLAPPWKView].viewModel.openWebUrl) {
        [self getLAPPWKView].viewModel.openWebUrl([params objectForKey:@"url"]);
    }
}

- (NSString *)canIUse:(NSString *)functionName
{
    Protocol *lappWKProtocal = @protocol(LAPPWKProtocol);
    return [self judgeWithProtocol:lappWKProtocal funcName:functionName];
}

- (NSString *)judgeWithProtocol:(Protocol *)protocol funcName:(NSString *)functionName
{
    BOOL can = NO;
    unsigned int methodCount = 0;
    struct objc_method_description *methodDescriptions = protocol_copyMethodDescriptionList(protocol, YES, YES, &methodCount);
    for (unsigned int i = 0; i < methodCount; i++) {
        struct objc_method_description methodDescription = methodDescriptions[i];
        SEL selector = methodDescription.name;
        NSString *selectorName = [NSString stringWithCString:sel_getName(selector) encoding:NSUTF8StringEncoding];
        NSRange colonRange = [selectorName rangeOfString:@":"];
        while (colonRange.location != NSNotFound) {
            NSString *beforeString = [selectorName substringToIndex:colonRange.location];
            NSString *afterSting = [selectorName substringFromIndex:colonRange.location + colonRange.length];
            if (afterSting.length && ![afterSting hasPrefix:@":"]) {
                NSString *afterStringFirstLetter = [afterSting substringToIndex:1];
                NSString *afterStringWithourFirstLetter = [afterSting substringFromIndex:1];
                afterStringFirstLetter = afterStringFirstLetter.uppercaseString;
                afterSting = [NSString stringWithFormat:@"%@%@", afterStringFirstLetter, afterStringWithourFirstLetter];
            }
            selectorName = [NSString stringWithFormat:@"%@%@", beforeString, afterSting];
            colonRange = [selectorName rangeOfString:@":"];
        }
//        selectorName = [selectorName stringByReplacingOccurrencesOfString:@"ResponseCallback" withString:@""];
        if ([selectorName containsString:functionName ]) {
            can = YES;
            break;
        }
    }
    return can ? @"1" : @"";
}

- (BOOL)checkSyncFunc:(WKWebView *)webView prompt:(NSString *)prompt completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    BOOL syncFunc = NO;
    if (prompt.length) {
        NSError *error = nil;
        NSDictionary *args = [NSJSONSerialization JSONObjectWithData:[prompt dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
        if (!error && [args isKindOfClass:[NSDictionary class]]) {
            id typeValue = args[@"type"];
            if ([typeValue isKindOfClass:[NSString class]] && [(NSString *)typeValue isEqualToString:@"SyncFunc"]) {
                syncFunc = YES;
                id nameValue = args[@"name"];
                if ([nameValue isKindOfClass:[NSString class]]) {
                    NSString *name = (NSString *)nameValue;
                    completionHandler([self getSyncFuncResultWithFuncName:name]);
                } else {
                    completionHandler(nil);
                }
            }
        }else{
            completionHandler(nil);
        }
    }
    return syncFunc;
}

- (id)getSyncFuncResultWithFuncName:(NSString *)funcName
{
    if ([funcName hasPrefix:@"canIUse__symbol__"]) {
        NSString *functionName = [funcName componentsSeparatedByString:@"__symbol__"].lastObject;
        return [self canIUse:functionName];
    }
    
    return @"";
}

- (void)customBack:(void (^)(BOOL customBack))backHandler
{
    NSString *jsString = @"App.listenBtnBackClicked()";
    [self.context.webView evaluateJavaScript:jsString completionHandler:^(NSString *result, NSError * _Nullable error) {
        if ([result integerValue]) {
            backHandler(YES);
        }else{
            backHandler(NO);
        }
    }];
}

@end
