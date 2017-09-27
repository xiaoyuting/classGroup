//
//  ClassCharaViewController.m
//  ThinkSNS（探索版）
//
//  Created by 智艺创想 on 16/10/11.
//  Copyright © 2016年 zhishi. All rights reserved.
//  课程章节

#define ViewBackColor [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1]

#import "ClassCharaViewController.h"
#import "characterTableCell.h"
#import "MyHttpRequest.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "ClassCharaCell.h"




@interface ClassCharaViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    UITableView * _tableView;
    UILabel *lable;
    
    BOOL _isOn0;
    BOOL _isOn1;
    BOOL _isOn2;
    BOOL _isOn3;
    BOOL _isOn4;
    BOOL _isOn5;
    int _number;
    
    UIButton *button0;
    UIButton *button1;
    UIButton *button2;
    UIButton *button3;
    UIButton *button4;
    UIButton *button5;
    
}

@property (strong ,nonatomic)UIButton *XZButton;

@property (strong ,nonatomic)NSMutableArray *XZArray;

@property (assign ,nonatomic)NSInteger num;//记录点击的次数（不然总是会播放缓存的第一个视频）

@property (strong ,nonatomic)NSMutableArray *titleArray;

@property (strong ,nonatomic)NSMutableArray *BoolArray;

@property (strong ,nonatomic)NSString *sectionID;

@property (strong ,nonatomic)NSArray *allArray;

@end

@implementation ClassCharaViewController

-(id)initWithId:(NSString *)Id andTitle:(NSString *)blum_title
{
    if (self=[super init]) {
        _class_id = Id;
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
    _dataArray = [NSMutableArray array];
    _titleArray = [NSMutableArray array];
    _BoolArray = [NSMutableArray array];
    _num = 0;
    
    _isOn0 = NO;
    _isOn1 = NO;
    _isOn2 = NO;
    _isOn3 = NO;
    _isOn4 = NO;
    _isOn5 = NO;
    
    
    self.view.backgroundColor = ViewBackColor;
    if (iPhone4SOriPhone4) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-290+145 - 200 - 3 + 15) style:UITableViewStylePlain];
    }
    if (iPhone5o5Co5S) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-300+145 - 200 - 3 + 15) style:UITableViewStylePlain];
    }
    else if (iPhone6)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-380+145 - 200 - 3 + 6 ) style:UITableViewStylePlain];
    }
    else if (iPhone6Plus)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-430+145 - 200 - 3  + 8) style:UITableViewStylePlain];
    }else {//ipad适配
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-630+145 - 200 + 50 - 100) style:UITableViewStylePlain];
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 40;
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
    lable = [[UILabel alloc]initWithFrame:CGRectMake(0,50*MainScreenHeight/667,MainScreenWidth, 13)];
    [_tableView insertSubview:lable atIndex:0];
    lable.text = @"数据为空，刷新重试";
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self requestData];
    
}

-(void)requestData
{
    
    BigWindCar *manager = [BigWindCar manager];
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:_class_id forKey:@"id"];

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }

    NSLog(@"%@",dic);
    [manager BigWinCar_getClassList:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSLog(@"%@",operation);
        
        if ([responseObject[@"data"] isEqual:[NSNull null]]) {
            return ;
        }
        NSArray *isArray = responseObject[@"data"];
        if (isArray.count == 0) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 390)];
            imageView.image = [UIImage imageNamed:@"课程@2x"];
            [self.view addSubview:imageView];
            return;
        } else {
            
        }
        
        
        _allArray = responseObject[@"data"];
        NSArray *array = responseObject[@"data"];
        

        for (int i = 0 ; i < array.count; i ++ ) {
            NSArray *classArray = array[i][@"child"];
            if (classArray == nil) {
            } else {
                [_dataArray addObject:classArray]; 
            }

            
            NSString *title = array[i][@"title"];
            [_titleArray addObject:title];
            
            NSMutableArray *ISArray = [NSMutableArray array];
            for (int k = 0 ; k < classArray.count ; k ++) {
                
                if (i == 0 && k == 0) {
                    [ISArray addObject:[NSNumber numberWithBool:YES]];
                } else {
                    [ISArray addObject:[NSNumber numberWithBool:NO]];
                }
  
            }
            [_XZArray addObject:ISArray];
            
            [_BoolArray addObject:[NSNumber numberWithBool:NO]];
        }

        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_tableView reloadData];
        NSLog(@"%@",operation);
        
        for (int i = 0 ; i < _dataArray.count; i ++) {
            if (i == 0) {
                [_XZArray addObject:[NSNumber numberWithBool:YES]];
            }else {
                [_XZArray addObject:[NSNumber numberWithBool:NO]];
            }
            
        }
        
    }];
}

- (void)getTitleArray {
    for (int i = 0 ; i < _allArray.count; i ++ ) {
        NSString *title = _allArray[i][@"title"];
        [_titleArray addObject:title];
        [_tableView reloadData];
    }

}

