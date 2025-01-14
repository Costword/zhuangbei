//
//  LWHuoYuanBaseViewController.h
//  ZhuangBei
//
//  Created by LWQ on 2020/4/29.
//  Copyright © 2020 aa. All rights reserved.
//

#import "baseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWHuoYuanBaseViewController : baseViewController
@property (nonatomic, assign) NSInteger baokuanGroupRoomId;


- (void)refreshData;
- (void)requestDatas;
- (void)loadMore;
- (void)showBaoKuanAleartView:(NSString *)msg;
@end

NS_ASSUME_NONNULL_END
