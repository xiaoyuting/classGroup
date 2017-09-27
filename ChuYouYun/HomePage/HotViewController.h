//
//  HotViewController.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/2/27.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(strong, nonatomic)UITableView *tableview;
@property(strong, nonatomic)NSMutableArray *muArr;
-(id)initWithwdType:(NSString *)wdType quizStr:(NSString *)str tagid:(NSString *)tag;
@end
