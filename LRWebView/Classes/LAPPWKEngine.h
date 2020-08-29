

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LAWebView.h"
#import "LAPPWKProtocol.h"
#import <KKJSBridge/KKJSBridge.h>
#import "LAModuleContext.h"

@class LAPPWKView;

@interface LAPPWKEngine : NSObject<LAPPWKProtocol, KKJSBridgeModule>

@property (nonatomic, strong) LAModuleContext *context;

- (BOOL)checkSyncFunc:(WKWebView *)webView prompt:(NSString *)prompt completionHandler:(void (^)(NSString *))completionHandler;
- (LAPPWKView *)getLAPPWKView;

//需重写的方法
- (id)getSyncFuncResultWithFuncName:(NSString *)funcName;
- (void)customBack:(void(^)(BOOL customBack))backHandler;
- (NSString *)judgeWithProtocol:(Protocol *)protocol funcName:(NSString *)functionName;

@end
