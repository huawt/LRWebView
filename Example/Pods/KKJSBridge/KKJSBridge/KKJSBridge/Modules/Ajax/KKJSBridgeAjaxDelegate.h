//
//  KKJSBridgeAjaxDelegate.h
//  KKJSBridge
//
//  Created by karos li on 2019/7/26.
//  Copyright © 2019 karosli. All rights reserved.
//

#ifndef KKJSBridgeAjaxDelegate_h
#define KKJSBridgeAjaxDelegate_h
#import <Foundation/Foundation.h>

@class KKJSBridgeXMLHttpRequest;

/**
 需要回传给 ajax 的回调实现
 */
@protocol KKJSBridgeAjaxDelegate <NSObject>

@optional
- (void)JSBridgeAjaxInProcessing:(id<KKJSBridgeAjaxDelegate>)ajax;

@required
- (void)JSBridgeAjaxDidCompletion:(id<KKJSBridgeAjaxDelegate>)ajax response:(NSURLResponse *)response responseObject:(id _Nullable)responseObject error:(NSError * _Nullable)error;

@end

/**
 Ajax 请求代理管理者，用于统一代理 JSBridge Ajax 内部请求，交由外部网络库来处理请求，并把处理结果回传给内部
 */
@protocol KKJSBridgeAjaxDelegateManager <NSObject>

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request callbackDelegate:(NSObject<KKJSBridgeAjaxDelegate> *)callbackDelegate;

@end


#endif /* KKJSBridgeAjaxDelegate_h */
