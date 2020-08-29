
#import "LAPPWKView.h"
#import <Masonry/Masonry.h>
#import "LAPPAlertController.h"
#import "LAPPWKDefine.h"
#import <TLToastHUD/TLToastHUD.h>
#import "WKWebView+LongPress.h"
#import <KKJSBridge/KKJSBridge.h>
#import "LAModuleContext.h"
#import <LRTools/LRTools.h>

static NSString *const kWKViewKVOEstimatedProgressPath = @"estimatedProgress";

static NSString *kLAPPKitJSFilePath = @"";

@interface LAPPWKView ()<LAWebViewDelegate, KKWebViewDelegate>

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, assign) BOOL debugMode;
@property (nonatomic, strong) WKUserScript *noneSelectScript;
@property (nonatomic, strong) WKUserScript *AppCore;

/**
主 View
*/
@property (nonatomic, strong, readwrite) LAWebView *webView;

@end

@implementation LAPPWKView

+ (void)load {
    __block id observer = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [self prepareWebView];
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }];
}

+ (void)prepareWebView {
    // 预先缓存一个 webView
    [LAWebView configCustomUAWithType:KKWebViewConfigUATypeAppend UAString:[NSString stringWithFormat:@"Linglu/%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]];
    [[KKWebViewPool sharedInstance] makeWebViewConfiguration:^(WKWebViewConfiguration * _Nonnull configuration) {
        // 必须前置配置，否则会造成属性不生效的问题
        configuration.allowsInlineMediaPlayback = YES;
        configuration.preferences.minimumFontSize = 12;
    }];
    [[KKWebViewPool sharedInstance] enqueueWebViewWithClass:LAWebView.class];
}

- (void)dealloc
{
    NSLog(@"%@ -- dealloc", NSStringFromClass([self class]));

    @try {
        [self.webView stopLoading];
        [self.webView removeObserver:self forKeyPath:kWKViewKVOEstimatedProgressPath];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    [[KKWebViewPool sharedInstance] enqueueWebView:self.webView];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.progress mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(2);
    }];
    
    [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_webView.superview);
    }];
}

+ (BOOL)configureLAPPJS:(NSString *)JSFilePath
{
    kLAPPKitJSFilePath = JSFilePath;
    if ([kLAPPKitJSFilePath length]) {
        return YES;
    }
    return NO;
}

- (instancetype)initWithFrame:(CGRect)frame engineClass:(Class)engineClass debugMode:(BOOL)enable
{
    if (self = [super initWithFrame:frame]) {
        _debugMode = enable;
        [self configSubviewsEngineClass:engineClass];
    }
    return self;
}

- (void)configSubviewsEngineClass:(Class)engineClass
{
    self.webView = [[KKWebViewPool sharedInstance] dequeueWebViewWithClass:LAWebView.class webViewHolder:self];
    self.webView.navigationDelegate = self;
    self.webView.LADelegate = self;
    self.webView.longpressEnable = YES;
    if ([self.webView.scrollView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wunguarded-availability-new"
            self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    #pragma clang diagnostic pop
            self.webView.opaque = NO;
        }
    [self addSubview:self.webView];
    
    _jsBridgeEngine = [KKJSBridgeEngine bridgeForWebView:self.webView];

    [self registerModule:engineClass];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self addSubview:self.progress];
    [self.progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(4);
    }];
    //KVO
    [_webView addObserver:self forKeyPath:kWKViewKVOEstimatedProgressPath options:NSKeyValueObservingOptionNew context:nil];

    if (@available(iOS 11.0, *)) {
        for (UIView* subview in _webView.scrollView.subviews) {
            if ([subview isKindOfClass:NSClassFromString(@"WKContentView")])
            {
                for (UIGestureRecognizer* longPress in subview.gestureRecognizers) {
                    if ([longPress isKindOfClass:UILongPressGestureRecognizer.class]) {
                        [subview removeGestureRecognizer:longPress];
                    }
                }
            }
        }
    } else  if (@available(iOS 8.0, *)) {
        for (UIView* subview in _webView.scrollView.subviews) {
            if ([subview isKindOfClass:NSClassFromString(@"WKContentViewMinusAccessoryView")])
            {
                for (UIGestureRecognizer* longPress in subview.gestureRecognizers) {
                    if ([longPress isKindOfClass:UILongPressGestureRecognizer.class]) {
                        [subview removeGestureRecognizer:longPress];
                    }
                }
            }
        }
    }
}

