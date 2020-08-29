
#import "LAPPAlertController.h"

@interface LAPPAlertController ()
@property (nonatomic, assign) LAPPAlertType alertType;
@end

@implementation LAPPAlertController
    
- (instancetype)init{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackgroundHandler:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle alertType:(LAPPAlertType)alertType
{
    LAPPAlertController *alertController = [LAPPAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    alertController.alertType = alertType;
    return alertController;
}

- (void)didEnterBackgroundHandler:(NSNotification *)noti
{
    if (self.presentingViewController) {
        switch (self.alertType) {
            case AlertType_AlertPanelType:{
                if (self.alertHander) {
                    self.alertHander();
                }
            }break;
            case AlertType_ConfirmPanelType: {
                if (self.confirmHandler) {
                    self.confirmHandler(NO);
                }
            }break;
            case AlertType_TextinputPanelType: {
                if (self.textinputHandler) {
                    self.textinputHandler(@"");
                }
            }break;
            default:
                break;
        }
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
