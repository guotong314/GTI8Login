//
//  GTNavigateModule.h
//  GTRootKit
//
//  Created by 郭通 on 17/1/17.
//  Copyright © 2017年 郭通. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTNavigationViewController.h"

@interface GTNavigateModule : NSObject

@property (nonatomic, strong) GTNavigationViewController *currentNavigation;

+(instancetype) sharedInstance;

@end
