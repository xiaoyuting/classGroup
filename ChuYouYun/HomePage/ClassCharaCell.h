//
//  ClassCharaCell.h
//  dafengche
//
//  Created by 智艺创想 on 16/11/22.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassCharaCell : UITableViewCell

@property (strong ,nonatomic)UILabel *title;
@property (strong ,nonatomic)UIButton *imageButton;
@property (strong ,nonatomic)UILabel *time;
@property (strong ,nonatomic)UIButton *freeButton;


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
- (void)dataSourceWith:(NSDictionary *)dict;
- (void)dataSourceWith:(NSDictionary *)dict WithIndex:(NSInteger)index;

@end
