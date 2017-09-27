//
//  MyShopingCarCell.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/2/13.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyUIButton.h"
@interface MyShopingCarCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *bookName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet MyUIButton *stateBtn;

@end
