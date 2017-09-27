//
//  classDetailMessageVC.m
//  ChuYouYun
//
//  Created by zhiyicx on 15/1/30.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "classDetailMessageVC.h"
#import "classNameCell.h"
#import "classInroCell.h"
#import "teacherCell.h"
#import "blumAndTagCell.h"
#import "MyHttpRequest.h"
#import "teacherList.h"
#import "UIImageView+WebCache.h"
#import "SYGPFTableViewCell.h"
#import "SYGKCJJTableViewCell.h"
#import "SYGXQTeacherTableViewCell.h"
#import "UIButton+WebCache.h"
#import "SYG.h"
#import "UIColor+HTMLColors.h"
#import "MBProgressHUD+Add.h"

#import "ClassContentCell.h"

#import "classDetailZeroCell.h"
#import "ClassDetailOneCell.h"
#import "ClassDetailTeacherCell.h"
#import "ClassDetailInstCell.h"
#import "ClassDetailRecommendCell.h"
#import "ClassTerraceCell.h"

#import "classDetailVC.h"
#import "TeacherDetilViewController.h"
#import "InstitutionMainViewController.h"
#import "ClsaaRnownCell.h"




#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#define iPhone4SOriPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)//iphone4,4s屏幕

#define iPhone5o5Co5S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)//iphone5/5c/5s屏幕


#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6屏幕

#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6plus屏幕

#define iPhone6PlusBIG ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6plus放大版屏幕

@interface classDetailMessageVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
    NSArray * array1;
    NSString * strId;
    UILabel *_lable;

    
}

@property (strong ,nonatomic)NSArray *aboutArray;

@end

@implementation classDetailMessageVC

- (id)initWithId:(NSString *)Id andStudyB:(NSString *)studyb andTitle:(NSString *)title
{
    if (self=[super init]) {
        _course_id = Id;
        _course_title = title;
        _studyB = studyb;
    }
    return self;
}


static NSString * cellStr = @"cell";
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    if (iPhone4SOriPhone4) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-290+145 - 200 - 3 + 15) style:UITableViewStylePlain];
    }
    if (iPhone5o5Co5S) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-300+145 - 200 - 3 + 15) style:UITableViewStylePlain];
    }
    else if (iPhone6)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-380+145 - 200 - 3 + 6) style:UITableViewStylePlain];
    }
    else if (iPhone6Plus)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-430+145 - 200 - 3 + 8) style:UITableViewStylePlain];
    }else {//ipad 适配
        
         _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    }
//    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];

    _tableView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.bounces = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_tableView];
    _lable= [[UILabel alloc]initWithFrame:CGRectMake(0,50*MainScreenHeight/667,MainScreenWidth, 12)];
    [_tableView insertSubview:_lable atIndex:0];
    _lable.text = @"数据为空，刷新重试";
    _lable.hidden = YES;
    _lable.textAlignment = NSTextAlignmentCenter;
    _lable.textColor = [UIColor colorWithHexString:@"#dedede"];
    _lable.font = [UIFont systemFontOfSize:14];
    [_tableView insertSubview:_lable atIndex:0];
    [self requestData];
}



- (NSDictionary *)ReadResorce:(NSString *)_courseID {
    
    NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
#pragma mark - 保存为dic.plist
    //获取完整路径
    NSString *plistPath = [libPath stringByAppendingPathComponent:@"ClassDetali.pilst"];
    NSDictionary *Dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSLog(@"%@",Dic);
    NSArray *keyA = [Dic allKeys];
    for (NSString *key in keyA) {
        if ([key isEqualToString:_course_id]) {//说明有数据
            return Dic[_course_id];
        }
    }
    return nil;
}


- (NSDictionary *)ReadResorce2:(NSString *)_courseID {
    
    NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
#pragma mark - 保存为dic.plist
    //获取完整路径
    NSString *plistPath = [libPath stringByAppendingPathComponent:@"ClassTeacher.plist"];
    NSDictionary *Dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSLog(@"%@",Dic);
    NSArray *keyA = [Dic allKeys];
    for (NSString *key in keyA) {
        if ([key isEqualToString:_course_id]) {//说明有数据
            return Dic[_courseID];
        }
    }
    return nil;
}



-(void)requestData
{
    QKHTTPManager * mananger = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:_course_id forKey:@"id"];
    [mananger getTokenpublicPort:dic mod:@"Live" act:@"getLiveList" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"课程详情---+++++---%@",responseObject);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [mananger getClassDetail:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"课程详情------%@",responseObject);
        
        NSDictionary *dataDic = responseObject[@"data"];
        
        if (dataDic == nil) {
            return;
        }
        
        _dict = [responseObject objectForKey:@"data"];
        //_dict = [NSMutableDictionary dictionaryWithDictionary:dataDic];
        //_dict = dataDic;
         strId = [NSString stringWithFormat:@"%@",_dict[@"teacher_id"]];
