
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#if __has_include(<LAPPWKKit/LAPPWKKit.h>)

FOUNDATION_EXPORT double LAPPWKKitVersionNumber;
FOUNDATION_EXPORT const unsigned char LAPPWKKitVersionString[];

#import <LAPPWKKit/LAWebView.h>
#import <LAPPWKKit/WKWebView+LongPress.h>
#import <LAPPWKKit/LAPPWKDefine.h>
#import <LAPPWKKit/LAPPWKViewModel.h>
#import <LAPPWKKit/LAPPWKEngine.h>
#import <LAPPWKKit/LAPPWKView.h>
#import <LAPPWKKit/LAPPModules.h>
#import <LAPPWKKit/LAModuleContext.h>

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
