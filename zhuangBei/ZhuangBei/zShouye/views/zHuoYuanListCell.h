//
//  zHuoYuanListCell.h
//  ZhuangBei
//
//  Created by aa on 2020/5/7.
//  Copyright © 2020 aa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "zGoodsContentModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^kefuButtonTapBack)(zGoodsContentModel* model);

@interface zHuoYuanListCell : UITableViewCell


+(zHuoYuanListCell*)instanceWithTableView:(UITableView*)tableView AndIndexPath:(NSIndexPath*)indexPath;

@property(strong,nonatomic)zGoodsContentModel * model;

@property(copy,nonatomic)kefuButtonTapBack kefuButtonTap;

@end

NS_ASSUME_NONNULL_END
