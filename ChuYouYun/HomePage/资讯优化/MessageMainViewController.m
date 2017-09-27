//
//  MessageMainViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/7/17.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "MessageMainViewController.h"
#import "JXSegment.h"
#import "JXPageView.h"
#import "SYG.h"
#import "ZhiyiHTTPRequest.h"
#import "MyHttpRequest.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "ZXZXTableViewCell.h"



@interface MessageMainViewController ()<JXSegmentDelegate,JXPageViewDataSource,JXPageViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    JXPageView *pageView;
    JXSegment *segment;
    NSInteger Number;
}

@property(nonatomic,strong) NSArray *channelArray;
@property (strong ,nonnull) UITableView *tableView;

@property (strong ,nonatomic)NSString *ID;

@property (strong ,nonatomic)NSArray *cateArray;//分类的集合
@property (strong ,nonatomic)NSMutableArray *titleArray;
@property (strong ,nonatomic)NSArray *dataArray;
@property (strong ,nonatomic)NSMutableArray *dataArr;

@end

@implementation MessageMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self NetWork];

}

- (void)interFace {
    self.automaticallyAdjustsScrollViewInsets = NO;
    _titleArray = [NSMutableArray array];
}

- (void)addSegmentView {
    
    segment = [[JXSegment alloc] initWithFrame:CGRectMake(0, 60, MainScreenWidth, 40)];
    [segment updateChannels:self.titleArray];
    
    segment.delegate = self;
    [self.view addSubview:segment];
    
    pageView =[[JXPageView alloc] initWithFrame:CGRectMake(0, 100, MainScreenWidth, self.view.bounds.size.height - 100)];
    pageView.datasource = self;
    pageView.delegate = self;
    [pageView reloadData];
//    [pageView changeToItemAtIndex:0];
    [self.view addSubview:pageView];
}

#pragma mark - JXPageViewDataSource
-(NSInteger)numberOfItemInJXPageView:(JXPageView *)pageView{
    return self.cateArray.count;
}

-(UIView*)pageView:(JXPageView *)pageView viewAtIndex:(NSInteger)index{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[self randomColor]];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 100) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.tag = index;
    tableView.dataSource = self;
    [view addSubview:tableView];
    _tableView = tableView;
    
    
    return view;
}

#pragma mark - JXSegmentDelegate
- (void)JXSegment:(JXSegment*)segment didSelectIndex:(NSInteger)index{
    [pageView changeToItemAtIndex:index];
    NSLog(@"%ld",index);
    _ID = _cateArray[index][@"zy_topic_category_id"];
    [self getData:_ID andNum:1];
}

#pragma mark - JXPageViewDelegate
- (void)didScrollToIndex:(NSInteger)index{
    [segment didChengeToIndex:index];
    NSLog(@"%ld",index);
    _ID = _cateArray[index][@"zy_topic_category_id"];
    NSLog(@"%@",_ID);
    [self getData:_ID andNum:1];
}

#pragma mark - UITableViewDataSource


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.05;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"culture";
    //自定义cell类
    ZXZXTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ZXZXTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    
    [cell.imageButton setBackgroundImage:[UIImage imageNamed:@"站位图"] forState:UIControlStateNormal];
    [cell.imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:_dataArr[indexPath.row][@"image"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"站位图"]];
    cell.titleLabel.text = _dataArr[indexPath.row][@"title"];
    NSString *readStr = [NSString stringWithFormat:@"阅读：%@",_dataArr[indexPath.row][@"readcount"]];
    cell.readLabel.text = readStr;
    cell.timeLabel.text = _dataArr[indexPath.row][@"dateline"];
    cell.JTLabel.text = [NSString stringWithFormat:@"%@",_dataArr[indexPath.row][@"desc"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld",tableView.tag);
    [_tableView reloadData];
    
}



- (UIColor *) randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    
    
}


#pragma mark --- 文字中找出图片

//获取webView中的所有图片URL
- (NSArray *) filterHTML:(NSString *) webString
{
    NSMutableArray * imageurlArray = [NSMutableArray arrayWithCapacity:1];
    //标签匹配
    NSString *parten = @"<img (.*?)>";
    NSError* error = NULL;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:parten options:0 error:&error];
    NSArray* match = [reg matchesInString:webString options:0 range:NSMakeRange(0, [webString length] - 1)];
    for (NSTextCheckingResult * result in match) {
        
        //过去数组中的标签
        NSRange range = [result range];
        NSString * subString = [webString substringWithRange:range];
        
        //从图片中的标签中提取ImageURL
        NSRegularExpression *subReg = [NSRegularExpression regularExpressionWithPattern:@"\"(.*?)\"" options:0 error:NULL];
        NSArray* match = [subReg matchesInString:subString options:0 range:NSMakeRange(0, [subString length] - 1)];
        if (match.count==0) {
            return nil;
        }
        
        NSTextCheckingResult * subRes = match[0];
        NSRange subRange = [subRes range];
        subRange.length = subRange.length -1;
        NSString * imagekUrl = [subString substringWithRange:subRange];
        //将提取出的图片URL添加到图片数组中
        [imageurlArray addObject:imagekUrl];
    }
    return imageurlArray;
}


#pragma mark --- 网络请求

- (void)NetWork {
    
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [manager FXFL:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        _dataArray = [NSMutableArray arrayWithArray:responseObject[@"data"]];
        _cateArray = responseObject[@"data"];
        NSLog(@"%@",_cateArray);
        
        for (int i = 0 ; i < _cateArray.count ; i ++) {
            NSString *title = _cateArray[i][@"title"];
            [_titleArray addObject:title];
        }
        
        [self addSegmentView];
        _ID = _cateArray[0][@"zy_topic_category_id"];
        [self getData:_ID andNum:1];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:@"数据加载失败" toView:self.view];
        NSLog(@"error   %@",error);
    }];
}

//详情里面的请求
- (void)getData:(NSString *)IDStr andNum:(NSInteger)num{
    
    QKHTTPManager *manager = [QKHTTPManager manager];
    manager.requestSerializer.timeoutInterval = 10.0;
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:@"1" forKey:@"order"];
    [dic setObject:[NSString stringWithFormat:@"%@",_ID] forKey:@"cid"];
    [dic setValue:[NSNumber numberWithInteger:num] forKey:@"page"];
    [dic setValue:@"6" forKey:@"count"];
    
    [manager getpublicPort:dic mod:@"News" act:@"getList" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"======  %@",responseObject);
        NSArray *LJArray = responseObject[@"data"];
        if (num == 1) {
            _dataArr = [NSMutableArray arrayWithArray:LJArray];
            _dataArr = responseObject[@"data"];
        } else {
            
            NSString *msg = responseObject[@"msg"];
            
            if ([responseObject[@"code"] integerValue ] == 1) {
                NSArray *SYGArray = [NSArray arrayWithArray:LJArray];
                [_dataArr addObjectsFromArray:SYGArray];
            } else {
                [MBProgressHUD showError:msg toView:self.view];
                return ;
            }
        }
        [_tableView reloadData];
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:@"数据加载失败" toView:self.view];
    }];
}




@end
