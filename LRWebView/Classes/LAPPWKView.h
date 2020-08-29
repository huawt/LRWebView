

#import <UIKit/UIKit.h>
#import "LAWebView.h"
#import "LAPPWKViewModel.h"
#import "LAPPWKEngine.h"

/**
轻应用View
*/
@interface LAPPWKView : UIView

/**
viewModel
*/
@property (nonatomic, strong) LAPPWKViewModel *viewModel;

/**
主 View
*/
@property (nonatomic, strong, readonly) LAWebView *webView;

/**
进度条
*/
@property (nonatomic, strong) UIProgressView *progress;

/**
引擎
*/
@property (nonatomic, strong, readonly) LAPPWKEngine *engine;

/**
JSBridge引擎
*/
@property (nonatomic, strong, readonly) KKJSBridgeEngine *jsBridgeEngine;

/**
 添加手势后,赋值
 */
@property (nonatomic, assign) BOOL longpress;

/**
禁止附带的loading框, 默认为NO
*/
@property (nonatomic, assign) BOOL disableLoading;

/**
 初始化
 */
- (instancetype)initWithFrame:(CGRect)frame engineClass:(Class)engineClass debugMode:(BOOL)enable;

/**
 配置 Js 文件路径 -- 必须配置
 */
+ (BOOL)configureLAPPJS:(NSString *)JSFilePath;

/**
 控制返回-未支持
 */
- (void)customBack:(void(^)(BOOL customBack))backHander;

/**
 添加图片长按手势
 */
- (void)addImageLongPressGestureRecognizerObserver:(void(^)(NSString *imageUrl))imageHandler;

/**
 删除图片长按手势
 */
- (void)removeImageLongPressGestureRecognizer;

@end
