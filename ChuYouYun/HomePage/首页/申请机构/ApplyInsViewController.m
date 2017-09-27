//
//  ApplyInsViewController.m
//  dafengche
//
//  Created by 智艺创想 on 16/11/2.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//  申请机构

#import "ApplyInsViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "ZhiyiHTTPRequest.h"
#import "MBProgressHUD+Add.h"
#import "PopView.h"
#import "PhotosView.h"
#import "SubjectView.h"



@interface ApplyInsViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>
{
    UIImage *image;
}

@property (strong ,nonatomic)UIScrollView *scrollView;

@property (strong ,nonatomic)UITextField *textField0;
@property (strong ,nonatomic)UITextField *textField1;
@property (strong ,nonatomic)UITextField *textField2;
@property (strong ,nonatomic)UITextField *textField3;
@property (strong ,nonatomic)UITextField *textField4;
@property (strong ,nonatomic)UITextField *textField5;
@property (strong ,nonatomic)UITextField *textField6;
@property (strong ,nonatomic)UITextField *textField7;
@property (strong ,nonatomic)UITextField *textField8;
@property (strong ,nonatomic)UITextView  *textView8;
@property (strong ,nonatomic)UITextField *textField9;
@property (strong ,nonatomic)UITextField *textField10;
@property (strong ,nonatomic)UILabel     *cateLabel;

@property (strong ,nonatomic)UIButton    *logoButton;
@property (strong ,nonatomic)UIButton    *imageButton;
@property (assign ,nonatomic)NSInteger   buttonType;

@property (strong ,nonatomic)UIImageView *logoImageView;
@property (strong ,nonatomic)UIImageView *imageImageView;
@property (strong ,nonatomic)UIScrollView *imageScrollView;
@property (strong ,nonatomic)NSMutableArray *imageArray;
@property (strong ,nonatomic)NSMutableArray *imageIDArray;
@property (strong ,nonatomic)UIButton    *applyButton;

@property (strong ,nonatomic)NSString    *logoImageID;
@property (strong ,nonatomic)NSString    *imageImageID;
@property (strong ,nonatomic)NSString    *cateID;
@property (strong ,nonatomic)NSString    *adjunctID;//附件id

@end

@implementation ApplyInsViewController

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNSNotification];
    [self interFace];
    [self addNav];
    [self addScrollView];
    [self addInfoView];
    
    
}

- (void)addNSNotification {
    //接受通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCateInfo:) name:@"SearchCateInfo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textView:) name:UITextViewTextDidChangeNotification object:nil];
}


- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
    _imageArray = [NSMutableArray array];
    _imageIDArray = [NSMutableArray array];
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"通用返回"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 60, 30)];
    WZLabel.text = @"申请机构";
    [WZLabel setTextColor:BasidColor];
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
    
    //添加横线
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 63, MainScreenWidth, 1)];
    button.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [SYGView addSubview:button];
    
}

- (void)addScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight + 200)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(MainScreenWidth, MainScreenHeight + 300);
    [self.view addSubview:_scrollView];
    
}

