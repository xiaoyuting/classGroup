//
//  ClassTerraceCell.h
//  dafengche
//
//  Created by 智艺创想 on 16/11/29.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassTerraceCell : UITableViewCell

@property (strong ,nonatomic)UILabel *bar;
@property (strong ,nonatomic)UILabel *title;
@property (strong ,nonatomic)UILabel *name;


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
- (void)dataWithDic:(NSDictionary *)dict;

@end
