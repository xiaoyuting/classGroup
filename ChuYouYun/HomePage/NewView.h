//
//  NewView.h
//  ChuYouYun
//
//  Created by IOS on 16/5/30.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeTableView.h"

@interface NewView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) HomeTableView *homeTableView;


@property(strong, nonatomic)NSMutableArray *muArr;

@property (strong ,nonatomic)NSArray  *userArray;

@property(weak, nonatomic)NSString *wdType;

-(id)initWithwdType:(NSString *)wdType;

@end