- (void)registerModule:(Class)engineClass {

    Class moduleClass;
    _engine = [engineClass new];
    if (_engine == nil) {
        _engine = [LAPPWKEngine new];
        moduleClass = LAPPWKEngine.class;
    }else{
        moduleClass = engineClass;
    }
    
    LAModuleContext *context = [[LAModuleContext alloc] init];
    context.webView = self.webView;
    context.name = @"上下文";
    
    // 注册 默认模块
    [self.jsBridgeEngine.moduleRegister registerModuleClass:moduleClass withContext:context];
}


- (void)addImageLongPressGestureRecognizerObserver:(void (^)(NSString *imageUrl))imageHandler
{
    _webView.longpressEnable = YES;
    [_webView addGestureRecognizerObserverWebElements:imageHandler];
}

- (void)removeImageLongPressGestureRecognizer
{
    _webView.longpressEnable = NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:kWKViewKVOEstimatedProgressPath]) {
        self.progress.progress = _webView.estimatedProgress;
    }
    
    if (object == _webView && [keyPath isEqualToString:kWKViewKVOEstimatedProgressPath]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progress.hidden = YES;
            [self.progress setProgress:0 animated:NO];
        }else {
            self.progress.hidden = NO;
            [self.progress setProgress:newprogress animated:YES];
        }
    }
}

- (UIProgressView *)progress
{
    if (!_progress) {
        _progress = [[UIProgressView alloc] init];
        _progress.progressTintColor = [UIColor colorWithRed:52/255.0f green:152/255.0f blue:247/255.0f alpha:1];
        _progress.trackTintColor = [UIColor clearColor];
        _progress.hidden = YES;
    }
    return _progress;
}
- (void)refreshCurrentPage
{
    [_webView reload];
}
- (void)setViewModel:(LAPPWKViewModel *)viewModel
{
    _viewModel = viewModel;
}

- (void)customBack:(void (^)(BOOL customBack))backHander
{
    [_engine customBack:^(BOOL success) {
        backHander(success);
    }];
}


- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView
{
    [webView reload];
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    
    // 判断服务器采用的验证方法
    if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
        // 如果没有错误的情况下 创建一个凭证，并使用证书
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
    }else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    if (self.disableLoading == NO) {
        [TLProcessHUD showWithStatus:kTLProcessHUDDefaultStatus on:self autoDismissDelay:5 completion:nil];
    }
    if (_viewModel.wkWebViewDidStartProvisionalHandler) {
        _viewModel.wkWebViewDidStartProvisionalHandler(webView, navigation);
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    if ([self judgeSystemOperationURL:navigationAction.request.URL]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    if (_longpress) {
        _longpress = NO;
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }

    LAPPWeak(self);
    [self injectAppCoreWithURL:navigationAction.request.URL finishHandler:^{
        LAPPStrong(self);
        if (self.viewModel.wkWebViewDecidePolicyHandler) {
            self.viewModel.wkWebViewDecidePolicyHandler(webView, navigationAction, decisionHandler);
        }
    }];
}
- (BOOL)judgeSystemOperationURL:(NSURL *)url
{
    if ([url.scheme isEqualToString:@"tel"] || [url.scheme isEqualToString:@"sms"] || [url.scheme isEqualToString:@"mailto"]) {
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] openURL:url];
            });
            return YES;
        }
    }
    return NO;
}
- (void)injectAppCoreWithURL:(NSURL*)url finishHandler:(void(^)(void))finishHandler
{
    if (![_webView.configuration.userContentController.userScripts containsObject:self.AppCore]) {
        [_webView.configuration.userContentController addUserScript:self.AppCore];
    }

    if(![_webView.configuration.userContentController.userScripts containsObject:self.noneSelectScript]){
        
        [self.webView.configuration.userContentController addUserScript:self.noneSelectScript];
    }

    finishHandler();
}
- (WKUserScript *)AppCore
{
    if (!_AppCore) {
        if ([kLAPPKitJSFilePath length] == 0) {
             NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[LAPPWKView class]] pathForResource:@"LApp" ofType:@"bundle"]];
            NSString *filePath = [bundle pathForResource:@"WKWebJSCore" ofType:@"js"];
            kLAPPKitJSFilePath = filePath;
        }
        
        NSString *bridgeCore = [NSString stringWithContentsOfFile:kLAPPKitJSFilePath encoding:NSUTF8StringEncoding error:nil];
        _AppCore = [[WKUserScript alloc] initWithSource:bridgeCore injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
    }
    return _AppCore;
}

