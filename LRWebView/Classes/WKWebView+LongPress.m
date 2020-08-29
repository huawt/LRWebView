
#import "WKWebView+LongPress.h"
#import <objc/message.h>

/** 获取网页body里面的HTML*/
NSString* const JSGetHTMLFromBody =
@"document.body.innerHTML";

/** 获取网页body里面的HTML*/
NSString* const JSGetHTMLById =
@"function JSGetHTMLById(id) {\
return document.getElementById(id).innerHTML;\
}";
 
/** 获取链接的js方法 */  //目前只用到该方法
NSString* const JSSearchHrefFromHtml =
@"function JSSearchHref(x,y) {\
var e = document.elementFromPoint(x, y);\
while(e){\
if(e.href){\
return e.href;\
}\
e = e.parentElement;\
}\
return e.href;\
}";

/** 抓取文本标题 */
NSString* const JSSearchTextTitleFromHtml =
@"function JSSearchText(x,y) {"
"return document.elementFromPoint(x, y).innerText;"
"}";

/** 获取链接的js方法 */
NSString* const JSSearchTextTypeFromHtml =
@"function JSSearchTextType(x,y) {"
"return document.elementFromPoint(x, y).tagName;"
"}";

/** 获取图片链接的js方法 */
NSString* const JSSearchImageFromHtml =
@"function JSSearchImage(x,y) {"
"return document.elementFromPoint(x, y).src;"
"}";

/** 获取HTML所有的图片 */
NSString* const JSSearchAllImageFromHtml =
@"function JSSearchAllImage(){"
"var img = [];"
"for(var i=0;i<$(\"img\").length;i++){"
"if(parseInt($(\"img\").eq(i).css(\"width\"))> 60){ "//获取所有符合放大要求的图片，将图片路径(src)获取
" img[i] = $(\"img\").eq(i).attr(\"src\");"
" }"
"}"
"var img_info = {};"
"img_info.list = img;" //保存所有图片的url
"return img;"
"}";

/** 获取web page宽 */
NSString* const JSGetWebPageWidth =
@"document.getElementById('content').offsetWidth";

/** 获取web page高 */
NSString* const JSGetWebPageHeight =
@"document.getElementById('content').offsetHeight";


/** 设置web page尺寸 */
NSString* const JSSetWebPageWidth =
@"function JSSetWebPageWidth(wid) {\
document.querySelector('meta[name=viewport]').setAttribute('content',\
'width=wid;', false); \
}";

/** 设置web page字体大小 */
NSString* const JSSetFontSize =
@"function JSSetFontSize(size) {\
document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= size\
}";

/** 设置web page字体大小 */
NSString* const JSRemoveAllLink =
@"$(document).ready(function () {$('a').removeAttr('href');})";

/** 替换所有的href */
NSString* const JSReplaceAllHref =
@"function JSReplaceAllLinkWithUrlString(url) {\
$(document).ready(function () {$('a').setAttribute('href',url);})\
}";

/** 通过id替换元素的href */
NSString* const JSReplaceURLStringById =
@"function JSSetURLString(id,url) {\
document.getElementById(id).setAttribute('href',url);\
}";

/** 通过手势位置替换元素的href */
NSString* const JSReplaceURLStringByLongPress =
@"function JSSetURLStringByLongPress(x,y,url) {\
document.elementFromPoint(x, y).setAttribute('href',url);\
}";

/** 通过id替换元素的href */
NSString* const JSReplaceImageById =
@"function JSReplaceImageById(id,url) {\
document.getElementById(id).src = url;\
}";

/** 通过手势位置替换图片 */
NSString* const JSReplaceImageByLongPress =
@"function JSSetURLStringByLongPress(x,y,url) {\
document.elementFromPoint(x, y).setAttribute('src',url);\
}";


#pragma mark --

#pragma mark -- 点击事件相关操作


/** 提交表单事件 */
NSString* const JSSubmitForms =
@"document.forms[0].submit();";

/** 取消点击事件 */
NSString* const JSFunctionAddEventCanal =
@"function JSAddEventCanal(x,y) {\
var e = document.elementFromPoint(x, y);\
var num = 0;\
while(e){\
if(num>5)return;\
num++;\
e.addEventListener('click',function(e) {\
if ( e && e.preventDefault )\
e.preventDefault();\
else\
window.event.returnValue = false;\
return false;\
},false);\
e = e.parentElement;\
}\
}";

