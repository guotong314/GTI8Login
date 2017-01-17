//
//  GTDefine.h
//  GTSpec
//
//  Created by 郭通 on 17/1/4.
//  Copyright © 2017年 郭通. All rights reserved.
//
#ifdef DEBUG_LOG
#define DMLog(...)         NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#define DMLogRect(rect)    DMLog(@"%s x:%.4f, y:%.4f, w:%.4f, h:%.4f", #rect, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
#define DMLogSize(size)    DMLog(@"%s w:%.4f, h:%.4f", #size, size.width, size.height)
#define DMLogPoint(point)  DMLog(@"%s x:%.4f, y:%.4f", #point, point.x, point.y)
#else
#define DMLog(...)         do { } while (0)
#define DMLogRect(rect)    DMLog(@"%s x:%.4f, y:%.4f, w:%.4f, h:%.4f", #rect, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
#define DMLogSize(size)    DMLog(@"%s w:%.4f, h:%.4f", #size, size.width, size.height)
#define DMLogPoint(point)  DMLog(@"%s x:%.4f, y:%.4f", #point, point.x, point.y)
//#define NSLog(...)         do { } while (0)
#endif

#ifndef GTDefine_h
#define GTDefine_h

#define iPhone4_5ScreenWidth   320
#define iPhone6ScreenWidth     375
#define iPhone6PlusScreenWidth 414

#define UI_NAVIGATION_BAR_HEIGHT        44
#define UI_STATUS_BAR_HEIGHT            20
#define UI_SCREEN_WIDTH                 ([[UIScreen mainScreen] bounds].size.width)
#define UI_SCREEN_HEIGHT                ([[UIScreen mainScreen] bounds].size.height)
#define IOS_SYSTEM                      ([[UIDevice currentDevice].systemVersion floatValue])
#define RGBA(r,g,b,a)                   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define RGB(r,g,b)      RGBA(r,g,b,1)
#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define HEXCOLORA(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]
#define FONT_(xx)                        [UIFont systemFontOfSize:xx]//[UIFont fontWithName:@"YouYuan" size:xx]
#define FONT_Bold_(xx)                   [UIFont boldSystemFontOfSize:xx]

#define isIPhone6Plus                   [UIScreen mainScreen].bounds.size.height==736
#define AppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#define ImageNamed(_pointer) [UIImage imageNamed:_pointer]

#define APPDELEGATE     ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define APPWINDOW       [[UIApplication sharedApplication] keyWindow]

#define LargeScreenScale  (UI_SCREEN_WIDTH/iPhone4_5ScreenWidth)

#define IsEmptyString(str) (![str isKindOfClass:[NSString class]] || (!str || [str.trim isEqualToString:@""]))

//NavBar背景色
#define COLOR_NAV                       RGBA(234,234,234,1)

#define GTRouterParameterURL  @"GTRouterParameterURL"
#define GTRouterParameterCompletion  @"GTRouterParameterCompletion"
#define GTRouterParameterUserInfo  @"GTRouterParameterUserInfo"

#endif /* GTDefine_h */
