//
//  InstatutionCollectionViewCell.h
//  dafengche
//
//  Created by 智艺创想 on 16/10/24.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstatutionCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)UIImageView *imageV;
@property (nonatomic,strong)UILabel *title;
@property (nonatomic,strong)UILabel *price;
@property (nonatomic,assign)CGRect frame;


//- (void)dequeueReusableCellWithReuseIdentifier:(NSString *)string forIndexPath:(NSIndexPath *)indexPath;


@end
