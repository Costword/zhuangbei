//
//  zNoticeUpDownCell.h
//  ZhuangBei
//
//  Created by aa on 2020/7/20.
//  Copyright © 2020 aa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface zNoticeUpDownCell : UITableViewCell

+(zNoticeUpDownCell*)instanceWithTableView:(UITableView*)tableView AndIndexPath:(NSIndexPath*)indexPath;

@property(strong,nonatomic)NSArray * Array;

@property(strong,nonatomic)NSDictionary * userStateDic;

@property (nonatomic,strong) RACSubject *qiandaoSignal;

@end

NS_ASSUME_NONNULL_END
