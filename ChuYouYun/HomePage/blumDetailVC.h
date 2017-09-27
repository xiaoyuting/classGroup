//
//  blumDetailVC.h
//  ChuYouYun
//
//  Created by zhiyicx on 15/2/12.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFDownloadManager.h"

typedef void(^ZFBtnClickBlock)(void);


@class ASIHTTPRequest;

typedef NS_ENUM(NSInteger, itemb) {
    Left_Itembb = 0,
    Right_Itembb
};
@interface blumDetailVC : UIViewController {
    ASIHTTPRequest *videoRequest;
    unsigned long long Recordull;
    
}
@property(nonatomic,retain)NSString * videoTitle;
@property(nonatomic,retain)NSString * cid;
@property(nonatomic,retain)NSString * collectStr;
@property(nonatomic,retain)NSMutableDictionary * dict;
@property(nonatomic,retain)NSMutableArray * imageArray;
@property(nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic ,strong)NSDictionary *userDic;
@property (nonatomic ,strong)UIView *buyView;
@property (strong ,nonatomic)UIView *allView;
@property (strong ,nonatomic)UIWindow *popWindow;
@property (strong ,nonatomic)UIButton *btn;
@property (strong ,nonatomic)NSDictionary *moneyDic;
@property (strong ,nonatomic)UILabel      *titleText;

/** 下载按钮点击回调block */
@property (nonatomic, copy  ) ZFBtnClickBlock  btnClickBlock;
/** 下载信息模型 */
@property (nonatomic, strong) ZFFileModel      *fileInfo;
/** 该文件发起的请求 */
@property (nonatomic,retain ) ZFHttpRequest    *request;

//创建UIButton
-(UIButton *)button:(NSString *)title image:(NSString *)image frame:(CGRect)frame;
//创建导航按钮
-(void)addItem:(NSString *)title position:(itemb)position image:(NSString *)image action:(SEL)action;
-(void)additems:(NSString *)title position:(itemb)position image:(NSString *)image action:(SEL)action;
- (id)initWithMemberId:(NSString *)MemberId andTitle:(NSString * )title;
@end
