//
//  salesClassVC.m
//  ChuYouYun
//
//  Created by zhiyicx on 15/1/26.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "salesClassVC.h"
#import "MyHttpRequest.h"
#import "teacherList.h"
#import "classTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "classDetailVC.h"
#import "XLClassTool.h"
#import "SYGClassTableViewCell.h"
#import "UIButton+WebCache.h"
#import "UIColor+HTMLColors.h"
#import "ClassRevampCell.h"


#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))
@interface salesClassVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
    UILabel *_lable;
}
@property(nonatomic,assign)NSInteger numder;
@end

@implementation salesClassVC

- (id)initWithNumberId:(NSString *)numberId
{
    if (self==[super init]) {
        _cateory_id=numberId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-150 + 15 + 5 + 5) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 110;
    _tableView.showsVerticalScrollIndicator =
    NO;
    _lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 100,MainScreenWidth, 15)];
    [_tableView addSubview:_lable];
    [_tableView insertSubview:_lable atIndex:0];
    _lable.text = @"数据为空，刷新重试";
    _lable.textAlignment = NSTextAlignmentCenter;
    _lable.font = [UIFont systemFontOfSize:14];
    _lable.textColor = [UIColor clearColor];
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    //下拉刷新
    [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshing)];
    [_tableView headerBeginRefreshing];
    
    //上拉加载
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,5,0,0)];
    }
    
    //设置表格分割线的长度（跟两边的距离）
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,2,0,0)];
    }

}

- (void)headerRerefreshing
{
    [self requestData:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
        if (_dataArray.count==0) {
            _lable.textColor = [UIColor colorWithHexString:@"#dedede"];
            
        }else{
            _lable.textColor = [UIColor clearColor];
        }

    });
    
}

- (void)footerRefreshing
{
    _numder++;
    [self requestData:_numder];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView footerEndRefreshing];
    });
    
}

- (void)refreshHeader
{
    [_tableView headerBeginRefreshing];
}


-(void)requestData:(NSInteger)num
{
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    
    [dic setValue:[NSNumber numberWithInteger:num] forKey:@"page"];
    [dic setValue:@"6" forKey:@"count"];
    [dic setValue:@"saledesc" forKey:@"orderBy"];
    [dic setValue:_num forKey:@"pType"];
    [dic setValue:_cateory_id forKey:@"cateId"];
    
    //尝试从数据库里面取出数据
    NSArray *XLArray = [XLClassTool classWithDic:dic];
    
    [manager getClass:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"%@",responseObject);
        

        NSLog(@"%@",operation);

        if (!XLArray.count) {
             [XLClassTool saveClasses:responseObject[@"data"]];
        }
        
        NSMutableArray * array = [responseObject objectForKey:@"data"];
        if(IsNilOrNull(array))
        {
            
            UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, MainScreenWidth, 50)];
            hintLabel.textAlignment = NSTextAlignmentCenter;
            hintLabel.text = @"没有课程";
            hintLabel.font = [UIFont systemFontOfSize:24];
            hintLabel.textColor = [UIColor purpleColor];
            [self.view addSubview:hintLabel];
            
            
        }
        else{
            //                NSMutableArray * listArr = [[NSMutableArray alloc]initWithCapacity:0];
            //                for (int i=0; i<array.count; i++) {
            //                    teacherList * list = [[teacherList alloc]initWithDictionarys:array[i]];
            //                    [listArr addObject:list];
            //                }
            NSArray *listArr = responseObject[@"data"];
            if(num==1)
            {
                _dataArray = [NSMutableArray arrayWithArray:listArr];
            }
            else
            {
                NSArray * arr = [NSArray arrayWithArray:listArr];
                [_dataArray addObjectsFromArray:arr];
            }
            [_tableView reloadData];
        }
        //            _dataArray = responseObject[@"data"];
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        _dataArray = XLArray;
        [_tableView reloadData];
    }];

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellStr = @"SYGClassTableViewCell";
    SYGClassTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[SYGClassTableViewCell alloc] initWithReuseIdentifier:cellStr];
    }
    NSLog(@"%@",_dataArray);
    
    [cell.imageButton setBackgroundImage:[UIImage imageNamed:@"站位图"] forState:UIControlStateNormal];
    [cell.imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:_dataArray[indexPath.row][@"imageurl"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"站位图"]];
    
    cell.titleLabel.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"video_title"]];
    cell.contentLabel.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"video_intro"]];
    cell.GKLabel.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"video_order_count"]];
    cell.XBLabel.text = [NSString stringWithFormat:@"%@元",_dataArray[indexPath.row][@"price"]];
    
    NSString *MoneyStr = [NSString stringWithFormat:@"%@元",_dataArray[indexPath.row][@"price"]];
    NSString *XBStr = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"price"]];
    //变颜色
    NSMutableAttributedString *needStr = [[NSMutableAttributedString alloc] initWithString:MoneyStr];
    [needStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1] range:NSMakeRange(0, XBStr.length)];
    [cell.XBLabel setAttributedText:needStr] ;
    
    NSString * starStr = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"video_score"]];
    float length = [starStr floatValue];
    
    if (length == 1) {
        
        [cell.XJButton setBackgroundImage:[UIImage imageNamed:@"101@2x"] forState:UIControlStateNormal];
    }
    
    if (length == 2) {
        [cell.XJButton setBackgroundImage:[UIImage imageNamed:@"102@2x"] forState:UIControlStateNormal];
    }else {
        
        [cell.XJButton setBackgroundImage:[UIImage imageNamed:@"100@2x"] forState:UIControlStateNormal];
    }
    
    if (length == 3) {
        
        [cell.XJButton setBackgroundImage:[UIImage imageNamed:@"103@2x"] forState:UIControlStateNormal];
    }
    
    if (length == 4) {
        
        [cell.XJButton setBackgroundImage:[UIImage imageNamed:@"104@2x"] forState:UIControlStateNormal];
    }
    
    if (length == 5) {
        
        [cell.XJButton setBackgroundImage:[UIImage imageNamed:@"105@2x"] forState:UIControlStateNormal];
    }


    
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString *Cid = _dataArray[indexPath.row][@"id"];
    NSString *Price = _dataArray[indexPath.row][@"price"];
    NSString *Title = _dataArray[indexPath.row][@"video_title"];
    NSString *VideoAddress = _dataArray[indexPath.row][@"video_address"];
    NSString *ImageUrl = _dataArray[indexPath.row][@"imageurl"];
    
    classDetailVC * cvc = [[classDetailVC alloc]initWithMemberId:Cid andPrice:Price andTitle:Title];
    cvc.videoTitle = Title;
    cvc.img = ImageUrl;
    cvc.video_address = VideoAddress;
    [self.navigationController pushViewController:cvc animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
