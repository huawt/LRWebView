
#import "WaterMarkView.h"
#import "UIImage+WaterMark.h"
#import <WebKit/WebKit.h>

NSString *const kWaterMarkWebViewObserverKeyPath = @"scrollView.contentSize";
NSString *const kWaterMarkScrollViewObserverKeyPath = @"contentSize";

static NSString *kConfiguredDefaultWaterMark = @"";

@interface WaterMarkView ()

@property (nonatomic, assign) WaterMarkViewType markType;

@end

@implementation WaterMarkView

- (void)dealloc
{
    NSLog(@"水印Dealloc");
}
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (self.superview == newSuperview) {
        return;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:kWaterMarkScrollViewObserverKeyPath]) {
        UIScrollView *scrollView = (UIScrollView*)object;
        
        if (scrollView.frame.size.height > scrollView.contentSize.height) {
            if (CGSizeEqualToSize(self.frame.size, scrollView.frame.size)) {
                
            }else{
                self.frame = CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height);
            }
        }else{
            if (CGSizeEqualToSize(self.frame.size, scrollView.contentSize)) {
                
            }else{
                self.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
            }
        }
        
        [self layoutIfNeeded];
    }else if ([keyPath isEqualToString:kWaterMarkWebViewObserverKeyPath]) {
        UIScrollView *scrollView = ((WKWebView*)object).scrollView;
        
        if (scrollView.frame.size.height > scrollView.contentSize.height) {
            if (CGSizeEqualToSize(self.frame.size, scrollView.frame.size)) {
                
            }else{
                self.frame = CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height);
            }
        }else{
            if (CGSizeEqualToSize(self.frame.size, scrollView.contentSize)) {
                
            }else{
                self.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
            }
        }
        
        [self layoutIfNeeded];
    }
}

+ (void)configureWaterMark:(NSString *)waterMark
{
    if (waterMark && waterMark.length) {
        kConfiguredDefaultWaterMark = waterMark;
    }
}

+ (NSString *)defaultWaterMark
{
    return kConfiguredDefaultWaterMark;
}

+ (UIImage *)markImage:(UIImage *)image
{
    WaterMarkView *markView = [[WaterMarkView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height) waterMarkString:@"" markViewType:kMarkViewType_Image];
    UIImage *newImage = [image addWaterMarkView:markView];
    return newImage;
}

- (instancetype)initWithFrame:(CGRect)frame waterMarkString:(NSString *)waterMark  markViewType:(WaterMarkViewType)markType;
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = NO;
        self.markType = markType;
        [self configSubViewsWithWaterMarkType:markType];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self configSubViewsWithWaterMarkType:self.markType];
}

- (CGFloat)markFontSize
{
    if (self.markType == kMarkViewType_Image) {
        return 110;
    }
    if ([UIScreen mainScreen].bounds.size.width > 380) {
        return 18;
    }else if ([UIScreen mainScreen].bounds.size.width > 330) {
        return 16;
    }else{
        return 14;
    }
}

- (NSInteger)markColumnNumber
{
    if (self.markType == kMarkViewType_Image) {
        return 3;
    }else{
        return 2;
    }
}

- (CGFloat)markTextAlpha
{
    if (self.markType == kMarkViewType_Image) {
        return 0.0425f;
    }else{
        return 0.025f;
    }
}

- (void)configSubViewsWithWaterMarkType:(WaterMarkViewType)markType
{
    self.markType = markType;
    self.backgroundColor = [self waterColorWithSize:self.frame.size column:[self markColumnNumber]];
}


- (UIColor *)waterColorWithSize:(CGSize)size column:(NSInteger)column
{
    NSString *text = [WaterMarkView defaultWaterMark];
    
    NSAttributedString *attText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:[self markFontSize]], NSForegroundColorAttributeName:[UIColor colorWithWhite:0 alpha:[self markTextAlpha]]}];
    CGFloat textWidth = attText.size.width;
    CGFloat textHeight = attText.size.height;
    
    CGFloat waterWidth = CGRectGetWidth(self.frame) / @(column).floatValue;
    CGFloat waterHeight = textWidth * tan(M_PI/12.0) * 2 + textHeight;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, waterWidth, waterHeight)];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
    label.backgroundColor = [UIColor clearColor];
    label.attributedText = attText;
    label.textAlignment = NSTextAlignmentCenter;
    label.transform = CGAffineTransformMakeRotation(-M_PI/12.0);
    [view addSubview:label];
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:image];
}

- (CGSize)autoResizeToSize:(CGSize)size WithString:(NSString *)string withFont:(UIFont *)font
{
    NSDictionary * attdic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize fixSize = [string boundingRectWithSize:size options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attdic context:nil].size;
    return fixSize;
}

@end

