//
//  ZXDTViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/2/24.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "ZXDTViewController.h"
#import "AppDelegate.h"
#import "ZXDTTableViewCell.h"
#import "Passport.h"
#import "ZhiyiHTTPRequest.h"
#import "UIColor+HTMLColors.h"
#import "SYG.h"
#import "UIImageView+WebCache.h"


#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialWechatHandler.h"


@interface ZXDTViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,UMSocialUIDelegate>

@property (strong ,nonatomic)UITableView *tableView;

@property (strong ,nonatomic)NSDictionary *SYGDic;

@end

@implementation ZXDTViewController

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
 
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
   // [self interFace];
    [self addNav];
    [self interFace];
    [self NetWork];
    

}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight  - 64 + 36) style:UITableViewStyleGrouped];
//    _tableView.backgroundColor = [UIColor redColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.allowsSelection = NO;//设置为cell不能点击
    [self.view addSubview:_tableView];
    
    
    NSLog(@"%@  %@",_timeStr,_titleStr);
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, MainScreenWidth - 60, 24)];
    titleLab.text = @"资讯详情";
    [SYGView addSubview:titleLab];
    titleLab.font = [UIFont systemFontOfSize:20];
    titleLab.textColor = [UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 170, 24)];
    [backButton setImage:[UIImage imageNamed:@"GL返回"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,156)];
    [backButton setTitle:@" " forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    backButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    backButton.titleLabel.font = [UIFont systemFontOfSize:17];
    //设置button上字体的偏移量
    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0,-10.0 , 0.0, 0)];
    [SYGView addSubview:backButton];
    
    
    //添加分享按钮
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 60, 20, 50, 30)];
    [shareButton setTitle:@"...." forState:UIControlStateNormal];
    [shareButton setTitleColor:BasidColor forState:UIControlStateNormal];
    [SYGView addSubview:shareButton];
    [shareButton addTarget:self action:@selector(shareButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    
    
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:_tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height + 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"culture";
    //自定义cell类
    ZXDTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ZXDTTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    cell.titleLabel.text = _titleStr;
    NSString *timeStr = [NSString stringWithFormat:@"发布时间：%@",_timeStr];
    cell.timeLabel.text = timeStr;
    cell.readLabel.text = [NSString stringWithFormat:@"阅读：%@",_readStr];
    NSString *ZYStr = [NSString stringWithFormat:@"摘要：%@",_ZYStr];

    [cell setIntroductionText:ZYStr];
    NSMutableAttributedString *needStr = [[NSMutableAttributedString alloc] initWithString:ZYStr];
    [needStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1] range:NSMakeRange(0, 3)];
    [cell.ZYLabel setAttributedText:needStr] ;
    
    NSString *HH = [NSString stringWithFormat:@"%@",_SYGDic[@"text"]];
    
    //将字符串中的HTML 标签 去掉
    NSString *FF = [self filterHTML:HH];
    
    NSString *ZWStr = [NSString stringWithFormat:@"      %@",FF];
    [cell setZWText:ZWStr];
    
    
//    //添加网络视图
//    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(cell.ZYLabel.frame), MainScreenWidth,CGRectGetHeight(cell.GDLabel.frame))];
//    webView.userInteractionEnabled = NO;
//    [cell addSubview:webView];
//
//    NSString *html_str = [NSString stringWithFormat:@"%@",_SYGDic[@"text"]];
//
//    [webView loadHTMLString:html_str baseURL:nil];
//    
    
    
    //添加testView
    
//    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(cell.ZYLabel.frame), MainScreenWidth, CGRectGetHeight(cell.GDLabel.frame))];
//    textView.text = FF;
//    NSString *html = @"<img src=\"http://cdn.v2ex.com/site/logo@2x.png\"/>";
//    NSDictionary *options = @{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType};
//    NSAttributedString *string = [[NSAttributedString alloc] initWithData:[html dataUsingEncoding:NSUnicodeStringEncoding] options:options documentAttributes:nil error:nil];
//    //textView是UITextView
//    [textView setAttributedText:string];
//
//    [cell addSubview:textView];
//    textView.text= FF;
//
//    
//    NSArray *imageUrlArray = [self filterHTMLWithArray:_SYGDic[@"text"]];
//    NSLog(@"----%@",imageUrlArray);
    
    
    
//    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithAttributedString:textView.attributedText];
//    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil] ;
//    textAttachment.image = Image(@"01"); //要添加的图片
//    NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment] ;
//    [string insertAttributedString:textAttachmentString atIndex:10];//index为用户指定要插入图片的位置
//    textView.attributedText = string;
//    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//详情里面的请求
- (void)NetWork {
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:_ID forKey:@"id"];
    NSLog(@"%@",_ID);
    [manager ZXXQ:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//
        
//        NSLog(@"%@",responseObject);
        _SYGDic = responseObject[@"data"];
//
//        UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
//        
//        [self.view addSubview:webView];
//        
//        NSString *html_str = [NSString stringWithFormat:@"%@",_SYGDic[@"text"]];
//        
//        [webView loadHTMLString:html_str baseURL:nil];
//        
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error   %@",error);
    }];
    
    
}