-(WKUserScript *)noneSelectScript{
    if(!_noneSelectScript){
        NSMutableString *javascript = [NSMutableString string];
        [javascript appendString:@"document.documentElement.style.webkitTouchCallout='none';"];//禁止长按
        _noneSelectScript = [[WKUserScript alloc] initWithSource:javascript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    }
    return _noneSelectScript;
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    if (self.disableLoading == NO) {
        [TLProcessHUD dismissAllOn:self];
    }
    
    if (webView.title && webView.title.length && _viewModel.setTitleHandler) {
        _viewModel.setTitleHandler(webView.title);
    }
    if (_viewModel.wkWebViewDidFinishHandler) {
        _viewModel.wkWebViewDidFinishHandler(webView, navigation);
    }
}

// 判断是否白屏
- (BOOL)isBlankView:(UIView*)view { // YES：blank
    Class wkCompositingView =NSClassFromString(@"WKCompositingView");
    if ([view isKindOfClass:[wkCompositingView class]]) {
        return NO;
    }
    for(UIView *subView in view.subviews) {
        if (![self isBlankView:subView]) {
            return NO;
            
        }
    }
    
    return YES;
}

- (void)webView:(WKWebView *)webView didFailNavigation: (null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"网页加载错误didFailNavigation = %@",error);
    if (self.disableLoading == NO) {
        [TLProcessHUD dismissOn:self];
    }
    if (_viewModel.wkWebViewDidFailHandler) {
        _viewModel.wkWebViewDidFailHandler(webView, navigation, error);
    }
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
      NSLog(@"网页加载错误didFailProvisionalNavigation = %@",error);
    if (self.disableLoading == NO) {
        [TLProcessHUD dismissOn:self];
    }
    if (_viewModel.wkWebViewDidFailHandler) {
        _viewModel.wkWebViewDidFailHandler(webView, navigation, error);
    }
}
#pragma mark - 此方法是解决iPad无法打开网页.决定是否打开新网页的，如果返回nil，就在当前WebView上打开新网页，如果创建新webView会建议新标签

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    LAPPAlertController *alertController = [LAPPAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert alertType:AlertType_AlertPanelType];
    alertController.alertHander = completionHandler;
    [alertController addAction:([UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        !completionHandler?:completionHandler();
    }])];
    [[LRTools getCurrentViewController] presentAlertViewController:alertController];
}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    LAPPAlertController *alertController = [LAPPAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert alertType:AlertType_ConfirmPanelType];
    alertController.confirmHandler = completionHandler;
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        !completionHandler?:completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        !completionHandler?:completionHandler(YES);
    }])];
    [[LRTools getCurrentViewController] presentAlertViewController:alertController];
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler
{
    
    BOOL syncFunc = [_engine checkSyncFunc:webView prompt:prompt completionHandler:completionHandler];
    if (!syncFunc) {
        LAPPAlertController *alertController = [LAPPAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert alertType:AlertType_TextinputPanelType];
        alertController.textinputHandler = completionHandler;
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.text = defaultText;
        }];
        [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            !completionHandler?:completionHandler(alertController.textFields[0].text?:@"");
        }])];
        [[LRTools getCurrentViewController] presentAlertViewController:alertController];
    }
}


@end
