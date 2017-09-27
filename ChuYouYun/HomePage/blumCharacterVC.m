//
//  blumCharacterVC.m
//  ChuYouYun
//
//  Created by zhiyicx on 15/2/13.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//
#define ViewBackColor [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1]
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
#define iPhone4SOriPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)//iphone4,4s屏幕

#define iPhone5o5Co5S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)//iphone5/5c/5s屏幕


#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6屏幕

#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6plus屏幕

#define iPhone6PlusBIG ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6plus放大版屏幕

#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))

#import "blumCharacterVC.h"
#import "characterTableCell.h"
#import "MyHttpRequest.h"
#import "blumCatalogList.h"
#import "characterPlayVC.h"
#import "UIColor+HTMLColors.h"

@interface blumCharacterVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _tableView;
    UILabel *lable;
}

@property (strong ,nonatomic)UIButton *XZButton;

@property (strong ,nonatomic)NSMutableArray *XZArray;

@property (assign ,nonatomic)NSInteger num;//记录点击的次数（不然总是会播放缓存的第一个视频）

@end

@implementation blumCharacterVC
-(id)initWithId:(NSString *)Id andTitle:(NSString *)blum_title
{
    if (self=[super init]) {
        _blum_id = Id;
        _blum_title = blum_title;
    }
    return self;
}

- (UIButton *)XZButton {
    if (!_XZButton) {
        _XZButton = [[UIButton alloc] initWithFrame:CGRectMake(60, 20, 10, 10)];
        _XZButton.backgroundColor = [UIColor redColor];
        _XZButton.layer.cornerRadius = 5;
    }
    return _XZButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _XZArray = [NSMutableArray array];
    _num = 0;
    
    self.view.backgroundColor = ViewBackColor;
    if (iPhone4SOriPhone4) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-290+145 - 200 + 50) style:UITableViewStylePlain];

        
    }
    if (iPhone5o5Co5S) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-300+145 - 200 + 50) style:UITableViewStylePlain];
    }
    else if (iPhone6)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-380+145 - 200 + 50) style:UITableViewStylePlain];
    }
    else if (iPhone6Plus)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-430+145 - 200 + 50) style:UITableViewStylePlain];
    }else {//ipad适配
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-630+145 - 200 + 50 - 100) style:UITableViewStylePlain];
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 50;
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
    lable = [[UILabel alloc]initWithFrame:CGRectMake(0,50*MainScreenHeight/667,MainScreenWidth, 13)];
    [_tableView insertSubview:lable atIndex:0];
    lable.text = @"数据为空，刷新重试";
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    [self requestData];
    
    
    
//    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [_tableView setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [_tableView setLayoutMargins:UIEdgeInsetsZero];
//    }
    

//    if (_dataArray.count > 0) {
//        [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];//设置选中第一行（默认有蓝色背景）
////        [_tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];//实现点击第一行所调用的方法
//    }
    
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}



//取出本地的
- (NSArray *)ReadResorce:(NSString *)bulmId {
    
    NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
#pragma mark - 保存为dic.plist
    //获取完整路径
    NSString *plistPath = [libPath stringByAppendingPathComponent:@"ClassTable.plist"];
    NSDictionary *Dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSLog(@"%@",Dic);
    NSArray *keyA = [Dic allKeys];
    for (NSString *key in keyA) {
        if ([key isEqualToString:_blum_id]) {//说明有数据
            return Dic[bulmId];
        }
    }
    return nil;
}




