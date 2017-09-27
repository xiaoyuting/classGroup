//
//  NewQuestion.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/2/23.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewQuestion : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(strong, nonatomic)UITableView *tableview;
@property(strong, nonatomic)NSMutableArray *muArr;
@property (strong ,nonatomic)NSArray  *userArray;
@property(weak, nonatomic)NSString *wdType;
-(id)initWithwdType:(NSString *)wdType;
@end
