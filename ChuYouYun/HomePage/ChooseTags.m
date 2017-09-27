//
//  ChooseTags.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/2/25.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "ChooseTags.h"
#import "TagsCell.h"
#import "ZhiyiHTTPRequest.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "ChooseButton.h"
@interface ChooseTags ()
{
    NSArray *_titleArr;
    NSInteger selects;
    CGRect rect;
    UIView *tagView;
    ChooseButton *titleBtn;
    NSInteger row;
    NSInteger bRow;
    BOOL isRemove;
    NSInteger reTag;
    NSMutableDictionary *tagWithRow;
    NSInteger cTag;
    NSMutableDictionary *cTagArr;
}
@end

@implementation ChooseTags
-(id)initWithQuizTitlt:(NSString *)title quizBody:(NSString *)body typeID:(NSString *)type quizIMG:(NSMutableArray *)images
{
    self = [super init];
    if (self) {
        self.quizTitle = title;
        self.quizBody = body;
        self.typeID = type;
        self.imgArr = images;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    cTag = 0;
    cTagArr = [[NSMutableDictionary alloc]initWithCapacity:0];
    rect = [UIScreen mainScreen].applicationFrame;
    tagWithRow = [[NSMutableDictionary alloc]initWithCapacity:0];
    self.bTagArr = [[NSMutableArray alloc]initWithCapacity:0];
    self.navigationItem.title =@"添加标签";
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(sendQuiz)];
    rightButton.tintColor = [UIColor colorWithRed:29.0/255.0 green:126.0/255.0 blue:183.0/255.0 alpha:1];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    _titleArr = [[NSArray alloc]initWithObjects:@"SQL",@"Linux",@"Html",@"Nodej.s",@"C#",@"Javascript", nil];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 100, rect.size.width, rect.size.height) style:UITableViewStylePlain];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.scrollEnabled =NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    tagView = [[UIView alloc]initWithFrame:CGRectMake(0, 99, rect.size.width, 50)];
    tagView.frame = CGRectMake(0, 100, rect.size.width, 50);
    tagView.backgroundColor = [UIColor whiteColor];
    UIButton *delBtn = [UIButton buttonWithType:0];
    [delBtn setBackgroundImage:[UIImage imageNamed: @"X.png"] forState:0];
    delBtn.frame= CGRectMake(tagView.frame.size.width-28, 15, 20, 20);
    [delBtn addTarget:self action:@selector(delTags) forControlEvents:UIControlEventTouchUpInside];
    [tagView addSubview:delBtn];
}
-(void)sendQuestion
{
    [self sendImages];
    ZhiyiHTTPRequest *manager =[ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    NSLog(@"%@",self.typeID);
    if (self.typeID == NULL) {
         [dic setObject:@"1" forKey:@"typeid"];
    } else {
         [dic setObject:self.typeID forKey:@"typeid"];
    }
   
    [dic setObject:self.quizTitle forKey:@"title"];
    [dic setObject:self.quizBody forKey:@"content"];
    NSString *tags;
    NSArray *arr = [self.textDic allValues];
    for (NSString *str in arr) {
        tags = [NSString stringWithFormat:@"%@,",str];
    }
    [manager sendQuizText:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *msg = [responseObject objectForKey:@"msg"];
        if ([msg isEqual:@"ok"]) {
//            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:@"发布成功！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else
        {
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)sendImages
{
    for (int i = 0; i < self.imgArr.count; i++) {
        ZhiyiHTTPRequest *manager =[ZhiyiHTTPRequest manager];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
        [dic setObject:self.quizTitle forKey:@"str"];
        [manager sendQuizImage:dic constructing:^(id<AFMultipartFormData> formData) {
            UIImage *image = (UIImage *)[self.imgArr objectAtIndex:i];
            NSData *dataImg=UIImageJPEGRepresentation(image, 0.1);
            NSString *baseStr = [dataImg base64Encoding];
            NSString *baseString = (__bridge NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)baseStr,NULL,CFSTR(":/?#[]@!$&’()*+,;="),kCFStringEncodingUTF8);
            [formData appendPartWithFormData:dataImg name:baseString];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    TagsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        NSArray *cellArr = [[NSBundle mainBundle]loadNibNamed:@"TagsCell" owner:nil options:nil];
        cell = [cellArr objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    cell.isClick = NO;
    [cell.select setImage:[UIImage imageNamed:@"check 拷贝.png"]];
    cell.select.hidden =NO;
    cell.textLabel.text = [_titleArr objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor grayColor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TagsCell *cell = (TagsCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (selects<3) {
        cell.isClick = !cell.isClick;
    if (cell.isClick == YES) {
            selects++;
            [self.textDic setObject:cell.textLabel.text forKey:cell.textLabel.text];
            [cell.select setImage:[UIImage imageNamed:@"check .png"]];
        
    }else
    {
        isRemove = NO;
        selects--;
        [self.textDic removeObjectForKey:cell.textLabel.text];
        [cell.select setImage:[UIImage imageNamed:@"check 拷贝.png"]];
        ChooseButton *btn = (ChooseButton *)[tagView viewWithTag:indexPath.row];
        [cTagArr setObject:[NSString stringWithFormat:@"%ld", (long)btn.cTag] forKey:[NSString stringWithFormat:@"%ld", (long)btn.cTag]];
        [btn removeFromSuperview];
    }
    }else
    {
        if (cell.isClick == YES) {
            isRemove = NO;
            cell.isClick = NO;
            [cell.select setImage:[UIImage imageNamed:@"check 拷贝.png"]];
            selects--;
            [self.textDic removeObjectForKey:cell.textLabel.text];
            ChooseButton *btn = (ChooseButton *)[tagView viewWithTag:indexPath.row];
            [cTagArr setObject:[NSString stringWithFormat:@"%ld", (long)btn.cTag] forKey:[NSString stringWithFormat:@"%ld", (long)btn.cTag]];
            [btn removeFromSuperview];
            if (selects == 0) {
                isRemove =NO;
            }
        }
    }
    if (selects>0 && cell.isClick == YES) {
        if (selects == 1) {
            [UIView animateWithDuration:0.5 animations:^{
                NSLog(@"y   %f",self.tableView.frame.origin.y);
                self.tableView.frame =CGRectMake(0, 139, self.tableView.frame.size.width, self.tableView.frame.size.height);
            }];
        }
        if (isRemove == NO && cTagArr.count == 0) {
            [self.bTagArr addObject:[NSString stringWithFormat:@"%ld", (long)selects]];
            titleBtn = [ChooseButton buttonWithType:0];
            titleBtn.backgroundColor  =[UIColor whiteColor];
            
            [titleBtn.layer setBorderWidth:0.5]; //边框宽度
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 176.0/255.0, 169.0/255.0, 165.0/255.0, 1 });
            [titleBtn.layer setBorderColor:colorref];
            cTag++;
            titleBtn.cTag = cTag;
            titleBtn.tag = indexPath.row;
            titleBtn.frame = CGRectMake(8 + 68*(selects-1), -1, 60, 34);
            [self.textDic setObject:cell.textLabel.text forKey:cell.textLabel.text];
            [titleBtn setTitle:cell.textLabel.text forState:0];
            titleBtn.titleLabel.font = [UIFont systemFontOfSize:10.0];
            titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            titleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
            [titleBtn setTitleColor:[UIColor colorWithRed:20.0/255 green:98.0/255 blue:255.0/255 alpha:1] forState:0];
            [titleBtn addTarget:self action:@selector(removeBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Xo.png"]];
            image.frame = CGRectMake(35, 7, 20, 20);
            
            [tagWithRow setValue:[NSString stringWithFormat:@"%ld",(long)titleBtn.tag] forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            
            [titleBtn addSubview:image];
            [tagView addSubview:titleBtn];
            [self.view addSubview:tagView];
        }else
        {
            [_bTagArr addObject:[NSString stringWithFormat:@"%ld", (long)selects]];
            titleBtn = [ChooseButton buttonWithType:0];
            titleBtn.backgroundColor  =[UIColor whiteColor];
            [titleBtn setTitle:cell.textLabel.text forState:0];

            titleBtn.titleLabel.font = [UIFont systemFontOfSize:10.0];
            [self.textDic setObject:cell.textLabel.text forKey:cell.textLabel.text];
            [titleBtn.layer setBorderWidth:0.5]; //边框宽度
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 176.0/255.0, 169.0/255.0, 165.0/255.0, 1 });
            [titleBtn.layer setBorderColor:colorref];
            
            titleBtn.tag = indexPath.row;
            NSArray *tagArr = [cTagArr allKeys];
            NSString * btY = [tagArr objectAtIndex:0];
            if (tagArr.count == 1) {
                isRemove = YES;
            }
            titleBtn.frame = CGRectMake(8 + 68*([btY intValue]-1), -1, 60, 34);
            [cTagArr removeObjectForKey:btY];
            titleBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
            [titleBtn setTitleColor:[UIColor colorWithRed:20.0/255 green:98.0/255 blue:255.0/255 alpha:1] forState:0];
            [titleBtn addTarget:self action:@selector(removeBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Xo.png"]];
            image.frame = CGRectMake(35, 7, 20, 20);
            
            [tagWithRow setValue:[NSString stringWithFormat:@"%ld",(long)titleBtn.tag] forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            
            [titleBtn addSubview:image];
            [tagView addSubview:titleBtn];
            [self.view addSubview:tagView];

        }
        
    }else if(selects == 0)
    {
        [tagView removeFromSuperview];
        self.tableView.frame =CGRectMake(0, self.tableView.frame.origin.y-50, self.tableView.frame.size.width, self.tableView.frame.size.height);
        [self viewDidLoad];
    }
    
}
-(void)delTags
{
    selects = 0;
    [self.textDic removeAllObjects];
    [UIView animateWithDuration:0.2 animations:^{
        [tagView removeFromSuperview];
         self.tableView.frame =CGRectMake(0, self.tableView.frame.origin.y-51, self.tableView.frame.size.width, self.tableView.frame.size.height);
    }];
    tagView = nil;
    tagView = [[UIView alloc]init];
    tagView.frame = CGRectMake(0, 100, rect.size.width, 50);
    tagView.backgroundColor = [UIColor whiteColor];
    UIButton *delBtn = [UIButton buttonWithType:0];
    [delBtn setBackgroundImage:[UIImage imageNamed: @"X.png"] forState:0];
    delBtn.frame= CGRectMake(tagView.frame.size.width-28, 15, 20, 20);
    [delBtn addTarget:self action:@selector(delTags) forControlEvents:UIControlEventTouchUpInside];
    [tagView addSubview:delBtn];
    [self.tableView reloadData];
}
-(void)removeBtn:(ChooseButton *)btn
{
    [cTagArr setObject:[NSString stringWithFormat:@"%ld",(long)btn.cTag] forKey:[NSString stringWithFormat:@"%ld",(long)btn.cTag]];
    isRemove = YES;
    NSString *btTag = [NSString stringWithFormat:@"%ld",(long)btn.tag];
    [self.bTagArr addObject:btTag];
    selects--;
    UIButton *reBtn = (UIButton *)btn;
    NSString *key = reBtn.titleLabel.text;
    [self.textDic removeObjectForKey:key];
    [reBtn removeFromSuperview];
    if (selects == 0) {
        [UIView animateWithDuration:0.1 animations:^{
            [tagView removeFromSuperview];
            self.tableView.frame =CGRectMake(0, self.tableView.frame.origin.y-50, self.tableView.frame.size.width, self.tableView.frame.size.height);
        }];
    }
    row = btn.tag;
    TagsCell *cell = (TagsCell *)[self.tableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    cell.isClick = !cell.isClick;
    [cell.select setImage:[UIImage imageNamed:@"check 拷贝.png"]];
    if (selects == 0) {
        [self viewDidLoad];
        isRemove = NO;
    }
}
-(void)sendQuiz
{
    [self sendQuestion];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
