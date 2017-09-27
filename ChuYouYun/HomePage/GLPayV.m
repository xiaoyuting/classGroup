//
//  GLPayV.m
//  dafengche
//
//  Created by IOS on 16/12/23.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "GLPayV.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "MyHttpRequest.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"

@interface GLPayV ()<UIScrollViewDelegate,UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    NSDictionary *dict;
    BOOL isArgree;//同意支付协议
    CGRect _frame;
    NSString *_cid;
    
    //购买接口dic
    NSDictionary *_buydic;
    NSString *_buymod;
    NSString *_buyact;
    
    //优惠券接口
    NSDictionary *_YHJdic;
    NSString *_YHJmod;
    NSString *_YHJact;
    //价格
    NSString *_price;
    
    //使用优惠券
    UILabel *counpLabel;
    
    UILabel *needMoney;
    
    //选择的按钮
    UIButton *counpButton;
    
    //支付宝链接
    NSString *_aliPayUrl;
    
    //微信链接
    NSString *_WXPayUrl;
    
    
}

@property (strong ,nonatomic)UIView *allView;
@property (nonatomic ,strong)UIView *buyView;

@property (strong ,nonatomic)UIButton *allButton;
@property (strong ,nonatomic)UITableView *poptableView;
@property (strong ,nonatomic)NSArray *counpArray;

@property (strong ,nonatomic)UIWebView *webView;



@end

@implementation GLPayV

-(instancetype)initWithFrame:(CGRect)frame ALiPayUrl:(NSString *)aliPay WXPayUrl:(NSString *)WXPay withPrice:(NSString *)price{
    
    self = [super initWithFrame:frame];
    
    if ( self) {
        
        _price = price;
        _aliPayUrl = aliPay;
        _WXPayUrl = WXPay;
        [self initUI];
    }
    return self;
}

-(void)MissBuyView{
    
    [self removeFromSuperview];
}
-(void)initUI{
    
    [self SYGBuy];
}

