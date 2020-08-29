#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "UIImage+WaterMark.h"
#import "UIImage+WMOrientation.h"
#import "UIView+WaterMark.h"
#import "WaterMark.h"
#import "WaterMarkCollectionView.h"
#import "WaterMarkTableView.h"
#import "WaterMarkView.h"
#import "WaterMarkWebView.h"

FOUNDATION_EXPORT double TLWaterMarkVersionNumber;
FOUNDATION_EXPORT const unsigned char TLWaterMarkVersionString[];

