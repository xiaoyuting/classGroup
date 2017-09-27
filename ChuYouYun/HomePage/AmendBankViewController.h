//
//  AmendBankViewController.h
//  ChuYouYun
//
//  Created by 智艺创想 on 15/10/19.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AmendBankViewController : UIViewController

@property(nonatomic,assign)int displayType;

@property (strong, nonatomic)NSString *carNumber;
@property (strong ,nonatomic)NSString *name;
@property (strong ,nonatomic)NSArray  *bankArray;
@property (strong ,nonatomic)UIView   *bankView;
@property (strong ,nonatomic)UIView   *allView;
@property (strong ,nonatomic)UIWindow *allWindow;
@property (strong ,nonatomic)NSArray  *bigArray;

@property (strong ,nonatomic)UIView   *provinceView;
@property (strong ,nonatomic)NSMutableArray *provinceArray;
@property (strong ,nonatomic)NSString *idProvince;

@property (strong ,nonatomic)UIView   *cityView;
@property (strong ,nonatomic)NSMutableArray *cityArray;
@property (strong ,nonatomic)NSString *idCity;

@property (strong ,nonatomic)NSMutableArray *areaArray;
@property (strong ,nonatomic)UIView   *areaView;
@property (strong ,nonatomic)NSString *idArea;

@property (strong ,nonatomic)NSDictionary *dic;
@property (strong ,nonatomic)NSString     *bankID;


@property (strong ,nonatomic)NSString *addOrAmend;
//地址数组
@property(nonatomic,strong)NSArray *provinces;
@property(nonatomic,strong)NSArray *citys;
@property(nonatomic,strong)NSArray *areas;
//银行数组
@property(nonatomic,strong)NSArray * bankArr;
@property(nonatomic,strong)NSMutableArray * bankCardDetailArr;


@end