- (void)SYGBuy {
    
    _allView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    _allView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:_allView];
    
    //添加中间的按钮
    _allButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    [_allButton setBackgroundColor:[UIColor clearColor]];
    [_allButton addTarget:self action:@selector(MissBuyView) forControlEvents:UIControlEventTouchUpInside];
    [_allView addSubview:_allButton];
    
    //创建个VIew
    CGFloat BuyViewW = MainScreenWidth / 4 * 3;
    _buyView = [[UIView alloc] init];
    _buyView.center = self.center;
    _buyView.bounds = CGRectMake(0, 0,MainScreenWidth / 4 * 3, 250);
    _buyView.backgroundColor = [UIColor colorWithRed:254.f / 255 green:255.f / 255 blue:255.f / 255 alpha:1];
    _buyView.layer.cornerRadius = 5;
    [_allView addSubview:_buyView];
    
    //view上面添加空间
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,BuyViewW , 40)];
    topLabel.text = @"购买提示";
    topLabel.font = Font(18);
    topLabel.backgroundColor = BasidColor;
    topLabel.textColor = [UIColor whiteColor];
    topLabel.textAlignment = NSTextAlignmentCenter;
    [_buyView addSubview:topLabel];
    
    needMoney = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, 50, BuyViewW - SpaceBaside - 20, 20)];
    needMoney.font = Font(14);
    
    [_buyView addSubview:needMoney];
    
    NSString *str = [NSString stringWithFormat:@"该专辑需支付:  %@ 元",_price];
    
    NSMutableAttributedString *attrDescribeStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    [attrDescribeStr addAttribute:NSForegroundColorAttributeName
     
                            value:BasidColor
     
                            range:[str rangeOfString:_price]];
    
    needMoney.attributedText = attrDescribeStr;
    
    //使用优惠券
    counpLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, 80, BuyViewW - 40, 20)];
    counpLabel.text = @"使用优惠券：";
    counpLabel.font = Font(14);
    [_buyView addSubview:counpLabel];
    
    //选择的按钮
    counpButton = [[UIButton alloc] initWithFrame:CGRectMake(BuyViewW - 30, 80, 20, 20)];
    [counpButton setImage:Image(@"GLIMG1") forState:UIControlStateNormal];
    counpButton.tag = 0;
    [_buyView addSubview:counpButton];
    
    //选择的按钮
    UIButton *counpBut = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside +90, 80, BuyViewW - 90 - SpaceBaside, 20)];
    [counpBut addTarget:self action:@selector(counpButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_buyView addSubview:counpBut];
    
    //添加同意按钮
    isArgree = YES;
    UIButton *argreeButton = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside, 110, 20, 20)];
    [argreeButton setBackgroundImage:Image(@"支付同意") forState:UIControlStateNormal];
    [argreeButton setBackgroundImage:Image(@"支付未同意") forState:UIControlStateSelected];
    [argreeButton addTarget:self action:@selector(isArgree:) forControlEvents:UIControlEventTouchUpInside];
    [_buyView addSubview:argreeButton];
    //是否同意协议
    UILabel *argreeLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 110, BuyViewW, 20)];
    argreeLabel.text = @"我已阅读并同意《收费课程服务协议》";
    argreeLabel.font = Font(13);
    argreeLabel.textColor = [UIColor colorWithRed:145.f / 255 green:148.f / 255 blue:155.f / 255 alpha:1];
    [_buyView addSubview:argreeLabel];
    
    //添加几个按钮
    NSArray *titleString = @[@"支付宝",@"微信",@"取消"];
    CGFloat ButtonW = (BuyViewW - 6 * SpaceBaside) / 3;
    
    for (int i = 0 ; i < 3; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside + (2 * SpaceBaside + ButtonW) * i , 150 ,ButtonW, 35)];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitle:titleString[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:145.f / 255 green:148.f / 255 blue:155.f / 255 alpha:1] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorWithRed:232.f / 255 green:235.f / 255 blue:243.f / 255 alpha:1];
        button.layer.cornerRadius = 5;
        button.tag = 1104 + i;
        [button addTarget:self action:@selector(pressed:) forControlEvents:UIControlEventTouchUpInside];
        [_buyView addSubview:button];
        _buyView.frame = CGRectMake(0, 0, BuyViewW, CGRectGetMaxY(button.frame) + SpaceBaside);
        _buyView.center = self.center;
    }
    
    _poptableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    _poptableView.delegate = self;
    _poptableView.dataSource = self;
    _poptableView.rowHeight = 50;
    _poptableView.tag = 1230;
    _poptableView.backgroundColor = [UIColor whiteColor];
    _frame = CGRectMake(counpLabel.current_x, counpLabel.current_y_h, counpLabel.current_w, 300);
    [_buyView addSubview:_poptableView];
    
    //这里获取优惠券的数据
    [self NetWorkGetMyCouponList];
    
}
#pragma mark --- 获取优惠券的类型

