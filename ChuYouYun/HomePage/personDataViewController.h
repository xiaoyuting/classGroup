//
//  personDataViewController.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/27.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface personDataViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UIButton *userSex;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@property (weak, nonatomic) IBOutlet UITextView *userIdiograph;
@property (weak, nonatomic) IBOutlet UILabel *textNumber;
@property (weak, nonatomic) IBOutlet UIView *oneView;
@property (weak, nonatomic) IBOutlet UIView *twoView;
@property (weak, nonatomic) IBOutlet UIView *thereView;

@property (strong ,nonatomic)NSDictionary   *allInformation;
@property (strong ,nonatomic)NSDictionary   *allDict;

-(id)initWithUserFace:(UIImage *)face;
@end
