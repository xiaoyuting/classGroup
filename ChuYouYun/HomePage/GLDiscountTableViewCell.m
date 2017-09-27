//
//  GLDiscountTableViewCell.m
//  dafengche
//
//  Created by IOS on 16/9/30.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "GLDiscountTableViewCell.h"
#import "UIColor+HTMLColors.h"
#import "UIView+Utils.h"
@implementation GLDiscountTableViewCell

- (void)awakeFromNib {
    
    self.backgroundColor = [UIColor colorWithHexString:@"#f7f8f8"];
    //[self.backImageV.layer setBorderColor:[UIColor colorWithHexString:@"#cdcdcd"].CGColor];
    //[self.backImageV.layer setBorderWidth:0.5];
    self.firstLab.textColor = [UIColor colorWithHexString:@"#333333"];
    self.SecondLab.textColor = [UIColor colorWithHexString:@"#333333"];
    self.ThirdLab.textColor = [UIColor colorWithHexString:@"#333333"];
    self.backLab.backgroundColor = [UIColor colorWithHexString:@"#98d9fa"];
     self.contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    if (MainScreenWidth>375) {
        CGRect frames;
         frames =self.backLab.frame ;
        frames.size.width = frames.size.width+10;
        self.backLab.frame = frames;
    }
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
- (void)setFileInfo:(GLDiscountModel *)fileInfo
{
    _fileInfo = fileInfo;
    self.MoneyLab.text = fileInfo.MoneyStr;
    self.firstLab.text = fileInfo.firstStr;
    self.SecondLab.text = fileInfo.secondStr;
    self.ThirdLab.text = fileInfo.thirdStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
