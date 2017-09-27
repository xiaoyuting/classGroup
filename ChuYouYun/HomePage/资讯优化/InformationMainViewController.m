//
//  InformationMainViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/7/14.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "InformationMainViewController.h"
#import "LLSegmentBarVC.h"
#import "SYG.h"
#import "ZhiyiHTTPRequest.h"
#import "MyHttpRequest.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"


#import "ZiXunTableViewCell.h"
#import "ZiXunsTableViewCell.h"
#import "ZiXunsssTableViewCell.h"
#import "MessageWebViewController.h"
#import "ZXZXTableViewCell.h"



#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@interface InformationMainViewController ()<UITableViewDelegate,UITableViewDataSource,LLSegmentBarDelegate>

@property (nonatomic, strong) LLSegmentBarVC *segContentVC;
@property (strong ,nonatomic) UITableView    *tableView;

///顶部btn集合
@property (strong, nonatomic) NSArray *btns;

@property (strong ,nonatomic)NSArray *dataArray;

@property (strong ,nonatomic)NSMutableArray *dataArr;

@property (assign ,nonatomic)NSInteger number;

@property (strong ,nonatomic)NSMutableArray *imgdataArray;

@property (strong ,nonatomic)NSString *ID;

@property (strong ,nonatomic)NSArray *cateArray;//分类的集合


@end

@implementation InformationMainViewController


// lazy init
- (LLSegmentBarVC *)segContentVC{
    if (!_segContentVC) {
        LLSegmentBarVC *contentVC = [[LLSegmentBarVC alloc]init];
        [self addChildViewController:contentVC];
        _segContentVC = contentVC;
    }
    return _segContentVC;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self NetWork];

}

#pragma mark ---- 初始化
- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
//    __weak typeof(self) weakSelf = self;
}


#pragma mark ---- 分段控制器

- (void)addSegment {
    
    // 1 设置控制器V的frame
    self.segContentVC.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view addSubview:self.segContentVC.view];
//    _segContentVC.segmentBar.delegate = self;

    
    // 2 控制器数组和标题数组
    NSMutableArray *arrM = [NSMutableArray array];
    NSMutableArray *titleArrM = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = 0; i < _cateArray.count; i++) {
        UIViewController *VC = [UIViewController new];
        VC.view.backgroundColor = randomColor;
        NSString *title = [NSString stringWithFormat:@"%@",_cateArray[i][@"title"]];
        [titleArrM addObject:title];
        [arrM addObject:VC];
        
        //添加表格
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, MainScreenWidth, MainScreenHeight - 100) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor yellowColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [VC.view addSubview:_tableView];
    }
    // 3 添加
    [self.segContentVC setUpWithItems:titleArrM childVCs:arrM];
    
    
    [self.segContentVC.segmentBar updateWithConfig:^(LLSegmentBarConfig *config) {

    }];

}

#pragma mark --- LLSegmentBarDelegate

- (void)segmentBar:(LLSegmentBar *)segmentBar didSelectIndex: (NSInteger)toIndex fromIndex: (NSInteger)fromIndex {
    
    NSLog(@"12333");
    _segContentVC.segmentBar = segmentBar;
    NSLog(@"---%ld  %ld ",toIndex,fromIndex);
    _ID = _cateArray[toIndex][@"zy_topic_category_id"];
    [self getData:_ID andNum:1];
    [_tableView reloadData];
}

#pragma mark --- UITableViewDelegate

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    NSString *htmlStr = [NSString stringWithFormat:@"%@",_dataArr[indexPath.row][@"text"]];
//    [self filterHTML:htmlStr];
//    NSArray *matchArray = NULL;
//    matchArray = [self filterHTML:htmlStr];
//    if (matchArray.count>2) {
//        
//        return 45 +56*MainScreenWidth/320 + (MainScreenWidth/3 -12)*80/115;
//        
//    }else if (matchArray.count){
//        
//        return (MainScreenWidth/3 -12)*80/115 + 30;
//        
//    } else {
//        
//        return 35 +56*MainScreenWidth/320;
//    }
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 0.0001;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    
//    return 20;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
    return _dataArr.count;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    static NSString *cellStr = @"1213";
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
//    return cell;

