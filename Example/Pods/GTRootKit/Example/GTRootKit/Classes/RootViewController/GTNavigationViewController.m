//
//  GTNavigationViewController.m
//  GTRootKit
//
//  Created by 郭通 on 17/1/11.
//  Copyright © 2017年 郭通. All rights reserved.
//

#import "GTNavigationViewController.h"

@interface GTNavigationViewController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation GTNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup];
}
- (void)setup
{
    self.delegate = self;
    self.interactivePopGestureRecognizer.delegate = self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSLog(@"shownavgationshow");
    //    APPDELEGATE.tabMainVC.tabBar.userInteractionEnabled = NO;
    //    if (navigationController.viewControllers.count > 1)
    //    {
    //        [UIView animateWithDuration:0.1
    //                         animations:^{
    //                             navigationController.view.height = UI_SCREEN_HEIGHT;
    //                             APPDELEGATE.tabMainVC.tabBar.top = APPDELEGATE.tabMainVC.view.bottom;
    //                         }completion:^(BOOL finished) {
    //                             APPDELEGATE.tabMainVC.tabBar.hidden = YES;
    //                         }];
    //
    //    }
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //    APPDELEGATE.tabMainVC.tabBar.userInteractionEnabled = YES;
    //    if (viewController.hidesBottomBarWhenPushed) {
    //        [UIView animateWithDuration:0.1
    //                         animations:^{
    //                             navigationController.view.height = UI_SCREEN_HEIGHT;
    //                             APPDELEGATE.tabMainVC.tabBar.top = APPDELEGATE.tabMainVC.view.bottom;
    //                         }completion:^(BOOL finished) {
    //                             APPDELEGATE.tabMainVC.tabBar.hidden = YES;
    //                         }];
    //
    //    } else {
    //        APPDELEGATE.tabMainVC.tabBar.hidden = NO;
    //        [UIView animateWithDuration:0.1
    //                         animations:^{
    //                             navigationController.view.height = UI_SCREEN_HEIGHT - 49;
    //                             APPDELEGATE.tabMainVC.tabBar.bottom = APPDELEGATE.tabMainVC.view.bottom;
    //                         }];
    //    }
    NSLog(@"shownavgationshowDid");
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
        navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
    //    if rootViewController, set delegate nil
    if (navigationController.viewControllers.count == 1) {
        navigationController.interactivePopGestureRecognizer.enabled = NO;
        navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    
}

@end