//        [_dict removeObjectForKey:@"mzprice"];

        
        [_tableView reloadData];
        [self requestData2];
        [_tableView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
            [MBProgressHUD showError:@"网络不好...." toView:self.view];
            _dict = [self ReadResorce:_course_id];
            NSLog(@"11-----%@",_dict);
            [_tableView reloadData];
            [self requestData2];
            
            
    }];
}

- (void)requestData2
{
    QKHTTPManager * manager1 = [QKHTTPManager manager];
    NSMutableDictionary * dic1 = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic1 setValue:strId forKey:@"teacher_id"];
    [manager1 getTeacherDetail:dic1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        NSLog(@"000----%@",operation);
        
        _DIC = [responseObject objectForKey:@"data"];
        NSLog(@"%@",_DIC);
        if ([responseObject[@"code"] integerValue] != 1 ) {
            return;
        }
        _DIC = [NSMutableDictionary dictionaryWithDictionary:responseObject[@"data"]];
        [_DIC removeObjectForKey:@"subject_category"];
        [_DIC removeObjectForKey:@"teacher_schedule"];
        
        NSLog(@"_DIC=====%@",_DIC);
        
        NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
#pragma mark - 保存为dic.plist
        //获取完整路径
        NSString *plistPath = [libPath stringByAppendingPathComponent:@"ClassTeacher.plist"];
        
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        
        NSArray *keyArray = [dic allKeys];
        
        if (!keyArray.count) {
            
            NSMutableDictionary *div = [NSMutableDictionary dictionaryWithDictionary:dic];
            [div setValue:_DIC forKey:_course_id];
            BOOL success = [div writeToFile:plistPath atomically:YES];
            
            if (success) {//保存成功
                NSLog(@"成功");
            } else {//不成功
                NSLog(@"失败");
            }

            
        } else {
            
            for ( NSString *key in keyArray) {
                if ([key isEqualToString:_course_id]) {//有数据不保存
                    
                } else {
                    
                    NSMutableDictionary *div = [NSMutableDictionary dictionaryWithDictionary:dic];
                    [div setValue:_dict forKey:_course_id];
                    BOOL success = [div writeToFile:plistPath atomically:YES];
                    
                    if (success) {//保存成功
                        NSLog(@"成功");
                    } else {//不成功
                        NSLog(@"失败");
                    }
                    
                }
            }
            

        }

        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD showError:@"网络不好...." toView:self.view];
        _DIC = [self ReadResorce2:_course_id];
        NSLog(@"22-------%@",_DIC);
        [_tableView reloadData];
        
    }];

    
}