/* 移除忽略事件 */
NSString* const JSFunctionRemoveEventCanal =
@"function JSRemoveEventCanal(x,y) {\
var e = document.elementFromPoint(x, y);\
var num = 0;\
while(e){\
if(num > 5)return;\
num++;\
e.addEventListener('click',PAEventIgnore,false);\
e = e.parentElement;\
}\
}";

/* 忽略事件方法 */
NSString* const JSFunctionEventIgnore =
@"function PAEventIgnore(e) {\
if ( e && e.preventDefault )\
e.preventDefault();\
else\
window.event.returnValue = false;\
return false;\
}\
}";


typedef void(^LongPressedImageBlock)(NSString *imageUrl);
static LongPressedImageBlock pressedImageBlock = nil;

@implementation LAWebView (LongPress)

CGPoint touchPoint;

/**
 添加长按手势
 */
- (void)addGestureRecognizerObserverWebElements:(void(^)(NSString *imageUrl))event
{
    pressedImageBlock = (LongPressedImageBlock)event;
    //长按识别图中的二维码，类似于微信里面的功能,前提是当前页面必须有二维码
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(startLongPress:)];
    longPress.delegate = self;
    
    longPress.minimumPressDuration = 0.4f;
    longPress.numberOfTouchesRequired = 1;
    longPress.cancelsTouchesInView = YES;
    [self addGestureRecognizer:longPress];
}

/** 手势精确识别，防止误操作 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if(self.longpressEnable){
        if ([otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
            
            return YES;
        }else{
            return NO;
        }
    }
    else{
        return NO;
    }
}

/** 长按识别代理 */
- (void)startLongPress:(UILongPressGestureRecognizer *)pressSender
{
    if(pressSender.state == UIGestureRecognizerStateBegan){
        
        //获取位置
        touchPoint = [pressSender locationInView:self];
        //识别/抓取html元素
        [self detectQRCodeInWebView:pressSender];
        
    }else if(pressSender.state == UIGestureRecognizerStateEnded){
        
        //可以添加你长按手势执行的方法,不过是在手指松开后执行
        
    }else if(pressSender.state == UIGestureRecognizerStateChanged){
        
        //在手指点下去一直不松开的状态执行
    }
}

#pragma mark -

#pragma mark - JS注入

/** 抓取链接 */
- (void)hrefFromJSPointX:(float)x ppintY:(float)y callBack:(void(^)(NSString *hre))callback
{
    //注入JS方法
    NSString *hrefJS = JSSearchHrefFromHtml;
    [self evaluateJavaScript:hrefJS completionHandler:nil];
    
    //调用JS方法
    NSString *hrefFunc = [NSString stringWithFormat:@"JSSearchHref(%f,%f);",x,y];
    [self evaluateJavaScript:hrefFunc completionHandler:^(id _Nullable href, NSError * _Nullable error)
     {
         callback ? callback(href) : NULL;
     }];
}

#pragma mark -

#pragma mark - 检测获取的网页元素

/** 检测图片 */
- (void)detectQRCodeInWebView:(UILongPressGestureRecognizer *)pressSender
{
    //获取长按位置对应的图片url的JS代码
    NSString *imgJS = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
    NSString *titleJS = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).innerText", touchPoint.x, touchPoint.y];
    
    //判断是否是标题还是文章
    NSString * typeJS = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).tagName", touchPoint.x, touchPoint.y];
    
    // 执行对应的JS代码 获取url
    __block NSString *imgUrlString;
    __weak typeof(self)weakSelf = self;
    //抓取image
    [self evaluateJavaScript:imgJS completionHandler:^(id _Nullable imgUrl, NSError * _Nullable error)
     {
         imgUrlString = imgUrl;
         
         //抓取title
         [weakSelf evaluateJavaScript:titleJS completionHandler:^(id _Nullable title, NSError * _Nullable error)
          {
              //抓取title的类型
              [weakSelf evaluateJavaScript:typeJS completionHandler:^(id _Nullable t, NSError * _Nullable error) {
                  
                  //抓取href
                  [weakSelf hrefFromJSPointX:touchPoint.x ppintY:touchPoint.y callBack:^(NSString *hre) {
                      
                      [weakSelf showActionWithImage:imgUrlString href:hre title:title type:t];
                  }];
              }];
          }];
     }];
}

/** 弹出检测出来的信息 */
- (void)showActionWithImage:(NSString *)imageUrl href:(NSString *)href title:(NSString *)title type:(NSString *)t
{
    pressedImageBlock ? pressedImageBlock(imageUrl) : NULL;
}

@end
