//
//  ChooseTags.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/2/25.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseTags : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic)UITableView *tableView;
@property (strong, nonatomic)NSMutableDictionary *textDic;
@property (weak, nonatomic) IBOutlet UIView *remindView;
@property (strong, nonatomic)NSString *quizTitle;
@property (strong, nonatomic)NSString *quizBody;
@property (strong, nonatomic)NSString *typeID;
@property (strong, nonatomic)NSMutableDictionary *indxDic;
@property (strong, nonatomic)NSMutableArray *imgArr;
@property (strong, nonatomic)NSMutableArray *bTagArr;
-(id)initWithQuizTitlt:(NSString *)title quizBody:(NSString *)body typeID:(NSString *)type quizIMG:(NSMutableArray *)images;
@end
