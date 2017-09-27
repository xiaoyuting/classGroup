//
//  DownLoadTableViewCell.h
//  dafengche
//
//  Created by IOS on 16/9/18.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFDownloadManager.h"

typedef void(^ZFBtnClickBlock)(void);

//@protocol MusicListDelegate <NSObject>
//
//-(void)addDownLoadTaskAction:(NSIndexPath *)indexPath;
//
//@end


@interface DownLoadTableViewCell : UITableViewCell

//@property (assign ,nonatomic) id<MusicListDelegate> delegate;

@property (strong,nonatomic) NSIndexPath *index;

@property (weak, nonatomic) IBOutlet UIImageView *TitleImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIButton *downLoad;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

/** 下载按钮点击回调block */
@property (nonatomic, copy  ) ZFBtnClickBlock  btnClickBlock;
/** 下载信息模型 */
@property (nonatomic, strong) ZFFileModel      *fileInfo;
/** 该文件发起的请求 */
@property (nonatomic,retain ) ZFHttpRequest    *request;
//- (IBAction)downLoadAction:(id)sender;

@end