- (void)addInfoView {
    
    CGFloat ViewW = MainScreenWidth - 2 *SpaceBaside;
    CGFloat ViewH = 40;
    
    NSArray *textArray = @[@"云课堂账号:",@"机构logo:",@"机构的封面",@"选机构分类:",@"机构名称:",@"法人身份证:",@"联系电话:",@"机构地址:",@"认证理由:",@"认证附件:"];
    
    for (int i = 0 ; i < 10; i ++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside + (ViewH + SpaceBaside) * i, ViewW, ViewH)];
        
        if (i == 1) {
            view.frame = CGRectMake(SpaceBaside, SpaceBaside + (ViewH + SpaceBaside) * i, ViewW, ViewH * 2);
            
        } else if (i == 2) {
            view.frame = CGRectMake(SpaceBaside, SpaceBaside + (ViewH + SpaceBaside) * (i + 1), ViewW, ViewH * 2);
            
         } else if (i > 2 && i < 8){
            view.frame = CGRectMake(SpaceBaside, SpaceBaside + (ViewH + SpaceBaside) * (i +  2), ViewW, ViewH);
        } else if (i == 0) {
            
        } else if (i == 8) {
            view.frame = CGRectMake(SpaceBaside, SpaceBaside + (ViewH + SpaceBaside) * (i +  2), ViewW, ViewH * 2);
        } else if (i == 9) {
              view.frame = CGRectMake(SpaceBaside, SpaceBaside + (ViewH + SpaceBaside) * (i +  3), ViewW, ViewH * 4);
        }
        

        view.layer.cornerRadius = 5;
        view.layer.borderWidth = 1;
        view.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        [_scrollView addSubview:view];
        
        //添加文本
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, 0, 80, ViewH)];
        textLabel.text = textArray[i];
        textLabel.font = Font(14);
        textLabel.textColor = [UIColor grayColor];
        [view addSubview:textLabel];
 
        //添加输入框
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(90, 0, MainScreenWidth - 100 - 20,ViewH)];
        textField.backgroundColor = [UIColor whiteColor];
        [view addSubview:textField];
        
        //textField 赋值
        switch (i) {
            case 0:
                _textField0 = textField;
                _textField0.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"WDC"];
                _textField0.textColor = [UIColor grayColor];
                _textField0.font = Font(16);
                break;
            case 1:
                _textField1 = textField;
                break;
            case 2:
                _textField2 = textField;
                break;
            case 3:
                _textField3 = textField;
                break;
            case 4:
                _textField4 = textField;
                break;
            case 5:
                _textField5 = textField;
                break;
            case 6:
                _textField6 = textField;
                break;
            case 7:
                _textField7 = textField;
                break;
            case 8:
                _textField8 = textField;
//                _textField8.frame = CGRectMake(90, 0, MainScreenWidth - 100 - 20,ViewH * 2);
                _textView8 = [[UITextView alloc] initWithFrame:CGRectMake(90, 5, MainScreenWidth - 120, ViewH * 2)];
                [view addSubview:_textView8];
                break;
            case 9:
                _textField9 = textField;
                break;
            default:
                break;
        }
        
        
        
        
        if (i == 1) {
            
            //添加添加按钮
            _logoButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 20 - 70, 10, 50, 50)];
            [_logoButton setBackgroundImage:Image(@"选择图片") forState:UIControlStateNormal];
            [view addSubview:_logoButton];
            [_logoButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            _logoButton.tag = 1000;
            [textField removeFromSuperview];
            
            _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, SpaceBaside / 2, 70, 70)];
            _logoImageView.backgroundColor = [UIColor whiteColor];
            [view addSubview:_logoImageView];
            
            
        } else if (i == 2) {
           _imageButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 20 - 70, 10, 50, 50)];
            [_imageButton setBackgroundImage:Image(@"选择图片") forState:UIControlStateNormal];
            [view addSubview:_imageButton];
            _imageButton.tag = 2000;
            [_imageButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [textField removeFromSuperview];
            
            _imageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, SpaceBaside / 2, 70, 70)];
            _imageImageView.backgroundColor = [UIColor whiteColor];
            [view addSubview:_imageImageView];

        }
        
        
        if (i == 3) {
            
            //添加银行
            _cateLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, MainScreenWidth - 2 * SpaceBaside - 40, ViewH)];
            _cateLabel.text = @"请选择机构分类";
            _cateLabel.font = Font(14);
            [view addSubview:_cateLabel];
            
            UIButton *downButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 2 * SpaceBaside - 40, 0,40, 40)];
            [downButton setImage:Image(@"灰色乡下@2x") forState:UIControlStateNormal];
            [downButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            downButton.tag = 3000;
            [view addSubview:downButton];
            [textField removeFromSuperview];

            
        }
        
        //往上面添加东西
        if (i == 9) {//认证附件
            UIButton *adjunctButton = [[UIButton alloc] initWithFrame:CGRectMake(120, SpaceBaside / 2, 80, 30)];
            [adjunctButton setTitle:@"选中附件" forState:UIControlStateNormal];
            adjunctButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
            adjunctButton.layer.borderWidth = 1;
            adjunctButton.layer.cornerRadius = 3;
            adjunctButton.titleLabel.font = Font(15);
            adjunctButton.layer.borderColor = [UIColor grayColor].CGColor;
            [adjunctButton setTitleColor:BlackNotColor forState:UIControlStateNormal];
            adjunctButton.tag = 4000;
            [adjunctButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:adjunctButton];
            
            
            //添加文本
            UILabel *adjunLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 35, MainScreenWidth - 120 - 2 * SpaceBaside, 40)];
            adjunLabel.text = @"申请独立财务账户需提交以下材料:营业执照、税务登记证、组织机构代码、对公账号相关信息";
            adjunLabel.textColor = [UIColor grayColor];
            adjunLabel.font = Font(10);
            adjunLabel.numberOfLines = 3;
            [view addSubview:adjunLabel];
            
            [textField removeFromSuperview];
            
            //添加滚动试图
            _imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 90, MainScreenWidth - 2 * SpaceBaside, 60)];
            _imageScrollView.backgroundColor = [UIColor whiteColor];
            _imageScrollView.contentSize = CGSizeMake(MainScreenWidth * 2, 60);
            [view addSubview:_imageScrollView];
        }
    }
    
    
    //添加立即申请的按钮
    
    CGFloat applyButtonY = SpaceBaside + (SpaceBaside + ViewH) * 15 + 2 * ViewH;
    
    _applyButton = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside, applyButtonY, MainScreenWidth - 2 * SpaceBaside, ViewH + SpaceBaside)];
    [_applyButton setTitle:@"立即申请" forState:UIControlStateNormal];
    _applyButton.backgroundColor = BasidColor;
    _applyButton.layer.cornerRadius = 5;
    [_applyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_applyButton addTarget:self action:@selector(applyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_applyButton];
    
    _scrollView.contentSize = CGSizeMake(MainScreenWidth, CGRectGetMaxY(_applyButton.frame) + 350);
 
}


