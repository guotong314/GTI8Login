//
//  GTBaseRuleSource.h
//  GTEmptyView
//
//  Created by 郭通 on 17/1/6.
//  Copyright © 2017年 郭通. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GTBaseRuleSource <NSObject>

@optional

/**
 *  注册关心的 URLs
 *
 *  @return NSArray
 */
- (NSArray *)registeredURLs;

/**
 *  处理关心的 URL。具体的逻辑在这个方法里可能会通过 switch / case 来针对不同的 URL 做不同的处理
 *  首先通过 MGJRouter 来把 URL 注册到它内部，然后 openURL 时，再找到这个 URL 对应的处理方法
 *
 *  @param URL      这是一个完整的 URL
 *  @param userInfo userInfo 里会包含调用方传过来的 userInfo
 */
- (void)handleURL:(NSString *)URL withUserInfo:(NSDictionary *)userInfo  completion:(void (^)(id result))completion;

///**
// *  @author Kongkong
// *
// *  @brief 组件内部需要关心的 URL，跳转 URL
// */
//@property (nonatomic,strong) NSMutableDictionary*   careUrls;

@end

