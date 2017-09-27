//
//  DownloadView.m
//  dafengche
//
//  Created by IOS on 16/9/18.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "DownloadView.h"
#import "DownLoadTableViewCell.h"

@interface DownloadView ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
//cell 的 btn 集合
@property (strong, nonatomic) NSArray *btns;

@end

@implementation DownloadView


-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        self.btns = [NSMutableArray array];
        self.frame = frame;

        _tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];

        _tableView.delegate = self;
        
        _tableView.dataSource = self;
        
        [self addSubview: _tableView];

        [self initUI];
        
    }
    return self;
}

#pragma mark ---

//头部视图
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0.001;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellStr = @"DownLoadTableViewCell";
    DownLoadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    
    if (!cell) {
        
        NSArray *cellArr = [[NSBundle mainBundle]loadNibNamed:@"DownLoadTableViewCell" owner:nil options:nil];
        cell = [cellArr objectAtIndex:0];
        //cell.delegate = self;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.titleLab.text = @"123456789";
        
    }
    return cell;
}
-(void)addDownLoadTaskAction:(NSIndexPath *)indexPath{

    NSLog(@"8888");
}
-(void)initUI{
    
}
+(UIView *)getUrl:(NSURL *)url withArrar:(NSArray *)array{


    return nil;
}

@end