- (void)howManyImage {//这里来设置图片
    
    CGFloat imageViewW = 60;
    for (int i = 0 ; i < _imageArray.count ; i ++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SpaceBaside + (imageViewW + SpaceBaside) * i, 0, 60, 60)];
        imageView.image = _imageArray[i];
        [_imageScrollView addSubview:imageView];
        _imageScrollView.contentSize = CGSizeMake(i * (60 + SpaceBaside) + 100, 60);
    }
    
}

#pragma mark --- 通知
- (void)getCateInfo:(NSNotification *)Not {
    
    _cateLabel.text = Not.userInfo[@"title"];
    _cateID = Not.userInfo[@"id"];
}

- (void)textView:(NSNotification *)not {
    
    if (_textView8.text.length > 50) {
        _textView8.text = [_textView8.text substringToIndex:50];
        [MBProgressHUD showError:@"内容不能过长" toView:self.view];
        return;
    } else {
        
    }
    
}

#pragma mark --- 滚动试图
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}


#pragma mark -- 事件监听
- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)addButton {
    
}


- (void)getWhichBank {
//    PopView *popView = [[PopView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
//    [self.view addSubview:popView];
    SubjectView *subjectView = [[SubjectView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    [self.view addSubview:subjectView];
}

- (void)adjunctButtonClick {
    
    
}

- (void)applyButtonClick {
    [self netWorkInstitutionApply];
}

#pragma mark --- UISheet 

- (void)addButtonClick:(UIButton *)button {
    
    if (button.tag == 3000) {
        [self getWhichBank];
        return;
    }
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相册里选" otherButtonTitles:@"相机拍照", nil];
    action.delegate = self;
    [action showInView:self.view];
    
    _buttonType = button.tag;
    
}


#pragma mark --- ActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0){//进入相册
        //创建图片选取控制器
        UIImagePickerController * imagePickerVC =[[UIImagePickerController alloc]init];
        [imagePickerVC setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [imagePickerVC setAllowsEditing:YES];
        imagePickerVC.delegate=self;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
 
    }else if (buttonIndex == 1){//相机拍照
        
        UIImagePickerController * imagePickerVC =[[UIImagePickerController alloc]init];
        [imagePickerVC setSourceType:UIImagePickerControllerSourceTypeCamera];
        [imagePickerVC setAllowsEditing:YES];
        imagePickerVC.delegate=self;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }
}

//回调方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    image = [info valueForKey:@"UIImagePickerControllerEditedImage"];
    
    if (_buttonType == 1000) {//logo
        _logoImageView.image = image;
    } else if (_buttonType == 2000) {
        _imageImageView.image = image;
    } else if (_buttonType == 4000) {//附件
        [_imageArray addObject:image];
        [self howManyImage];
        [self NetWorkGetManyImageID];
        return;
    }

    [self netWorkImageID];
}

