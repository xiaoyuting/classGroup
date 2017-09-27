//
//  NoteDetailsViewController.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/30.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteDetailsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *importView;
@property (weak, nonatomic) IBOutlet UITextField *importText;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak ,nonatomic) NSDictionary *dic;
@end
