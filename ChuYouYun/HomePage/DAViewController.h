//
//  DAViewController.h
//  DAContextMenuTableViewControllerDemo
//
//  Created by Daria Kopaliani on 7/24/13.
//  Copyright (c) 2013 Daria Kopaliani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAContextMenuTableViewController.h"

@interface DAViewController : DAContextMenuTableViewController
@property(strong, nonatomic)NSString *typeStr;
@property(strong, nonatomic)NSMutableArray *muArr;
@property(assign, nonatomic)NSString *type;
-(void)requestData:(NSString *)type;
- (void)headerRerefreshing:(NSString *)type;
@end