#pragma mark ---键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


#pragma mark --- 网络请求

//机构申请
- (void)netWorkInstitutionApply {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    
    if (_textField4.text.length == 0) {
        [MBProgressHUD showError:@"机构名称不能为空" toView:self.view];
        return;
    } else {
        [dic setObject:_textField4.text forKey:@"title"];
    }

    if (_logoImageID == nil) {
        [MBProgressHUD showError:@"请上传机构logo" toView:self.view];
        return;
    } else {
        [dic setObject:_logoImageID forKey:@"logo_id"];
    }

    if (_imageImageID == nil) {
        [MBProgressHUD showError:@"请上传机构封面" toView:self.view];
        return;
    } else {
        [dic setObject:_imageImageID forKey:@"cover_id"];
    }

    if (_cateID == nil) {
        [MBProgressHUD showError:@"请选择机构类型" toView:self.view];
        return;
    } else {
        [dic setObject:_cateID forKey:@"cate_id"];
    }

    if (_textField0.text.length == 0) {
        [MBProgressHUD showError:@"请填写认证理由" toView:self.view];
        return;
    } else {
        [dic setObject:_textField0.text forKey:@"info"];
    }

    if (_textField6.text.length == 0) {
        [MBProgressHUD showError:@"请填写电话" toView:self.view];
        return;
    } else {
        [dic setObject:_textField6.text forKey:@"phone"];
    }

    
    if (_textField5.text.length == 0) {
        [MBProgressHUD showError:@"请填写身份证" toView:self.view];
        return;
    } else {
        [dic setObject:_textField5.text forKey:@"idcard"];
    }
    if (_adjunctID) {
         [dic setObject:_adjunctID forKey:@"attach_id"];//机构附件id
    } else {
        [MBProgressHUD showError:@"请添加附件" toView:self.view];
        return;
    }
    if (_textView8.text.length > 0) {
        [dic setObject:_textView8.text forKey:@"reason"];
    } else {
        [MBProgressHUD showError:@"请填写认证理由" toView:self.view];
        return;
    }
    if (_textField7.text.length > 0) {
        [dic setObject:_textField7.text forKey:@"address"];
    } else {
        [MBProgressHUD showError:@"请填写地址" toView:self.view];
        return;
    }
    
    [manager BigWinCar_GetSchoolApply:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"----%@",responseObject);
        NSString *msg = responseObject[@"msg"];
        if ([responseObject[@"code"] integerValue] == 1) {
            [MBProgressHUD showError:@"申请成功，请等待审核" toView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        } else {
            [MBProgressHUD showError:msg toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
}

//给到图片的ID
- (void)netWorkImageID {
    
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@",basidUrl,@"app=api&mod=Exam&act=addAttach"];
    [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSData *dataImg=UIImageJPEGRepresentation(image, 0.5);
        [formData appendPartWithFileData:dataImg name:@"face" fileName:@"image.png" mimeType:@"image/jpeg"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSLog(@"%@",responseObject[@"data"]);
        if ([responseObject[@"code"] integerValue] == 1) {
            
            if (_buttonType == 1000) {
                _logoImageID = responseObject[@"data"][0];
            } else if (_buttonType ==  2000) {
                _imageImageID = responseObject[@"data"][0];
            } else if (_buttonType == 4000) {//附件
               
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [MBProgressHUD showError:@"上传图片失败" toView:self.view];
    }];
}


//获得附件图片的ID
- (void)NetWorkGetManyImageID {
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",basidUrl,@"app=api&mod=Exam&act=addAttach"];
    [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        //上传图片
        NSMutableArray *images = [NSMutableArray arrayWithArray:_imageArray];
        
        if (images.count != 0) {
            for (UIImage *imgae in images) {
                NSData *dataImg=UIImageJPEGRepresentation(imgae, 0.5);
                [formData appendPartWithFileData:dataImg name:@"face" fileName:@"image.png" mimeType:@"image/jpeg"];
            }
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSLog(@"%@",responseObject[@"data"]);
        if ([responseObject[@"code"] isEqual:[NSNumber numberWithInteger:1]]) {
            [_imageIDArray addObject:responseObject[@"data"][0]];
            _adjunctID = responseObject[@"data"][0];
            [self howManyImage];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}



@end