-(void)requestData
{
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:_blum_id forKey:@"id"];
    [manager albumCatalog:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        _dataArray = [responseObject objectForKey:@"data"];
        
        [self ReadResorce:_blum_id];
        
        NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
#pragma mark - 保存为dic.plist
        //获取完整路径
        NSString *plistPath = [libPath stringByAppendingPathComponent:@"ClassTable.plist"];
        
        NSDictionary *dicHH = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        
        NSLog(@"%@",plistPath);
        NSLog(@"%@",dicHH);
        
        
        
        NSArray *keyArray = [dicHH allKeys];
        
        if (!keyArray.count) {//说明是第一次
            
            NSMutableDictionary *div = [NSMutableDictionary dictionaryWithDictionary:dicHH];
            [div setValue:_dataArray forKey:_blum_id];
            BOOL success = [div writeToFile:plistPath atomically:YES];
            
            if (success) {//保存成功
                NSLog(@"成功");
            } else {//不成功
                NSLog(@"失败");
            }
            

            
        } else {
            for ( NSString *key in keyArray) {
                
                if ([key isEqualToString:_blum_id]) {//有数据不保存
                    //                _dataArray = dic[_blum_id];
                } else {
                    
                    NSMutableDictionary *div = [NSMutableDictionary dictionaryWithDictionary:dicHH];
                    [div setValue:_dataArray forKey:_blum_id];
                    BOOL success = [div writeToFile:plistPath atomically:YES];
                    
                    if (success) {//保存成功
                        NSLog(@"成功");
                    } else {//不成功
                        NSLog(@"失败");
                    }
                    
                }
            }

        }
        

        
//        
//        NSMutableArray * listArr = [[NSMutableArray alloc]initWithCapacity:0];
//        for (int i=0; i<_dataArray.count; i++) {
//            blumCatalogList * list = [[blumCatalogList alloc]initWithDictionarys:_dataArray[i]];
//            [listArr addObject:list];
//        }
//        _dataArray = listArr;
        [_tableView reloadData];
        
        for (int i = 0 ; i < _dataArray.count; i ++) {
            if (i == 0) {
                [_XZArray addObject:[NSNumber numberWithBool:YES]];
            }else {
                 [_XZArray addObject:[NSNumber numberWithBool:NO]];
            }
           
        }
        NSLog(@"%@",_XZArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        _dataArray = [self ReadResorce:_blum_id];
        
        
        NSLog(@"%@",_dataArray);
        [_tableView reloadData];
        
        for (int i = 0 ; i < _dataArray.count; i ++) {
            if (i == 0) {
                [_XZArray addObject:[NSNumber numberWithBool:YES]];
            }else {
                [_XZArray addObject:[NSNumber numberWithBool:NO]];
            }
            
        }
        NSLog(@"%@",_XZArray);
        
    }];
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataArray.count==0) {
        lable.textColor = [UIColor colorWithHexString:@"#dedede"];
        
    }else{
        lable.textColor = [UIColor clearColor];
    }
    return _dataArray.count;

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellStr = @"cell";
    characterTableCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        NSArray * xibArr = [[NSBundle mainBundle]loadNibNamed:@"characterTableCell" owner:nil options:nil];
        for (id obj in xibArr) {
            cell = (characterTableCell *)obj;
            break;
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    //添加线
    UILabel *XLabel = [[UILabel alloc] initWithFrame:CGRectMake(67 + 3, 0, 1, 35 / 2)];
    XLabel.backgroundColor = [UIColor colorWithRed:153.f / 255 green:152.f / 255 blue:152.f / 255 alpha:1];
    [cell addSubview:XLabel];
    
    UILabel *SLabel = [[UILabel alloc] initWithFrame:CGRectMake(67 + 3, 50 - 35 / 2 - 2, 1, 35 / 2 + 2)];
    SLabel.backgroundColor = [UIColor colorWithRed:153.f / 255 green:152.f / 255 blue:152.f / 255 alpha:1];
    [cell addSubview:SLabel];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(60 + 3, 35 / 2, 15, 15)];
   
    
    [cell addSubview:button];
    