#pragma mark ----

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, 40)];
    btn.tag =section;
    NSArray *sectionArray = _dataArray[section];
    NSString *str1 ;
    
    str1 = [NSString stringWithFormat:@"   %@(%ld)",_titleArray[section],sectionArray.count];
    
    [btn setTitle:str1 forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    btn.selected = NO;
    [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    
    [btn setImage:Image(@"向上@2x") forState:UIControlStateNormal];
    btn.imageEdgeInsets =  UIEdgeInsetsMake(0,MainScreenWidth - 40,0,0);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 40);
    
    if (section == 0) {
         button0 = btn;
        if (_isOn0) {
            [button0 setImage:Image(@"灰色乡下@2x") forState:UIControlStateNormal];
        }
    } else if (section == 1) {
         button1 = btn;
        if (_isOn1) {
            [button1 setImage:Image(@"灰色乡下@2x") forState:UIControlStateNormal];
        }
    } else if (section == 2) {
         button2 = btn;
        if (_isOn2) {
            [button2 setImage:Image(@"灰色乡下@2x") forState:UIControlStateNormal];
        }
    } else if (section == 3) {
         button3 = btn;
        if (_isOn3) {
            [button3 setImage:Image(@"灰色乡下@2x") forState:UIControlStateNormal];
        }
    } else if (section == 4) {
         button4 = btn;
        if (_isOn4) {
            [button4 setImage:Image(@"灰色乡下@2x") forState:UIControlStateNormal];
        }
    } else if (section == 5) {
         button5 = btn;
        if (_isOn5) {
            [button5 setImage:Image(@"灰色乡下@2x") forState:UIControlStateNormal];
        }
    }
    
    
    
    //左对齐
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    return btn;
}

-(void)change:(UIButton *)button{
    
//    BOOL isOn = [_BoolArray[button.tag] boolValue];
//    isOn = !isOn;
//    [_tableView reloadData];
    
    
    if (button.tag == 0) {
        _isOn0 = !_isOn0;
    } else if (button.tag == 1) {
        _isOn1 = !_isOn1;
    } else if (button.tag == 2) {
        _isOn2 = !_isOn2;
    } else if (button.tag == 3) {
        _isOn3 = !_isOn3;
    } else if (button.tag == 4) {
        _isOn4 = !_isOn4;
    } else if (button.tag == 5) {
        _isOn5 = !_isOn5;
    }
    [_tableView reloadData];
    
}


//头部视图
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    return _titleArray.count;
    return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    BOOL isOn = [_BoolArray[section] boolValue];
//    
//    if (isOn) {
//        for (int i = 0 ; i < _BoolArray.count; i ++) {
//            if (i == section) {
//                return 0;
//            }
//        }
//    }
//
//    NSArray *sectionArray = _dataArray[section];
//    return sectionArray.count;
    
    
    if (_isOn0) {
        if (section == 0) {
            return 0;
        }
    }
    if (_isOn1) {
        if (section == 1) {
            return 0;
        }
    }
    if (_isOn2) {
        if (section == 2) {
            return 0;
        }
    }
    if (_isOn3) {
        if (section == 3) {
            return 0;
        }
    }
    if (_isOn4) {
        if (section == 4) {
            return 0;
        }
    }
    if (_isOn5) {
        if (section == 5) {
            return 0;
        }
    }
    
    NSArray *sectionArray = _dataArray[section];
    return sectionArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"SYGBJTableViewCell";
    static NSString *CellIdentifier = nil;
    CellIdentifier = [NSString stringWithFormat:@"cell - %ld",indexPath.row];
    //自定义cell类
    ClassCharaCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ClassCharaCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    
    if ([_XZArray[indexPath.section][indexPath.row] boolValue] == NO) {
        [cell.imageButton setBackgroundImage:Image(@"视频_灰色") forState:UIControlStateNormal];
        cell.title.textColor = [UIColor grayColor];
    }else {
        [cell.imageButton setBackgroundImage:Image(@"视频-绿色") forState:UIControlStateNormal];
        cell.title.textColor = BasidColor;
    }
    NSDictionary *dict = _dataArray[indexPath.section][indexPath.row];
    [cell dataSourceWith:dict];


    if (_num == 0) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {//说明是第一次的时候
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationClassAddress" object:nil userInfo:_dataArray[indexPath.section][indexPath.row]];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationClassAddress" object:nil userInfo:_dataArray[indexPath.section][indexPath.row]];
                _num ++;
            }
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    for (int l = 0 ; l < _XZArray.count ; l ++) {
        
        if (l == indexPath.section) {
            NSMutableArray *nowArray = [NSMutableArray arrayWithArray:_XZArray[indexPath.section]];
            for (int i = 0 ; i < nowArray.count ; i ++) {
                
                if (i == indexPath.row) {
                    [nowArray replaceObjectAtIndex:i  withObject:[NSNumber numberWithBool:YES]];
                }else {
                    [nowArray replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
                }
            }
            
            [_XZArray replaceObjectAtIndex:indexPath.section withObject:nowArray];

        } else {
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:_XZArray[l]];
            for (int i = 0 ; i < array.count ; i ++) {
               [ array replaceObjectAtIndex:i  withObject:[NSNumber numberWithBool:NO]];
                
            }
            [_XZArray replaceObjectAtIndex:l withObject:array];
   
        }
    }
    
    
    //当前选中的变颜色

    
    _num ++;
    [_tableView reloadData];
    
    NSLog(@"%@",_dataArray[indexPath.section][indexPath.row]);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationClassAddress" object:nil userInfo:_dataArray[indexPath.section][indexPath.row]];
    
    //记录当前 课程的章节id 和 课程id
    
    _sectionID = _allArray[indexPath.section][@"id"];
    
    //添加学习记录
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
            [self addStudyRecord];
    }

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

//添加学习记录
- (void)addStudyRecord {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    
    [dic setValue:_class_id forKey:@"vid"];
    [dic setValue:_sectionID forKey:@"sid"];
    
    [manager BigWinCar_AddRecord:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
  
}





@end