#pragma mark - 自定义分区标题
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (section == 1) {
//        UILabel * v_headerLab = [[UILabel alloc] initWithFrame:CGRectMake(7, 2, MainScreenWidth, 38)];
//        UIView *v_headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 30)];//创建一个视图（v_headerView）
//        v_headerLab.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];//设置v_headerLab的背景颜色
//        v_headerLab.font = [UIFont systemFontOfSize:17];//设置v_headerLab的字体样式和大小
//        v_headerLab.shadowColor = [UIColor whiteColor];//设置v_headerLab的字体的投影
//        [v_headerLab setShadowOffset:CGSizeMake(0, 1)];//设置v_headerLab的字体投影的位置
//        
//        v_headerLab.text = @"课程简介";
//        v_headerLab.textColor = [UIColor grayColor];
//        
//        [v_headerView addSubview:v_headerLab];
//        
//        return v_headerView;
//        
//    } else if (section == 0) {
//        UILabel * v_headerLab = [[UILabel alloc] initWithFrame:CGRectMake(7, 2, MainScreenWidth - 7 - 50, 38)];
//        UIView *v_headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 30)];
//        v_headerView.backgroundColor = [UIColor whiteColor];
//        v_headerLab.backgroundColor = [UIColor whiteColor];
//        
//        v_headerLab.text = _course_title;
//        v_headerLab.textColor = [UIColor grayColor];
//        
//        [v_headerView addSubview:v_headerLab];
//        
//        
//        //💰
//        UILabel *moneyL = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 60, 2, 50, 38)];
//        moneyL.backgroundColor = [UIColor whiteColor];
//        moneyL.text = @"免费";
//        moneyL.font = Font(14);
//        moneyL.textColor = [UIColor orangeColor];
//        [v_headerView addSubview:moneyL];
//        
//        
//        return v_headerView;
//
//    } else {
//        return nil;
//    }
//    return nil;
//}

#pragma mark - 让每个分区headerView一起滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _tableView)
    {
        CGFloat sectionHeaderHeight = 40;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        }
        else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (section==1) {
//        return 40;
//    }else if (section == 0) {
//        return 40;
//    }
//    else {
//        return 10;
//    }
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_dict == nil) {
        return 0;
    } else {
        return 8;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section == 2) {
//        return _DIC.count;
//    }
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if(indexPath.section==2) {//老师
        UITableViewCell *cell = [self tableView:_tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height + 20;
    }else if (indexPath.section == 0) {//介绍
        return 40;
    }else if (indexPath.section == 1) {
        return 170;
    } else if (indexPath.section == 3) {//机构
        return 140;
    } else if (indexPath.section == 4) {//平台保障
        return 140;
    } else if (indexPath.section == 5) {//推荐
        CGFloat H = MainScreenWidth / 3;
        return H ;
    } else if (indexPath.section == 6) {
        return 40;
    } else if (indexPath.section == 7) {
        return 190;
    }
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section == 0) {//评分
        static NSString * cellStr = @"SYGPFTableViewCell";
        classDetailZeroCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell == nil) {
            cell = [[classDetailZeroCell alloc] initWithReuseIdentifier:cellStr];
        }
        [cell dataWithDic:_dict];
        return cell;

    }
    
    if (indexPath.section==1) {
        
        static NSString * cellStr = @"SYGPFTableViewCell";
        ClassDetailOneCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell == nil) {
            cell = [[ClassDetailOneCell alloc] initWithReuseIdentifier:cellStr];
        }
        [cell dataWithDic:_dict];
        return cell;
    }
    
       if(indexPath.section==2) { //详情
        static NSString * cellStr = @"SYGKCJJTableViewCell";
        SYGKCJJTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell == nil) {
            cell = [[SYGKCJJTableViewCell alloc] initWithReuseIdentifier:cellStr];
        }
        [cell dataSourceWithDict:_dict];
        return cell;

    }
    if (indexPath.section==3) {//老师

        static NSString * cellStr = @"SYGXQTeacherTableViewCell";
        ClassDetailTeacherCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell == nil) {
            cell = [[ClassDetailTeacherCell alloc] initWithReuseIdentifier:cellStr];
        }
        
        [cell dataWithDic:_DIC];

        return cell;
    }
    
    if (indexPath.section == 4 ) {//机构
        static NSString *CellIdentifier = @"culture";
        //自定义cell类
        ClassDetailInstCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[ClassDetailInstCell alloc] initWithReuseIdentifier:CellIdentifier];
        }
        
        NSDictionary *dict = _dict[@"school_info"];
        [cell dataWithDic:dict];
        
        
        return cell;
       
    } else if (indexPath.section == 5) {//平台保证
        
        static NSString *CellIdentifier = @"culture1";
        //自定义cell类
        ClassTerraceCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[ClassTerraceCell alloc] initWithReuseIdentifier:CellIdentifier];
        }
        return cell;

        
    } else if (indexPath.section == 6) {
        static NSString *CellIdentifier = @"ClassRnown";
        //自定义cell类
        ClsaaRnownCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[ClsaaRnownCell alloc] initWithReuseIdentifier:CellIdentifier];
        }
        return cell;
        
    } else if (indexPath.section == 7) {//推荐
        
        static NSString *CellID = @"culture2";
        //自定义cell类
        ClassDetailRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        if (cell == nil) {
            cell = [[ClassDetailRecommendCell alloc] initWithReuseIdentifier:CellID];
        }
        NSDictionary *dict = _dict;
        [cell dataWithDic:dict];
        _aboutArray = _dict[@"recommend_list"];
        
        
        [cell.imageButton1 addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.imageButton2 addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.imageButton3 addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        return cell;  
    }
    return nil;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 3) {//讲师
        if (_DIC == nil) {
            return;
        }
        NSString *ID = _DIC[@"id"];
        TeacherDetilViewController *teacherDeVc = [[TeacherDetilViewController alloc] initWithNumID:ID];
        [self.navigationController pushViewController:teacherDeVc animated:YES];
        
    } else if (indexPath.section == 4) {//机构
        InstitutionMainViewController *institutionMainVc = [[InstitutionMainViewController alloc] init];
        institutionMainVc.schoolID = _dict[@"school_info"][@"school_id"];
        institutionMainVc.uID = _dict[@"school_info"][@"uid"];
        [self.navigationController pushViewController:institutionMainVc animated:YES];
    }
    
}

#pragma mark --- 点击事件
- (void)imageButtonClick:(UIButton *)button {
    
    NSLog(@"%ld",button.tag);
    NSInteger Num = button.tag;
    NSString *Cid = [NSString stringWithFormat:@"%@",_aboutArray[Num][@"id"]];
    NSString *Price = _aboutArray[Num][@"price"];
    NSString *Title = _aboutArray[Num][@"video_title"];
    NSString *VideoAddress = _aboutArray[Num][@"video_address"];
    if ([VideoAddress isEqualToString:@""]) {//为空就返回
        //        [MBProgressHUD showError:@"播放地址为空" toView:self.view];
        //        return;
    }
    NSString *ImageUrl = _aboutArray[Num][@"imageurl"];
    
    classDetailVC * classDetailVc = [[classDetailVC alloc]initWithMemberId:Cid andPrice:Price andTitle:Title];
    classDetailVc.videoTitle = Title;
    classDetailVc.img = ImageUrl;
    classDetailVc.video_address = VideoAddress;
    [self.navigationController pushViewController:classDetailVc animated:YES];

}




@end
