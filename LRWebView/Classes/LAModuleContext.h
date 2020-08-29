
#import <Foundation/Foundation.h>
#import "LAWebView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LAModuleContext : NSObject

@property (nonatomic, weak) LAWebView *webView;
@property (nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
