//
//  UIWebView+WebView___Category.m
//  dafengche
//
//  Created by 赛新科技 on 2017/5/26.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "UIWebView+WebView___Category.h"
#import <Foundation/Foundation.h>

//#include <objc_objc_runtime.h>

@implementation UIWebView (WebView___Category)


+ (void)load{
    //  "v@:"
    Class class = NSClassFromString(@"WebActionDisablingCALayerDelegate");
    class_addMethod(class, @selector(setBeingRemoved), setBeingRemoved, "v@:");
    class_addMethod(class, @selector(willBeRemoved), willBeRemoved, "v@:");
    
    class_addMethod(class, @selector(removeFromSuperview), willBeRemoved, "v@:");
}

id setBeingRemoved(id self, SEL selector, ...)
{
    return nil;
}

id willBeRemoved(id self, SEL selector, ...)
{
    return nil;
}

@end
