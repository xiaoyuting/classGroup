//
//  DownLoadTableViewCell.m
//  dafengche
//
//  Created by IOS on 16/9/18.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "DownLoadTableViewCell.h"

@implementation DownLoadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    [self.DownLoadBtn setImage:[UIImage imageNamed:@"tick-roundel-1"] forState:UIControlStateNormal];
//    [self.DownLoadBtn addTarget:self action:@selector(Down:) forControlEvents:UIControlEventTouchUpInside];
}
//
//-(void)Down:(UIButton*)sender{
//
//    if (sender.selected == YES) {
//        sender.selected = NO;
//        [self.DownLoadBtn setImage:[UIImage imageNamed:@"tick-roundel"] forState:UIControlStateNormal];
//        
//    }else{
//    
//        sender.selected = YES;
//        [self.DownLoadBtn setImage:[UIImage imageNamed:@"tick-roundel-1"] forState:UIControlStateNormal];
//    }
//}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


//- (IBAction)downLoadAction:(id)sender {
//    [sender setImage:[UIImage imageNamed:@"tick-roundel"] forState:UIControlStateNormal];
//
//    [self.delegate addDownLoadTaskAction:self.index];
//    
//
//}
@end
