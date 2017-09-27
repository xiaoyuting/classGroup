//
//  replyQuestion.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/2/24.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface replyQuestion : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(strong, nonatomic)UITableView *tableview;
@property(strong, nonatomic)NSMutableArray *muArr;
@property(weak, nonatomic)NSString *wdType;
-(id)initWithwdType:(NSString *)wdType;
@property (strong ,nonatomic)NSArray *allArray;
@end
