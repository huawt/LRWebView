
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#if __has_include(<LRWebView/LAPPWKKit.h>)

FOUNDATION_EXPORT double LAPPWKKitVersionNumber;
FOUNDATION_EXPORT const unsigned char LAPPWKKitVersionString[];

#import <LRWebView/LAWebView.h>
#import <LRWebView/WKWebView+LongPress.h>
#import <LRWebView/LAPPWKDefine.h>
#import <LRWebView/LAPPWKViewModel.h>
#import <LRWebView/LAPPWKEngine.h>
#import <LRWebView/LAPPWKView.h>
#import <LRWebView/LAPPModules.h>
#import <LRWebView/LAModuleContext.h>

#else
#import "LAWebView.h"
#import "WKWebView+LongPress.h"
#import "LAPPWKDefine.h"
#import "LAPPWKEngine.h"
#import "LAPPWKView.h"
#import "LAPPModules.h"
#import "LAPPWKViewModel.h"
#import "LAModuleContext.h"

#endif
