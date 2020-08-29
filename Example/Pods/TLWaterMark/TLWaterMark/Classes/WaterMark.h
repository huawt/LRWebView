
#import <Foundation/Foundation.h>

#if __has_include(<TLWaterMark/WaterMark.h>)

FOUNDATION_EXPORT double TLWaterMarkVersionNumber;
FOUNDATION_EXPORT const unsigned char TLWaterMarkVersionString[];

#import <TLWaterMark/WaterMarkView.h>
#import <TLWaterMark/UIImage+WMOrientation.h>
#import <TLWaterMark/UIImage+WaterMark.h>
#import <TLWaterMark/UIView+WaterMark.h>
#import <TLWaterMark/WaterMarkCollectionView.h>
#import <TLWaterMark/WaterMarkTableView.h>
#import <TLWaterMark/WaterMarkWebView.h>

#else

#import "UIImage+WMOrientation.h"
#import "WaterMarkView.h"
#import "UIImage+WaterMark.h"
#import "UIView+WaterMark.h"
#import "WaterMarkCollectionView.h"
#import "WaterMarkTableView.h"
#import "WaterMarkWebView.h"

#endif

