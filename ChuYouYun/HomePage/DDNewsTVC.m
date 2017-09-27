//
//  DDNewsTVC.m
//  dafengche
//
//  Created by IOS on 17/1/19.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "DDNewsTVC.h"
#import "SYG.h"
#import "UIScrollView+MJRefresh.h"
#import "MJRefresh.h"
#import "ZhiyiHTTPRequest.h"
#import "MyHttpRequest.h"
#import "MBProgressHUD+Add.h"
#import "ZiXunTableViewCell.h"
#import "ZiXunsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "GSMJRefresh.h"
#import "ZXDTViewController.h"
#import "DDNewsCell.h"




@interface DDNewsTVC ()
{

    NSString *_ID;

}
@property (nonatomic, strong) NSMutableArray *dataList;
@property (assign ,nonatomic)NSInteger number;
@property (strong ,nonatomic)NSMutableArray *imgdataArray;
@property (strong ,nonatomic)NSArray *dataArray;

@end

@implementation DDNewsTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //下拉刷新
    [self.tableView addHeaderWithTarget:self action:@selector(refreshData)];
    [self.tableView headerBeginRefreshing];
    //上拉加载
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    self.view.backgroundColor = [UIColor yellowColor];
    
    // 把小菊花漏出来
//    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
//    __weak typeof(self) weakSelf = self;
//    
//    self.tableView.mj_header = [GSMJRefreshHeader headerWithRefreshingBlock:^{
//        [weakSelf refreshData];
//    }];
//    
//    self.tableView.mj_footer = [GSMJRefreshAutoFooter footerWithRefreshingBlock:^{
//        [weakSelf loadMoreData];
//    }];
    
    // 去除刷新前的横线
    UIView*view = [UIView new];
    view.backgroundColor= [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    
    // 通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterBackGround)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}

- (void)setUrlString:(NSString *)urlString
{
    _number = 1;
    _urlString = urlString;
//    [self getData:_urlString andNum:_number];
}

//详情里面的请求
- (void)getData:(NSString *)IDStr andNum:(NSInteger)num{
    
    
    NSLog(@"%ld",num);
    
    QKHTTPManager *manager = [QKHTTPManager manager];
    manager.requestSerializer.timeoutInterval = 10.0;
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:[NSNumber numberWithInteger:num] forKey:@"page"];
    [dic setValue:@"20" forKey:@"count"];
    
    NSLog(@"%@",IDStr);
    
    [manager getpublicPort:dic mod:@"Live" act:@"getLiveList" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"===++====%@",responseObject);
        NSArray *LJArray = responseObject[@"data"];
        
        if (_number == 1) {
            
            _dataArray = [NSMutableArray arrayWithArray:LJArray];
            [self.tableView reloadData];
            
        }else {
            
            NSArray *SYGArray = [NSArray arrayWithArray:LJArray];
            if (SYGArray.count==0) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [MBProgressHUD showError:@"没有更多数据" toView:self.view];
            }else{
                [_dataArray arrayByAddingObjectsFromArray:SYGArray];
            }
        }
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
         [self.tableView headerEndRefreshing];
         [self.tableView footerEndRefreshing];
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         [MBProgressHUD showError:@"数据加载失败" toView:self.view];
     }];
}





#pragma mark 刷新

/** 下拉刷新 */
- (void)refreshData
{
    _number = 1;
    [self getData:_urlString andNum:_number];
}

/** 上拉加载 */
- (void)loadMoreData
{
    _number ++;
    [self getData:_urlString andNum:_number];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",_dataArray);
    DDNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DDNewsCell"];
    //自定义cell类
    if (cell == nil) {
        cell = [[DDNewsCell alloc] initWithReuseIdentifier:@"DDNewsCell"];
    }
    NSDictionary *dict = _dataArray[indexPath.row];
    [cell dataWithDict:dict withType:@"2"];
    return cell;
}

#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 135;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"110");

    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    ZXDTViewController *ZXDTVC = [[ZXDTViewController alloc] init];
//    [self.navigationController pushViewController:ZXDTVC animated:YES];
//    ZXDTVC.titleStr = _dataArray[indexPath.row][@"title"];
//    ZXDTVC.timeStr = _dataArray[indexPath.row][@"dateline"];
//    ZXDTVC.readStr = _dataArray[indexPath.row][@"readcount"];
//    ZXDTVC.ZYStr = _dataArray[indexPath.row][@"desc"];
//    ZXDTVC.GDStr = _dataArray[indexPath.row][@"text"];
//    ZXDTVC.ID = _dataArray[indexPath.row][@"id"];
}

#pragma mark -
- (void)enterBackGround
{
    //[[DDNewsCache sharedInstance] removeAllObjects];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
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
            NSLog(@"------%@",imagekUrl);
            //将提取出的图片URL添加到图片数组中
            [imageurlArray addObject:imagekUrl];
        }
        return imageurlArray;
    }

//移除警告框
- (void)removeAlert:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:YES];
    promptAlert =NULL;
}


//
//-(NSString *)filterHTML:(NSString *)html
//    {
//        NSScanner * scanner = [NSScanner scannerWithString:html];
//        NSString * text = nil;
//        while([scanner isAtEnd]==NO)
//        {
//            //找到标签的起始位置
//            [scanner scanUpToString:@"<" intoString:nil];
//            //找到标签的结束位置
//            [scanner scanUpToString:@">" intoString:&text];
//            
//            //        //找到标签的起始位置
//            //        [scanner scanUpToString:@"<" intoString:nil];
//            //        //找到标签的结束位置
//            //        [scanner scanUpToString:@">" intoString:&text];
//            
//            //替换字符
//            html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];

//            html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
//        }
//        // NSString * regEx = @"<([^>]*)>";
//        // html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
//        return html;
//}

@end