//    blumCatalogList * list = _dataArray[indexPath.row];
//    cell.titleLab.text = list.classTitle;
    cell.titleLab.text = _dataArray[indexPath.row][@"video_title"];
    cell.countLab.text = [NSString stringWithFormat:@"章节%ld",(long)(indexPath.row+1)];
    
    if ([_XZArray[indexPath.row] boolValue] == NO) {
         [button setBackgroundImage:[UIImage imageNamed:@"椭圆-100"] forState:UIControlStateNormal];

    }else {
         [button setBackgroundImage:[UIImage imageNamed:@"点@2x"] forState:UIControlStateNormal];
        
        //变颜色
        cell.titleLab.textColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
        cell.countLab.textColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    }

    if (indexPath.row == 0) {
//        blumCatalogList * list = _dataArray[indexPath.row];
//       NSString *HH =  _dataArray[indexPath.row][@"id"];
//         [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationClassID" object:nil userInfo:list.classId];
        
        if (_num == 0) {//说明是第一次的时候
            NSLog(@"%@",_dataArray[indexPath.row]);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationClassID" object:nil userInfo:_dataArray[indexPath.row][@"id"]];
            
            //添加观看记录
            
            NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
#pragma mark - 保存为dic.plist
            //获取完整路径
            NSString *plistPath = [libPath stringByAppendingPathComponent:@"LookRecode.plist"];
            
            NSArray *lookArray = [NSArray arrayWithContentsOfFile:plistPath];
            
            lookArray = [self checkPlist];
            
            NSLog(@"%@",plistPath);
            
            
            NSMutableArray *divArray = [NSMutableArray arrayWithArray:lookArray];
            
            
            
            for (int i = 0; i < divArray.count; i ++) {
                
                if ([divArray[i][@"id"] isEqualToString:_dataArray[indexPath.row][@"id"]]) {//说明存在
                    [divArray removeObject:divArray[i]];
                }
                
            }
            
            //添加记录
            [divArray addObject:_dataArray[indexPath.row]];
            
            BOOL success = [divArray writeToFile:plistPath atomically:YES];
            
            if (success) {//保存成功
                NSLog(@"成功");
            } else {//不成功
                NSLog(@"失败");
            }
            
            NSLog(@"divArray-----%@",divArray);

        }
        

    }
    
    [cell addSubview:_XZButton];
//    if (indexPath.row == 0) {
//        [self tableView:_tableView didSelectRowAtIndexPath:0];
//    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    blumCatalogList * list = _dataArray[indexPath.row];

    
    for (int i = 0 ; i < _XZArray.count; i ++) {
        if (i == indexPath.row) {
            [_XZArray replaceObjectAtIndex:i  withObject:[NSNumber numberWithBool:YES]];
        }else {
            [_XZArray replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
        }
    }
    
    //当前选中的变颜色
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationClassID" object:nil userInfo:_dataArray[indexPath.row][@"id"]];
    
    _num ++;
    [_tableView reloadData];
    
    
    //在这里添加播放试图
    //将点击的课程id传到主界面上面。然后网络请求，获得url
    
    NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
#pragma mark - 保存为dic.plist
    //获取完整路径
    NSString *plistPath = [libPath stringByAppendingPathComponent:@"LookRecode.plist"];
    
    NSArray *lookArray = [NSArray arrayWithContentsOfFile:plistPath];
    
    lookArray = [self checkPlist];
    
    NSLog(@"%@",plistPath);

    
    NSMutableArray *divArray = [NSMutableArray arrayWithArray:lookArray];
    


    for (int i = 0; i < divArray.count; i ++) {
        
        if ([divArray[i][@"id"] isEqualToString:_dataArray[indexPath.row][@"id"]]) {//说明存在
            [divArray removeObject:divArray[i]];
        }

    }
    
    //添加记录
    [divArray addObject:_dataArray[indexPath.row]];

    BOOL success = [divArray writeToFile:plistPath atomically:YES];
    
    if (success) {//保存成功
        NSLog(@"成功");
    } else {//不成功
        NSLog(@"失败");
    }
    
    NSLog(@"divArray-----%@",divArray);

    
    

}

//播放的网络请求
-(void)loadClassData:(NSString *)classID
{
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:classID forKey:@"id"];
    [manager getClassDetail:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject[@"data"][@"video_address"]);

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


//添加观看记录的本地文件
- (NSArray *)checkPlist {
    
    NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
#pragma mark - 保存为dic.plist
    //获取完整路径
    NSString *plistPath = [libPath stringByAppendingPathComponent:@"LookRecode.plist"];
    
//    NSDictionary *dicHH = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *dicArray = [NSArray arrayWithContentsOfFile:plistPath];
    
    NSLog(@"%@",plistPath);
//    NSLog(@"%@",dicHH);

    return dicArray;
    
}



@end
