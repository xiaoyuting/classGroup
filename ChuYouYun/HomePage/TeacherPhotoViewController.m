//
//  TeacherPhotoViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/5/15.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "TeacherPhotoViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+Add.h"
#import "MyHttpRequest.h"
#import "ZhiyiHTTPRequest.h"
#import "Passport.h"

#import "XCVideoViewController.h"
#import "XCDetilViewController.h"




@interface TeacherPhotoViewController ()

@property (strong ,nonatomic)NSString *ID;
@property (strong ,nonatomic)NSArray  *photoArray;

@end

@implementation TeacherPhotoViewController

-(instancetype)initWithNumID:(NSString *)ID{
    
    self = [super init];
    if (self) {
        _ID = ID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self netWorkPhoto];
}


- (void)interFace {
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)addPhotoView {
    
    for (int i = 0; i< _photoArray.count; i++) {
        
        NSInteger Num = 3;
        CGFloat viewW = (MainScreenWidth - SpaceBaside * (Num + 1)) / Num;
        CGFloat viewH = viewW * 1.2;
        
        UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(SpaceBaside + SpaceBaside * i + viewW * i + (i / Num) * SpaceBaside,40, viewW, viewH)];
        if (iPhone5o5Co5S) {
            buttonView.frame = CGRectMake(SpaceBaside + SpaceBaside * i + viewW * i + (i / Num) * SpaceBaside,40, viewW, 120);
        }
        buttonView.layer.cornerRadius = 5;
        buttonView.layer.masksToBounds = YES;
        buttonView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        buttonView.layer.borderWidth = 2;
        buttonView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:buttonView];
        
        
        //在View 上面添加东西
        UIImageView *buttonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewW, viewH  - 50)];
        NSString *urlStr = _photoArray[i][@"cover"];
        [buttonImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
        [buttonView addSubview:buttonImageView];
        
        //添加介绍
        UILabel *nameButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside,viewW - 20, viewW - 2 * SpaceBaside, 50)];
        nameButtonLabel.text = _photoArray[i][@"title"];
        nameButtonLabel.numberOfLines = 2;
        nameButtonLabel.font = Font(14);
        nameButtonLabel.textColor = BlackNotColor;
        [buttonView addSubview:nameButtonLabel];
        
        //往View 上面添加button
        UIButton *viewButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(buttonView.frame), CGRectGetHeight(buttonView.frame))];
        viewButton.backgroundColor = [UIColor clearColor];
        viewButton.tag = i;
        [viewButton addTarget:self action:@selector(photoButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        [buttonView addSubview:viewButton];
        
    }
    
    
    if (_photoArray.count == 0) {
        //添加空白提示
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 200, 200)];
        imageView.image = Image(@"更改背景图片.png");
        imageView.center = CGPointMake(MainScreenWidth / 2 , 300);
        if (iPhone6) {
            imageView.center = CGPointMake(MainScreenWidth / 2 , 220);
        } else if (iPhone6Plus) {
            imageView.center = CGPointMake(MainScreenWidth / 2 , 280);
        } else if (iPhone5o5Co5S) {
            imageView.center = CGPointMake(MainScreenWidth / 2 , 190);
        }
        [self.view addSubview:imageView];
    }

}

#pragma mark ---- 事件坚挺
- (void)photoButtonCilck:(UIButton *)button {
    
    NSInteger num = button.tag;
    
    //去视频
    if (button.selected == YES) {
        NSLog(@"_____%@--%ld",_ID,num);
        
        NSString *video_id = [NSString stringWithFormat:@"%@",_photoArray[num][@"id"]];
        XCVideoViewController *xcdV = [[XCVideoViewController alloc]initwithvideo_id:[video_id integerValue]name:[NSString stringWithFormat:@"%@",_photoArray[num][@"title"]] teacher_id:_ID];
        [self.navigationController pushViewController:xcdV animated:YES];
        return;
    }
    //去相册
    NSString *photo_id = [NSString stringWithFormat:@"%@",_photoArray[num][@"id"]];
    
    NSLog(@"%@",photo_id);
    XCDetilViewController *xcdV = [[XCDetilViewController alloc]initwithphoto_id:[photo_id integerValue]name:[NSString stringWithFormat:@"%@",_photoArray[num][@"title"]] teacher_id:_ID];
    [self.navigationController pushViewController:xcdV animated:YES];
    
}


#pragma mark ---- 网络请求

//获取相册数据
-(void)netWorkPhoto {
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    //临时的
    [dic setValue:_ID forKey:@"teacher_id"];
    [dic setValue:@"1" forKey:@"page"];
    [dic setValue:@"20" forKey:@"count"];
    _photoArray = [NSMutableArray array];
    [manager getpublicPort:dic mod:@"Teacher" act:@"getTeacherPhotos" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"相册-----%@",responseObject);
        if ([responseObject[@"code"] integerValue] == 1) {
            _photoArray = responseObject[@"data"];
            
            NSMutableArray *marr = [NSMutableArray array];
            for (int i = 0; i<_photoArray.count; i++) {
                if ([_photoArray[i][@"cover"] length]) {
                    [marr addObject:_photoArray[i][@"cover"]];
                }
            }
        }
        [self addPhotoView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self addPhotoView];
    }];
}




@end
