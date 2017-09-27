//
//  LiveDetailCommentViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/3/29.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "LiveDetailCommentViewController.h"
#import "SYG.h"
#import "BigWindCar_CommentCell.h"
#import "MyHttpRequest.h"
#import "MJRefresh.h"


#import "DLViewController.h"
#import "SYGDPViewController.h"


@interface LiveDetailCommentViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)NSString *ID;
@property (strong ,nonnull)NSDictionary *dict;
@property (strong ,nonatomic)NSArray *dataArray;
@property (strong ,nonatomic)UIView *footView;
@property (strong ,nonatomic)UIImageView *imageView;

@end

@implementation LiveDetailCommentViewController

- (instancetype)initWithType:(NSString *)ID {
    if (self=[super init]) {
        _ID = ID;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self addTableView];
    [self requestData];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)addTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_tableView];
    
    [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshing)];
    [_tableView headerBeginRefreshing];
}


- (void)headerRerefreshing {
    [self requestData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView headerEndRefreshing];
    });
}


#pragma mark ---- UITableVieDataSoruce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton * v_headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    v_headerBtn.frame = CGRectMake(MainScreenWidth-70, 10, 85, 22);
    UIView *v_headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 30)];//创建一个视图（v_headerView）
    [v_headerBtn setImage:[UIImage imageNamed:@"552cc17f5bb87_32@2x.png"] forState:UIControlStateNormal];
    [v_headerBtn addTarget:self action:@selector(MakeCommentBtn) forControlEvents:UIControlEventTouchUpInside];
    [v_headerView addSubview:v_headerBtn];
    return v_headerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"cellClass";
    //自定义cell类
    BigWindCar_CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    //自定义cell类
    if (cell == nil) {
        cell = [[BigWindCar_CommentCell alloc] initWithReuseIdentifier:CellID];
    }
    NSDictionary *dcit = _dataArray[indexPath.row];
    [cell dataSourceWith:dcit];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark --- 网络请求
- (void)requestData {
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:@"1" forKey:@"page"];
    [dic setValue:@"100" forKey:@"count"];
    [dic setValue:_ID forKey:@"kzid"];
    [dic setValue:@"1" forKey:@"kztype"];
    [dic setValue:@"2" forKey:@"type"];
    [manager getClassNoteAndQuestionAndComment:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"---%@",responseObject);
        
        if ([responseObject[@"data"] isEqual:[NSNull null]]) {

            _footView.hidden = NO;
            _imageView.hidden = NO;
            if (!_imageView.image) {
                UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 60, MainScreenWidth, MainScreenHeight)];
                _footView = view;
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 200)];
                imageView.image = [UIImage imageNamed:@"点评@2x"];
                [view addSubview:imageView];
                [_tableView addSubview:view];
                _imageView = imageView;
            }
            
        } else {
            _dataArray = responseObject[@"data"];
            if (_dataArray.count > 0) {
                _footView.hidden = YES;
                _imageView.hidden = YES;
            }
        }
        
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}



#pragma mark - 让每个分区headerView一起滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _tableView)
    {
        CGFloat sectionHeaderHeight = 40;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}


#pragma mark ---事件监听
- (void)MakeCommentBtn
{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
        
    }
    
    SYGDPViewController *SYGDPVC = [[SYGDPViewController alloc] init];
    UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:SYGDPVC];
    SYGDPVC.ID = _ID;
    [self.navigationController presentViewController:Nav animated:YES completion:nil];
    
    
}



@end
