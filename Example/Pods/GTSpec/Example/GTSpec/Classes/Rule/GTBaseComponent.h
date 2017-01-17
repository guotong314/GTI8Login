//
//  GTBaseComponent.h
//  GTEmptyView
//
//  Created by 郭通 on 17/1/6.
//  Copyright © 2017年 郭通. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTBaseRuleSource.h"

@interface GTBaseComponent : NSObject<GTBaseRuleSource>

+ (instancetype)sharedInstance;

@end
