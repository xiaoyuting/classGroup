//
//  SearchView.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/2/26.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchView : UIViewController<UISearchBarDelegate,UITextFieldDelegate,UIScrollViewDelegate>
@property(strong, nonatomic)NSArray *muArr;
@property(strong, nonatomic)UIScrollView *sc;
@property(nonatomic,retain)NSMutableArray * dataArray;
@property (strong ,nonatomic)NSArray      *array;
@end
