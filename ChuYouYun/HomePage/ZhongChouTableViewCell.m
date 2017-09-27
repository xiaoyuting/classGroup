//
//  ZhongChouTableViewCell.m
//  dafengche
//
//  Created by IOS on 16/10/13.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "ZhongChouTableViewCell.h"
#import "UIColor+HTMLColors.h"

@implementation ZhongChouTableViewCell

- (void)awakeFromNib {
    [self.backView.layer setBorderColor:[UIColor colorWithHexString:@"#cdcdcd"].CGColor];
    [self.backView.layer setBorderWidth:1];
    [self.backView.layer setMasksToBounds:YES];
    self.lineLab.backgroundColor = [UIColor colorWithHexString:@"#cdcdcd"];

}
- (IBAction)btnCliked:(UIButton *)sender {

    // 执行操作过程中应该禁止该按键的响应 否则会引起异常
    sender.userInteractionEnabled = NO;

      // 暂停意味着这个Cell里的ASIHttprequest已被释放，要及时更新table的数据，使最新的ASIHttpreqst控制Cell
    if (self.btnClickBlock) {
        self.btnClickBlock();
    }
    sender.userInteractionEnabled = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
