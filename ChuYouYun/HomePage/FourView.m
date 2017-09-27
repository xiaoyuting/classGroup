//
//  FourView.m
//  dafengche
//
//  Created by IOS on 16/9/30.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "FourView.h"
#import "UIColor+HTMLColors.h"
#import "UIView+Utils.h"
#import "FistDataModel.h"
#import "Passport.h"
#import "SYG.h"
#import "DiscountViewController.h"
#import "InstitutionMainViewController.h"


@interface FourView ()<UITableViewDataSource,UITableViewDelegate>
{
    
    CGRect _frame;
    NSMutableArray *_dataArr;
    UILabel *_lable;


}
@property (strong, nonatomic) UITableView *tableView;
@property (atomic, strong) NSMutableArray *downloadObjectArr;

@property (strong ,nonatomic)UIImageView *imageView;



@end

@implementation FourView

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
            imageView.image = [UIImage imageNamed:@"打折卡（空白）"];
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
    _lable.textAlignment = NSTextAlignmentCenter;
    _lable.font = Font(15);
    _lable.textColor = [UIColor clearColor];
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
    if (MainScreenWidth>375) {
        return 320;
    }else
    return 300;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLSecondDiscountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLSecondDiscountTableViewCell"];
    
    if (!cell) {
        NSArray *cellArr = [[NSBundle mainBundle]loadNibNamed:@"GLSecondDiscountTableViewCell" owner:nil options:nil];
        cell = [cellArr objectAtIndex:0];
    }
    
    [cell.UseBtn.layer setBorderColor:[UIColor colorWithHexString:@"#e15a5a"].CGColor];

    [cell.UseBtn setTitleColor:[UIColor colorWithHexString:@"#e15a5a"] forState:UIControlStateNormal];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.cateGarryLab.textColor = [UIColor colorWithHexString:@"#BC3838"];
    cell.backLab.backgroundColor = [UIColor colorWithHexString:@"#fa9899"];
    cell.xiamianImg.image = [UIImage imageNamed:@"670-1.png"];
    cell.LimitTimelab.textColor = [UIColor colorWithHexString:@"#BC3838"];
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    NSString *starTime = [Passport glformatterDate:_dataArr[indexPath.section][@"stime"]];
    NSString *endTime = [Passport glformatterDate:_dataArr[indexPath.section][@"etime"]];
    cell.LimitTimelab.text = [NSString stringWithFormat:@"%@ - %@",starTime,endTime];
    //折扣
    NSString *discount = [NSString stringWithFormat:@"%@",_dataArr[indexPath.section][@"discount"]];
    int disco = [discount intValue];
    cell.HeaderTitleLab.text = [NSString stringWithFormat:@"%d折",disco];
    
    cell.FirstLab.text = [NSString stringWithFormat:@"机构：%@",_dataArr[indexPath.section][@"school_title"]];
    //存编号
    cell.secondLab.text = [NSString stringWithFormat:@"存编号：%@",_dataArr[indexPath.section][@"code"]];
    __weak typeof(self) weakSelf = self;
    
    //判断是否过期
    
    //获取当前时间
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
    
    NSLog(@"---%@",timeSp);
    if ([timeSp integerValue] < [_dataArr[indexPath.section][@"stime"] integerValue]) {//还没有开始
        cell.typeImageView.image = Image(@"GL61");
        
} else if ([timeSp integerValue] > [_dataArr[indexPath.section][@"etime"] integerValue]) {//已过期
        cell.typeImageView.image = Image(@"GL51");
    } else {//可以使用
        cell.typeImageView.image = Image(@"GL61");
    }
    
    
    
    // 下载按钮点击时候的要刷新列表
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
    // cell.fileInfo = fileInfo;
    // 下载的request
    return cell;
}
-(void)addDownLoadTaskAction:(NSIndexPath *)indexPath{
    




}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



@end
