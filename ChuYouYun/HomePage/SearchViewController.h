//
//  SearchViewController.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/2/24.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleText;

@property (weak, nonatomic) IBOutlet UITextField *body;
@property (weak, nonatomic) IBOutlet UIView *bodyView;

@property (weak, nonatomic) IBOutlet UIButton *classify;
@property (strong, nonatomic)NSMutableArray *imageArr;
@property (strong, nonatomic)UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UILabel *hoose;

@end
