//
//  MyNavigationController.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/4/8.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "MyNavigationController.h"
#import "videoPlayVC.h"
@implementation MyNavigationController

- (BOOL)shouldAutorotate
{
    return [self.viewControllers.lastObject shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return [self.viewControllers.lastObject supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.viewControllers.lastObject preferredInterfaceOrientationForPresentation];
}


@end
