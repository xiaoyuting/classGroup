//
//  FirstView.m
//  dafengche
//
//  Created by IOS on 16/9/30.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
#import "FirstView.h"
#import "GLDiscountTableViewCell.h"
#import "GLDiscountModel.h"
#import "FistDataModel.h"
#import "Passport.h"
#import "SYG.h"
#import "InstitutionMainViewController.h"
#import "DiscountViewController.h"


@interface FirstView ()<UITableViewDataSource,UITableViewDelegate>
{

    CGRect _frame;
    NSMutableArray *_dataArr;
    UILabel *_lable;
}
@property (strong, nonatomic) UITableView *tableView;
@property (atomic, strong) NSMutableArray *downloadObjectArr;

@property (strong ,nonatomic)UIImageView *imageView;

@end

@implementation FirstView


- (void)resetViewWithEntity:(NSDictionary *)entity
{
    NSLog(@"%@",entity);
    _dataArr = [[NSMutableArray alloc]init];
    [_dataArr addObjectsFromArray:entity[@"data"]];
    NSLog(@"=====%@",_dataArr);
    if (_dataArr.count) {
        
        _lable.textColor = [UIColor clearColor];
        _imageView.hidden = YES;

    }else{
        
        _lable.textColor = [UIColor clearColor];
        _imageView.hidden = NO;
        
        if (!_imageView.image) {
            //添加空白处理
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 64 - 48)];
            imageView.image = [UIImage imageNamed:@"优惠券（空白）"];
            [_tableView addSubview:imageView];
            _imageView = imageView;
        }
    }
    
    [_tableView reloadData];
    //self.titleLab.text = entity[@"title"];
    //self.lab.text = entity[@"title"];//界面可变的部分的渲染尽量通过数据源来控制
}
-(instancetype)initWithFrame:(CGRect)frame{
    
self = [super initWithFrame:frame];
    
    if (self) {
        
        _frame = frame;
        _frame.origin.x = 0;
        [self initUI];
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];

    }
    return self;
}

- (void)initUI
{
    _lable = [[UILabel alloc]initWithFrame:CGRectMake(0,_frame.origin.y + 50, MainScreenWidth, 30)];
    _lable.text = @"您还没有此优惠券";
    [self addSubview:_lable ];
    _lable.textColor = [UIColor clearColor];
    _lable.textAlignment = NSTextAlignmentCenter;
    _lable.font = Font(15);
    
    _tableView = [[UITableView alloc]initWithFrame:_frame style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self addSubview: _tableView];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
}
#pragma mark ---

////头部视图
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
    GLDiscountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLDiscountTableViewCell"];
    FistDataModel *fistmod;
      //  if (!cell) {
            cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
            cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"12345123"]];// 套用自己的圖片做為背景
            NSArray *cellArr = [[NSBundle mainBundle]loadNibNamed:@"GLDiscountTableViewCell" owner:nil options:nil];
            cell = [cellArr objectAtIndex:0];
            cell.Money.font = [UIFont systemFontOfSize:30];
            cell.Money.text = @"¥";
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.MoneyLab.text = [NSString stringWithFormat:@"   %@",_dataArr[indexPath.section][@"price"]];
            cell.firstLab.text = [NSString stringWithFormat:@"满%@立减",_dataArr[indexPath.section][@"maxprice"]];
    cell.SecondLab.text = [NSString stringWithFormat:@"仅%@可用",_dataArr[indexPath.section][@"school_title"]];
    NSString *starTime = [Passport glformatterDate:_dataArr[indexPath.section][@"stime"]];
    NSString *endTime = [Passport glformatterDate:_dataArr[indexPath.section][@"etime"]];


            cell.ThirdLab.text = [NSString stringWithFormat:@"%@ - %@",starTime,endTime];
            NSString *status = [NSString stringWithFormat:@"%@",_dataArr[indexPath.section][fistmod.status]];
            if ([status isEqualToString:@"1"]) {
                //已使用
                cell.UseBtn.backgroundColor = [UIColor grayColor];
                cell.UseBtn.alpha = 0.6;
                cell.UseBtn.enabled = NO;
                
            }else{
            
            }
      //  }
        __weak typeof(self) weakSelf = self;
    
    /*
     InstitutionMainViewController*instVc = [[InstitutionMainViewController alloc] init];
     instVc.schoolID =  [NSString stringWithFormat:@"%@",dict[@"school_info"][@"school_id"]];
     instVc.uID = [NSString stringWithFormat:@"%@",dict[@"school_info"][@"uid"]];
     [self.navigationController pushViewController:instVc animated:YES];
     
     */
        // 下载按钮点击时候的要刷新列表
        cell.btnClickBlock = ^{
            NSLog(@"000000000");
            NSLog(@"--%@",_dataArr[indexPath.section][@"sid"]);
            NSLog(@"==%@",_dataArr[indexPath.section][@"uid"]);
            //[weakSelf initData];InstitutionMainViewController.h

            id object = [self nextResponder];
            while (![object isKindOfClass:[UIViewController class]] && object != nil) {
                object = [object nextResponder];
            }
            UIViewController *superController = (UIViewController *)object;
            /**
             *  这里声明所要push的页面（Mycontroller）
             */
            InstitutionMainViewController *instVc = [[InstitutionMainViewController alloc] init];
            instVc.schoolID =  [NSString stringWithFormat:@"%@",_dataArr[indexPath.section][@"sid"]];
            instVc.uID = [NSString stringWithFormat:@"%@",_dataArr[indexPath.section][@"uid"]];
            [superController.navigationController pushViewController:instVc animated:YES];
            
        };
        // 下载模型赋值
       // cell.fileInfo = fileInfo;
        // 下载的request
        return cell;
}


-(void)addDownLoadTaskAction:(NSIndexPath *)indexPath{
    
    NSLog(@"%@",@"123456");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



@end