//    NSString *htmlStr = [NSString stringWithFormat:@"%@",_dataArr[indexPath.row][@"text"]];
//    [self filterHTML:htmlStr];
//    NSArray *matchArray = NULL;
//    matchArray = [self filterHTML:htmlStr];
//    
//    if (matchArray.count > 2) {
//        
//        static NSString *cellID = @"ZiXunTableViewCell";
//        ZiXunTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//        
//        if (cell == nil) {
//            if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//                [_tableView setSeparatorInset:UIEdgeInsetsZero];
//            }
//            cell = [[ZiXunTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//        }
//        NSString *imgUrl1 = [NSString stringWithFormat:@"%@%@",GLAPI_Base_Url,[matchArray[0] substringFromIndex:1]];
//        cell.secondLab.text = [NSString stringWithFormat:@"%@",_dataArr[indexPath.row][@"desc"]];
//        [cell.ImagV sd_setImageWithURL:[NSURL URLWithString:imgUrl1] placeholderImage:[UIImage imageNamed:@"站位图"]];
//        
//        if (matchArray.count >1) {
//            NSString *imgUrl2 = [NSString stringWithFormat:@"%@%@",GLAPI_Base_Url,[matchArray[1] substringFromIndex:1]];
//            [cell.ImagV1 sd_setImageWithURL:[NSURL URLWithString:imgUrl2] placeholderImage:[UIImage imageNamed:@"站位图"]];
//        }
//        if (matchArray.count >2) {
//            NSString *imgUrl3 = [NSString stringWithFormat:@"%@%@",GLAPI_Base_Url,[matchArray[2] substringFromIndex:1]];
//            [cell.ImagV2 sd_setImageWithURL:[NSURL URLWithString:imgUrl3] placeholderImage:[UIImage imageNamed:@"站位图"]];
//        }
//        cell.firstlab.text = [NSString stringWithFormat:@"%@",_dataArr[indexPath.row][@"title"]];
//        NSArray *str = [self filterHTML:_dataArr[indexPath.row][@"text"]];
//        NSLog(@"--===---%@",str);
//        return cell;
//        
//    }else if(matchArray.count == 0){
//        
//        static NSString *cellID = @"ZiXunsTableViewCell";
//        ZiXunsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//        if (!cell) {
//            
//            if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//                [_tableView setSeparatorInset:UIEdgeInsetsZero];
//            }
//            
//            cell = [[ZiXunsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//        }
//        cell.secondLab.text = [NSString stringWithFormat:@"%@",_dataArr[indexPath.row][@"desc"]];
//        cell.firstlab.text = [NSString stringWithFormat:@"%@",_dataArr[indexPath.row][@"title"]];
//        return cell;
//        
//    }else{
//        
//        static NSString *cellID = @"ZiXunsssTableViewCell";
//        ZiXunsssTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//        if (!cell) {
//            
//            if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//                [_tableView setSeparatorInset:UIEdgeInsetsZero];
//            }
//            
//            cell = [[ZiXunsssTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//        }
//        cell.secondLab.text = [NSString stringWithFormat:@"%@",_dataArr[indexPath.row][@"desc"]];
//        cell.firstlab.text = [NSString stringWithFormat:@"%@",_dataArr[indexPath.row][@"title"]];
//        NSString *imgUrl1 = [NSString stringWithFormat:@"%@%@",GLAPI_Base_Url,[matchArray[0] substringFromIndex:1]];
//        
//        [cell.ImagV sd_setImageWithURL:[NSURL URLWithString:imgUrl1] placeholderImage:[UIImage imageNamed:@"站位图"]];
//        return cell;
//    }
//}


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
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MessageWebViewController *webVc = [[MessageWebViewController alloc] init];
    webVc.ID = _dataArr[indexPath.row][@"id"];
    [self.navigationController pushViewController:webVc animated:YES];
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
        
        [self addSegment];
//        [self creatMenu];
//        [self addTableView];
        
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
