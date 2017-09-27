//
//  GLMemberTableViewCell.m
//  dafengche
//
//  Created by IOS on 16/10/11.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "GLMemberTableViewCell.h"
#import "UIColor+HTMLColors.h"
#import "UIView+Utils.h"


@implementation GLMemberTableViewCell

- (void)awakeFromNib {
    self.backgroundColor = [UIColor colorWithHexString:@"#f7f8f8"];
//    [self.backImageV.layer setBorderColor:[UIColor colorWithHexString:@"#cdcdcd"].CGColor];
//    [self.backImageV.layer setBorderWidth:0.5];
    self.secondLab.textColor = [UIColor colorWithHexString:@"#333333"];
    self.thirdLab.textColor = [UIColor colorWithHexString:@"#333333"];
    self.lastLab.textColor = [UIColor colorWithHexString:@"#333333"];
    self.aconImageV.image = [UIImage imageNamed:@"皇冠"];
    self.backLab.backgroundColor = [UIColor colorWithHexString:@"#e15a5a"];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)clickDownload:(UIButton *)sender {
    
    // 执行操作过程中应该禁止该按键的响应 否则会引起异常
    sender.userInteractionEnabled = NO;
    
    // 暂停意味着这个Cell里的ASIHttprequest已被释放，要及时更新table的数据，使最新的ASIHttpreqst控制Cell
    if (self.btnClickBlock) {
        self.btnClickBlock();
    }
    sender.userInteractionEnabled = YES;
}

@end
