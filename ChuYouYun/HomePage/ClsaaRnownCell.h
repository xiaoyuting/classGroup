//
//  ClsaaRnownCell.h
//  dafengche
//
//  Created by 赛新科技 on 2017/5/9.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClsaaRnownCell : UITableViewCell

@property (strong ,nonatomic)UILabel *bar;
@property (strong ,nonatomic)UILabel *title;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

@end
