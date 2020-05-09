//
//  zJxsLeftMenu.m
//  ZhuangBei
//
//  Created by aa on 2020/5/8.
//  Copyright © 2020 aa. All rights reserved.
//

#import "zJxsLeftMenu.h"
#import "zjxsMenuCell.h"
#import "zHuoYuanModel.h"

@interface zJxsLeftMenu ()<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic)UITableView * menuTableView;

@end

@implementation zJxsLeftMenu

-(UITableView*)menuTableView
{
    if (!_menuTableView) {
        _menuTableView  = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _menuTableView.backgroundColor = [UIColor clearColor];
        _menuTableView.delegate = self;
        _menuTableView.dataSource = self;
        _menuTableView.allowsSelection = YES;
        _menuTableView.estimatedRowHeight = kWidthFlot(44);
        _menuTableView.estimatedSectionHeaderHeight = 2;
        _menuTableView.estimatedSectionFooterHeight = 2;
        _menuTableView.showsVerticalScrollIndicator = NO;
        _menuTableView.rowHeight = UITableViewAutomaticDimension;
        _menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _menuTableView;
}


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
        [self addSubview:self.menuTableView];
        [self updateConstraintsForView];
    }
    return self;
}

-(void)updateConstraintsForView
{
    [self.menuTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return self.menuArray.count;
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return self.menuArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    zjxsMenuCell * cell = [zjxsMenuCell instanceWithTableView:tableView AndIndexPath:indexPath];
    zHuoYuanModel * model =  self.menuArray[indexPath.row];
    cell.model = model;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    zHuoYuanModel * jmodel = weakSelf.menuArray[indexPath.row];
    jmodel.select = !jmodel.select;
   [UIView performWithoutAnimation:^{
       NSIndexPath * indexpath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
      [self.menuTableView reloadRowAtIndexPath:indexpath withRowAnimation:UITableViewRowAnimationNone];
   }];
}

-(void)setMenuArray:(NSArray *)menuArray
{
    NSMutableArray * array = [NSMutableArray array];
    [menuArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        zHuoYuanModel * model = [[zHuoYuanModel alloc]init];
        model.name = [NSString stringWithFormat:@"目录--%ld",idx];
        model.select = NO;
        model.indexSection = idx;
        model.hyArray = @[@"二级目录1",@"二级目录2",@"二级目录3"];
        [array addObject:model];
    }];
    _menuArray = array;
    [self.menuTableView reloadData];
}


@end