//去掉HTML字符
-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    // NSString * regEx = @"<([^>]*)>";
    // html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}

- (NSArray *)filterHTMLWithArray:(NSString *) webString
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


#pragma mark --- 带图片的文本
- (NSAttributedString *)stringWithUIImage:(NSString *) contentStr {
    // 创建一个富文本
    NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
    // 修改富文本中的不同文字的样式
    [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, 5)];
    [attriStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, 5)];
    
    /**
     添加图片到指定的位置
     */
    NSTextAttachment *attchImage = [[NSTextAttachment alloc] init];
    // 表情图片
    attchImage.image = [UIImage imageNamed:@"jiedu"];
    // 设置图片大小
    attchImage.bounds = CGRectMake(0, 0, 40, 15);
    NSAttributedString *stringImage = [NSAttributedString attributedStringWithAttachment:attchImage];
    [attriStr insertAttributedString:stringImage atIndex:2];
    
    // 设置数字为红色
    /*
     [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5, 9)];
     [attriStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30] range:NSMakeRange(5, 9)];
     */
    //NSDictionary * attrDict = @{ NSFontAttributeName: [UIFont fontWithName: @"Zapfino" size: 15],
    // NSForegroundColorAttributeName: [UIColor blueColor] };
    
    //创建 NSAttributedString 并赋值
    //_label02.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict];
    NSDictionary * attriBute = @{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:30]};
    [attriStr addAttributes:attriBute range:NSMakeRange(5, 9)];
    
    // 添加表情到最后一位
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
    attch.image = [UIImage imageNamed:@"jiedu"];
    
    // 设置图片大小
    attch.bounds = CGRectMake(0, 0, 40, 15);
    
    // 创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attriStr appendAttributedString:string];
    
    return attriStr;
}




- (void)shareButtonCilck {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl]];
    
    
    NSString *str2 = [NSString stringWithFormat:@"/news/%@.html",_ID];
    NSString *shareUrl = [NSString stringWithFormat:@"%s%@",BasidUrl,str2];
    
    [UMSocialWechatHandler setWXAppId:@"wxbbb961a0b0bf577a" appSecret:@"eb43d9bc799c4f227eb3a56224dccc88" url:shareUrl];
    [UMSocialQQHandler setQQWithAppId:@"101400042" appKey:@"a85c2fcd67839693d5c0bf13bec84779" url:shareUrl];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"3997129963" secret:@"da07bcf6c9f30281e684f8abfd0b4fca" RedirectURL:shareUrl];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"574e8829e0f55a12f8001790"
                                      shareText:_titleStr
                                     shareImage:imageView.image
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,nil]
                                       delegate:self];
    
}



@end
