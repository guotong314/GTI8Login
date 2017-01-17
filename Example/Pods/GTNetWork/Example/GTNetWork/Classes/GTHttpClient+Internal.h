//
//  GTHttpClient+Internal.h
//  GTNetWork
//
//  Created by 郭通 on 17/1/10.
//  Copyright © 2017年 郭通. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTHttpClient.h"

@interface GTHttpClient(Internal)

-(AFHTTPRequestOperation*)operationWithHTTPMethod:(NSString*)method
                                     apiURLString:(NSString*)apiURLString
                                       parameters:(NSDictionary*)parameters
                                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(void)startOperation:(NSOperation*)op;

-(NSError*)preHandleResponse:(id)response operation:(NSOperation*)operation;

-(void)logHTTPError:(NSError*)error withOperation:(NSOperation*)operation;
-(void)logServerResponseError:(NSError*)error withOperation:(NSOperation*)operation;
-(void)logSuccessWithResponse:(id)response withOperation:(NSOperation*)operation;

//-(NSError*)wrapHTTPError:(NSError*)error;
-(void)handleResponse:(id)response withCompletionHandler:(DMCompletionHandler)handler;
-(void)handleErrorHandler:(DMCompletionHandler)handler;

@end
