//
//  GLLiveCollectionViewCell.h
//  dafengche
//
//  Created by IOS on 17/3/3.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDNewsTVC;


@interface GLLiveCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy  ) NSString  *urlString;

@property (nonatomic, strong) DDNewsTVC *newsTVC;


@end
