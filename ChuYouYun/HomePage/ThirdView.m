//
//  ThirdView.m
//  dafengche
//
//  Created by IOS on 16/9/30.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "ThirdView.h"
#import "GLMemberTableViewCell.h"
#import "GLDiscountModel.h"
#import "FistDataModel.h"
#import "UIColor+HTMLColors.h"
#import "Passport.h"
#import "SYG.h"
#import "InstitutionMainViewController.h"


@interface ThirdView ()<UITableViewDataSource,UITableViewDelegate>
{
    
    CGRect _frame;
    NSMutableArray *_dataArr;
    UILabel *_lable;

}
@property (strong, nonatomic) UITableView *tableView;
@property (atomic, strong) NSMutableArray *downloadObjectArr;

@property (strong ,nonatomic)UIImageView *imageView;

@end

@implementation ThirdView

- (void)resetViewWithEntity:(NSDictionary *)entity
{
    _dataArr = [[NSMutableArray alloc]init];
    [_dataArr addObjectsFromArray:entity[@"data"]];
    
    NSLog(@"%@",_dataArr);
    if (_dataArr.count) {
        _lable.textColor = [UIColor clearColor];
        _imageView.hidden = YES;
        
    }else{
        _lable.textColor = [UIColor grayColor];
        _imageView.hidden = NO;
        if (!_imageView.image) {
            //添加空白处理
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 64 - 48)];
            imageView.image = [UIImage imageNamed:@"会员（空白）"];
            [_tableView addSubview:imageView];
            _imageView = imageView;
        }

        
    }
    [_tableView reloadData];
    NSLog(@"%@",_dataArr);
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
    
    
    NSLog(@"%@",_dataArr);

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
    return 200;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLMemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMemberTableViewCell"];
    FistDataModel *fistmod;
    if (!cell) {        
        NSArray *cellArr = [[NSBundle mainBundle]loadNibNamed:@"GLMemberTableViewCell" owner:nil options:nil];
        cell = [cellArr objectAtIndex:0];
    }
    
    NSLog(@"%@",_dataArr);
   [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSString *dateStr = [NSString stringWithFormat:@"%@天",_dataArr[indexPath.section][@"vip_date"]];
    NSString *mioashuStr = _dataArr[indexPath.section][@"vip_grade_list"][@"title"];
    NSString *str = [NSString stringWithFormat:@"%@%@",dateStr,mioashuStr];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:str];
    UIColor *color = [UIColor colorWithHexString:@"#333333"];
    [attrString addAttribute:NSForegroundColorAttributeName value:color range:[str rangeOfString:mioashuStr]];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17]range:[str rangeOfString:mioashuStr]];
    [cell.firstLab setAttributedText:attrString];
    cell.aconImageV.image = [UIImage imageNamed:@"皇冠"];
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    cell.secondLab.text = [NSString stringWithFormat:@"卡卷编号：%@",_dataArr[indexPath.section][@"code"]];
    cell.thirdLab.text = [NSString stringWithFormat:@"发卡单位：%@",_dataArr[indexPath.section][@"school_title"]];
    

    NSString *starTime = [Passport glformatterDate:_dataArr[indexPath.section][@"stime"]];
    NSString *endTime = [Passport glformatterDate:_dataArr[indexPath.section][@"etime"]];
    cell.lastLab.text = [NSString stringWithFormat:@"%@ - %@",starTime,endTime];
    
    __weak typeof(self) weakSelf = self;
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
