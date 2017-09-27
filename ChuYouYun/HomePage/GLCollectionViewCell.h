//
//  GLCollectionViewCell.h
//  dafengche
//
//  Created by IOS on 17/1/18.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DDNewsTVC.h"

@interface GLCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy  ) NSString  *urlString;

@property (nonatomic, strong) DDNewsTVC *newsTVC;


@end