- (void)NetWorkGetMyCouponList {
    
    QKHTTPManager * manager = [QKHTTPManager manager];
    
    [manager getpublicPort:_YHJdic mod:_YHJmod act:_YHJact success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *str = [NSString stringWithFormat:@"使用优惠券：%@",@"没有可用的优惠券"];
        
        NSMutableAttributedString *attrDescribeStr = [[NSMutableAttributedString alloc] initWithString:str];
        
        [attrDescribeStr addAttribute:NSForegroundColorAttributeName
         
                                value:BasidColor
         
                                range:[str rangeOfString:@"没有可用的优惠券"]];
        
        counpLabel.attributedText = attrDescribeStr;
        
        NSLog(@"======  %@",responseObject);
        if ([responseObject[@"code"] integerValue] == 1) {
            
            _counpArray = responseObject[@"data"];
            
            if (_counpArray.count == 0) {
                
            }else{
                
                NSString *str = [NSString stringWithFormat:@"使用优惠券：%@",@"请选择优惠券"];
                
                NSMutableAttributedString *attrDescribeStr = [[NSMutableAttributedString alloc] initWithString:str];
                
                [attrDescribeStr addAttribute:NSForegroundColorAttributeName
                 
                                        value:BasidColor
                 
                                        range:[str rangeOfString:@"请选择优惠券"]];
                
                counpLabel.attributedText = attrDescribeStr;
                
            }
            
        } else {
            
            _counpArray = nil;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)counpButtonClick:(UIButton *)sender {
    
    if (!_counpArray.count) {
        [MBProgressHUD showError:@"没有可使用的优惠券" toView:self];
        return;
    }
    
    if (_poptableView) {
        if (_poptableView.frame.origin.x==0) {
            _poptableView.frame = _frame;
            [counpButton setImage:Image(@"GLIMG0") forState:UIControlStateNormal];
            
        }else{
            _poptableView.frame = CGRectMake(0, 0, 0, 0);
            [counpButton setImage:Image(@"GLIMG1") forState:UIControlStateNormal];
            
        }
    }
}

#pragma mark --- 支付同意
- (void)isArgree:(UIButton *)button {
    
    if (isArgree == NO) {
        
        isArgree = YES;
        [button setBackgroundImage:Image(@"支付同意") forState:UIControlStateNormal];
        
    } else if (isArgree == YES) {
        
        isArgree = NO;
        [button setBackgroundImage:Image(@"支付未同意") forState:UIControlStateNormal];
    }
}

- (void)pressed:(UIButton *)button {
    
    NSInteger Num = button.tag;
    if (Num == 1104 ) {//支付宝
        
        if (isArgree == NO) {
            [MBProgressHUD showError:@"请先同意协议" toView:self];
            return;
        } else {
            [self LiveAlipay];
        }
    } else if (Num == 1105) {//微信
        if (isArgree == NO) {
            [MBProgressHUD showError:@"请先同意协议" toView:self];
            return;
        }
    }
    [self MissBuyView];
    
}

//购买课程 获取支付的链接
- (void)LiveAlipay {
    

    QKHTTPManager * manager = [QKHTTPManager manager];
    
    NSLog(@"====%@",_buydic);
    
    [manager getpublicPort:_buydic mod:_buymod act:_buyact success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"======  %@",responseObject);
        
        NSString *msg = responseObject[@"msg"];
        if (![msg isEqualToString:@"ok"]) {
            [MBProgressHUD showError:msg toView:self.window];
            
        }
        if ([responseObject[@"code"] integerValue] == 1) {
            if ([responseObject[@"data"][@"is_free"] integerValue] == 0 ) {//不是免费
                _aliPayUrl = responseObject[@"data"][@"alipay"][@"ios"];
                
                if (_aliPayUrl.length) {
                    
                    [self addWebView];
                    
                    return;
                    
                }else{
                    
                    [MBProgressHUD showError:@"暂时不能购买" toView:self.window];
                    return;
                    
                }
            } else {//免费
                [MBProgressHUD showSuccess:@"购买成功" toView:self];
            }
        } else {
            
            [MBProgressHUD showError:msg toView:self];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
    }];
    
}
#pragma mark --- 网络试图

- (void)addWebView {
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
    [_webView setUserInteractionEnabled:YES];//是否支持交互
    _webView.delegate=self;
    [_webView setOpaque:YES];//opaque是不透明的意思
    [_webView setScalesPageToFit:YES];//自适应
    
    NSURL *url = [NSURL URLWithString:_aliPayUrl];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    // [self addSubview:_webView];
}


#pragma mark -- UITableViewDatasoure

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _counpArray.count +1 ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSString * identifier= @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,_frame.size.width, 50)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor blackColor];
    [cell.contentView addSubview:lab];
    
    if (indexPath.row == 0) {
        
        lab.text = @"不使用优惠券";
        
    }else{
        
        lab.text = [NSString stringWithFormat:@"type == %@",_counpArray[indexPath.row - 1][@"type"]];
    }
    cell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *text;
    if (indexPath.row == 0) {
        
        text = @"不使用优惠券";
        
    }else{
        
        text = [NSString stringWithFormat: @"%@",_counpArray[indexPath.row -1][@"type"]];
        
    }
    NSString *str = [NSString stringWithFormat:@"使用优惠券：  %@",text];
    
    NSMutableAttributedString *attrDescribeStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    [attrDescribeStr addAttribute:NSForegroundColorAttributeName
     
                            value:BasidColor
     
                            range:[str rangeOfString:text]];
    
    counpLabel.attributedText = attrDescribeStr;
    
    [_poptableView deselectRowAtIndexPath:indexPath animated:NO];
    _poptableView.frame = CGRectMake(0, 0, 0, 0);
    [counpButton setImage:Image(@"GLIMG1") forState:UIControlStateNormal];
    
    return;
    
}



@end
