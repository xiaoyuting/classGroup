//
//  LibCateCell.h
//  dafengche
//
//  Created by 智艺创想 on 16/11/26.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LibCateCell : UITableViewCell

@property (strong ,nonatomic)UILabel *title;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
- (void)dataSourceWith:(NSDictionary *)dict;
- (void)arrayWithArray:(NSArray *)array withIndex:(NSInteger)index;

@end
