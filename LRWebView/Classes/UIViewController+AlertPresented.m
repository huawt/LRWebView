
#import "UIViewController+AlertPresented.h"
#import <objc/runtime.h>

@interface UIBlurEffect (Protected)
@property (nonatomic, strong, readonly) id effectSetting;
@end

@interface LRCustomBlurEffect : UIBlurEffect
@end

@implementation LRCustomBlurEffect

+ (instancetype)effectWithStyle:(UIBlurEffectStyle)style
{
    id result = [super effectWithStyle:style];
    object_setClass(result, self);
    return result;
}

- (id)effectSetting
{
    id setting = [super effectSetting];
    [setting setValue:@5 forKey:@"blurRadius"];
    return setting;
}

- (id)copyWithZone:(NSZone *)zone
{
    id result = [super copyWithZone:zone];
    object_setClass(result, [self class]);
    return result;
}
@end

@implementation UIViewController (AlertPresented)

- (CGRect)centerRectForSize:(CGSize)forSize inSize:(CGSize)inSize{
    CGFloat x = (inSize.width - forSize.width)/2;
    CGFloat y = (inSize.height - forSize.height)/2;
    CGFloat width = forSize.width;
    CGFloat height = forSize.height;
    return CGRectMake(x, y, width, height);
}

- (UIView*)backgroundView{
    if (self.navigationController) {
        return self.navigationController.view;
    }
    if ([self isKindOfClass:[UITableViewController class]]) {
        UITableViewController* vc = (UITableViewController*)self;
        return vc.tableView;
    }else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView* vc = (UICollectionView*)self;
        return vc.backgroundView;
    }else{
        return self.view;
    }
}


- (void)presentAlertViewController:(UIViewController*)viewController{
    
    if ([[[UIApplication sharedApplication] keyWindow] isKindOfClass:[UIAlertController class]]) {
        return;
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self presentViewController:viewController animated:YES completion:nil];
        return;
    }
    viewController.preferredContentSize = CGSizeMake(640, 460);
    viewController.modalPresentationStyle = UIModalPresentationPopover;

    UIPopoverPresentationController* poC = [viewController popoverPresentationController];
    poC.sourceView = [self backgroundView];
    poC.permittedArrowDirections = 0;
    poC.delegate = self;
    poC.sourceRect = [self centerRectForSize:CGSizeMake(640, 460) inSize:[self backgroundView].bounds.size];
    [self presentViewController:viewController animated:YES completion:^{

    }];
}

#pragma mark - popover delegate

- (void)prepareForPopoverPresentation:(UIPopoverPresentationController *)popoverPresentationController{
    [self addBlurEffect:YES];
}
- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    return YES;
}

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    [self addBlurEffect:NO];
}

- (void)addBlurEffect:(BOOL)add
{
    static UIVisualEffectView *blurView = nil;
    if (add) {
        if (blurView == nil) {
            UIBlurEffect *blurEffect = [LRCustomBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
            blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            blurView.frame = self.navigationController.view.bounds;
        }
        [[self backgroundView] addSubview:blurView];
        [[self backgroundView].layer setShouldRasterize:YES];
    }else{
        [blurView removeFromSuperview];
        blurView = nil;
        [[self backgroundView].layer setShouldRasterize:NO];
    }
}

- (void)removeBlurEffect{
    [self addBlurEffect:NO];
}

+ (UIViewController *)getCurrentViewController{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIViewController *rootController = window.rootViewController;
    return [self getCurrentVCFrom:rootController];
}

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC topViewController]];
    } else {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    
    return currentVC;
}


@end
