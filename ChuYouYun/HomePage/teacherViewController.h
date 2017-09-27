//
//  teacherViewController.h
//  ChuYouYun
//
//  Created by zhiyicx on 15/1/21.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "rootViewController.h"
@interface teacherViewController : UIViewController
{
    rootViewController * ntvc;
}
@property (strong , retain)NSMutableArray *dataArray;

//机构
@property (strong ,nonatomic)NSString *institutionStr;

@end
