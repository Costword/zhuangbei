//
//  zJiaoliuController.m
//  ZhuangBei
//
//  Created by aa on 2020/4/22.
//  Copyright © 2020 aa. All rights reserved.
//

#import "zJiaoliuController.h"
#import "LWSwitchBarView.h"
#import "LWJiaoLiuGroupCollectionReusableView.H"
#import "LWJiaoLiuContatcsListTableViewCell.h"
#import "LWSystemMessageListViewController.h"
#import "LWJiaoLiuModel.h"
#import "MessageGroupViewController.h"
#import "ChatRoomViewController.h"
#import "LWJiaoLiuAddAlearView.h"
#import "LWAddFriendOrGroupViewController.h"
#import "LWUserGroupManagerViewController.h"
#import "LWAddNewChatGroupViewController.h"
#import "LWLocalChatRecordModel.h"
@interface zJiaoliuController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) LWSwitchBarView * switchBarView;
@property (nonatomic, strong) UICollectionView * collectView;
@property (nonatomic, strong) NSMutableArray * listDatas_Group;//群组
@property (nonatomic, strong) NSMutableArray<LWJiaoLiuModel *> * listDatas_JiaoLiu;//交流
@property (nonatomic, strong) NSMutableArray * listDatas_Message;
@property (nonatomic, strong) NSMutableArray<friendListModel *> * listDatas_Contatcs;
@property (nonatomic, strong) NSArray<LWLocalChatRecordModel *> * listDatas_chatrecord;

@property (nonatomic, strong) UITableView * messageTableView;
@property (nonatomic, strong) UITableView * contatcsTableView;
@property (nonatomic, strong) UITableView * groupTableView;
@property (nonatomic, strong) UIScrollView * mainScrollView;
@property (nonatomic, strong) LWJiaoLiuAddAlearView * alearView;
 
@end

@implementation zJiaoliuController


//是否有创建群聊权限
- (void)verifiAccountIsAdmin
{
    [self requestPostWithUrl:@"sys/user/isAdmin" para:@{} paraType:(LWRequestParamTypeDict) success:^(id  _Nonnull response) {
        if ([response[@"code"] intValue] == 0) {
            NSInteger isAdmin = [response[@"isAdmin"] intValue];
            if (isAdmin == 1) {
                [self.navigationController pushViewController:[LWAddNewChatGroupViewController new] animated:YES];
            }else{
                [zHud showMessage:@"该账号没有创建群聊权限"];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

//联盟
- (void)requestJiaoLiuDatas
{
    
//    [self requestPostWithUrl:@"app/imgroupclassify/findListByTypeId" paraString:@{@"typeId":@"1,2,4"}
    [self requestPostWithUrl:@"/app/imgroupclassify/findListApp" Parameters:@{} success:^(id  _Nonnull response) {
        NSLog(@"联盟数据:%@",response);
        [self.self.listDatas_JiaoLiu removeAllObjects];
        NSArray *data = response[@"data"];
        if (data&&data.count > 0) {
            for (NSDictionary*dict  in data) {
                [self.listDatas_JiaoLiu addObject:[LWJiaoLiuModel modelWithDictionary: dict]];
            }
        }
        [self.collectView.mj_header endRefreshing];
        [self.collectView reloadData];
        [[zHud shareInstance] hild];
    } failure:^(NSError * _Nonnull error) {
        [[zHud shareInstance] hild];
        [self.collectView.mj_header endRefreshing];
    }];
}

//群组、联系人
- (void)requestDatas
{
    [self requestJiaoLiuDatas];
    
    [self requestPostWithUrl:@"app/appfriendtype/getFriendTypeAndFriendListV2" Parameters:@{} success:^(id  _Nonnull response) {
        NSDictionary *data = response[@"data"];
        [self.listDatas_Contatcs removeAllObjects];
        NSArray *friend = data[@"friend"];
        for (NSDictionary*dict  in friend) {
            [self.listDatas_Contatcs addObject:[friendListModel modelWithDictionary: dict]];
        }
        NSArray *group = data[@"group"];
        [self.listDatas_Group removeAllObjects];
        
        for (NSDictionary*dict  in group) {
            [self.listDatas_Group addObject:[LWJiaoLiuModel modelWithDictionary: dict]];
        }
        [self.groupTableView reloadData];
        [self.contatcsTableView reloadData];
        [self.contatcsTableView.mj_header endRefreshing];
        [self.groupTableView.mj_header endRefreshing];
//        [[zHud shareInstance] hild];
    } failure:^(NSError * _Nonnull error) {
//        [[zHud shareInstance] hild];
        [self.contatcsTableView.mj_header endRefreshing];
        [self.groupTableView.mj_header endRefreshing];
    }];
}

// 切换switch标签
- (void)clickSwitchBarEvent:(NSInteger)tag
{
    [self.mainScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*tag, 1) animated:YES];
}

//点击新增
- (void)clickaddBtnBtn
{
    [self.alearView showView];
    WEAKSELF(self)
    self.alearView.block = ^(NSInteger index) {
        if (index == 1) {
            [weakself.navigationController pushViewController:[LWAddFriendOrGroupViewController new] animated:YES];
        }else if (index == 2){
            [weakself.navigationController pushViewController:[LWUserGroupManagerViewController new] animated:YES];
        }else if (index == 0){
            [weakself verifiAccountIsAdmin];
        }
    };
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];

    if (_switchBarView) {
        [self.mainScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*self.switchBarView.currentIndex, 1) animated:NO];
    }
}

- (void)refreshChatRecordList
{
    self.listDatas_chatrecord = [LWClientManager getLocalChatRecord];
    if (_messageTableView) {
        [_messageTableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"交流大厅";
    [self confiUI];
    [self requestDatas];
    
    [self.nothingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(36+40+NAVIGATOR_HEIGHT);
    }];
    [self.noContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.nothingView);
    }];
    
    ADD_NOTI(requestDatas, @"refreshJiaoLiuListDataKey");
//    刷新本地的聊天记录
    ADD_NOTI(refreshChatRecordList, @"refreshChatRecordList");
    
    self.listDatas_chatrecord = [LWClientManager getLocalChatRecord];
    if (_messageTableView) {
        [_messageTableView reloadData];
    }
    //    操作分组后，刷新联系人列表
    ADD_NOTI(requestDatas, @"refreshUserGroupListData");
//    添加好友后刷新好友y列表
    ADD_NOTI(requestDatas, @"refreshFriendListDataWhenAgreeFriendApply");
    ADD_NOTI(requestDatas, @"refreshFriendListDataWhenDeleteFriend");
//    未读消息数变化时
    ADD_NOTI(unreadMsgNumberChange, LOCAL_UNREAD_MSG_LIST_CHANGE_NOTI_KEY);
    
    ADD_NOTI(clickRemoteNotificationAleart,USER_CLICKREMOTENOTIFICATIONALEART);
}

- (void)clickRemoteNotificationAleart {
    self.switchBarView.selectIndex = 0;
}

//监听消息未读数
- (void)unreadMsgNumberChange
{
    [self refreshChatRecordList];

    NSInteger num = [LWClientManager share].unreadMsgNum + LWClientManager.share.unreadSysMsgNum;
    self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",(long)num];
    [self haveSystemMsgRefreshUI:LWClientManager.share.unreadSysMsgNum > 0];
}

- (void)confiUI
{
    WEAKSELF(self)
    self.switchBarView = [LWSwitchBarView switchBarView:@[@"消息",@"联盟",@"群组",@"联系人",] clickBlock:^(UIButton * _Nonnull btn) {
        [weakself clickSwitchBarEvent:btn.tag];
    }];
    [self.view addSubview:self.switchBarView];
    [self.switchBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).mas_offset(20);
        make.height.mas_offset(36);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(20);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-20);
        make.width.greaterThanOrEqualTo(@(340));
    }];
    
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [addBtn setImage:IMAGENAME(@"addnewicon") forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(clickaddBtnBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
    
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.left.mas_equalTo(self.view);
        make.top.mas_equalTo(self.switchBarView.mas_bottom).mas_offset(10);
    }];
}

//是否需要隐藏
- (void)haveSystemMsgRefreshUI:(BOOL)isShow
{
    LWJiaoLiuMessageListTableViewCell *cell = [self.messageTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.systemL.hidden = !isShow;
}

#pragma mark ------UITableViewDelegate----------

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _contatcsTableView || tableView == _groupTableView) {
        LWJiaoLiuContatcsListTableViewCell * cell =  [tableView dequeueReusableCellWithIdentifier:@"LWJiaoLiuContatcsListTableViewCell" forIndexPath:indexPath];
        
        if (tableView == _groupTableView) {
            LWJiaoLiuModel *model = self.listDatas_Group[indexPath.section];
            imGroupListModel *itemmodel = model.list[indexPath.row];
            cell.nameL.text = itemmodel.groupName;
            [cell.icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kApiPrefix_PIC,itemmodel.avatar]] placeholderImage:IMAGENAME(@"testtouxiang")];
            cell.tapbtn.hidden = (itemmodel.status == 1);
        }else{
            friendListModel *listmodel = self.listDatas_Contatcs[indexPath.section];
            friendItemModel *itemModel = listmodel.list[indexPath.row];
            cell.nameL.text = itemModel.username;
            [cell.icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kApiPrefix_PIC,itemModel.avatar]] placeholderImage:IMAGENAME(@"testtouxiang")];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        if(indexPath.row == 0){
            LWJiaoLiuMessageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LWJiaoLiuMessageListTableViewCell" forIndexPath:indexPath];
            cell.nameL.text = @"系统消息";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.systemL.hidden = LWClientManager.share.unreadSysMsgNum == 0;
            return cell;
        }else{
            LWJiaoLiuContatcsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LWJiaoLiuContatcsListTableViewCell" forIndexPath:indexPath];
            LWLocalChatRecordModel *model = self.listDatas_chatrecord[indexPath.row - 1];
            cell.nameL.text = model.roomName;
            [cell.icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kApiPrefix_PIC,model.avatar]] placeholderImage:IMAGENAME(@"testtouxiang")];
            [cell setunreadNumber:model.unreadNum];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _contatcsTableView) {
        friendListModel *listmodel = self.listDatas_Contatcs[section];
        return listmodel.isShow ? listmodel.list.count : 0;
    }
    if(tableView == _groupTableView){
        LWJiaoLiuModel *listmodel = self.listDatas_Group[section];
        return listmodel.isShow ? listmodel.list.count : 0;
    }
    if (tableView == _messageTableView) {
        return self.listDatas_chatrecord.count + 1;
    }
    return  1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _contatcsTableView) {
        return self.listDatas_Contatcs.count;
    }else if (tableView == _groupTableView){
        return self.listDatas_Group.count;
    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _contatcsTableView || tableView == _groupTableView) {
        
        __block LWJiaoLiuContatcsSeactionView *seactionview = [[LWJiaoLiuContatcsSeactionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        
        if (tableView == _contatcsTableView) {
            
            friendListModel *listmodel = self.listDatas_Contatcs[section];
            seactionview.leftL.text = listmodel.groupname;
            WEAKSELF(self)
            seactionview.block = ^(BOOL isShow) {
                listmodel.isShow = isShow;
                [weakself.contatcsTableView reloadData];
            };
            seactionview.rightBtn.selected = listmodel.isShow;
            
        }else if (tableView == _groupTableView){
            
            LWJiaoLiuModel *listmodel = self.listDatas_Group[section];
            seactionview.leftL.text = listmodel.groupname;
            WEAKSELF(self)
            seactionview.block = ^(BOOL isShow) {
                listmodel.isShow = isShow;
                [weakself.groupTableView reloadData];
            };
            seactionview.rightBtn.selected = listmodel.isShow;
        }
        return seactionview;
    }

    return [UIView new];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (_contatcsTableView == tableView || _groupTableView == tableView)? 40:0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _messageTableView) {
        if (indexPath.row == 0) {
            LWSystemMessageListViewController *system = [LWSystemMessageListViewController new];
            [self.navigationController pushViewController:system animated:YES];
        }else{
            LWLocalChatRecordModel *model = self.listDatas_chatrecord[indexPath.row-1];
            if (model.chatType == 1) {
                [self pushToGroupRoom:model.roomId groupname:model.roomName];
            }else{
                [self.navigationController pushViewController:[ChatRoomViewController chatRoomViewControllerWithRoomId:model.roomId roomName:model.roomName roomType:(LWChatRoomTypeOneTOne) extend:model] animated:YES];
            }
        }
    }else if(tableView == _contatcsTableView){
        friendListModel *listmodel = self.listDatas_Contatcs[indexPath.section];
        friendItemModel *itemmodel = listmodel.list[indexPath.row];
        ChatRoomViewController *vc= [ChatRoomViewController chatRoomViewControllerWithRoomId:itemmodel.customId roomName:itemmodel.username roomType:(LWChatRoomTypeOneTOne) extend:itemmodel];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (tableView == _groupTableView){
        LWJiaoLiuModel *mode =  self.listDatas_Group[indexPath.section];
        imGroupListModel *groupmodel = mode.list[indexPath.row];
        [self pushToGroupRoom:groupmodel.customId groupname:groupmodel.groupName];
    }
}

#pragma mark ------UICollectionViewDelegate----------

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LWJiaoLiuGroupCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LWJiaoLiuGroupCollectionCell" forIndexPath:indexPath];
    LWJiaoLiuModel *model = self.listDatas_JiaoLiu[indexPath.section];
    imGroupListModel *groupmodel = model.imGroupList[indexPath.row];
    cell.nameL.text = groupmodel.groupName;
//    [cell.bgImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kApiPrefix,model.avatar]] placeholderImage:IMAGENAME(@"jiaoliulisticon")];
    [cell.bgImageView z_imageWithImageId:groupmodel.appBackgroundImage placeholderImage:@"jiaoliulisticon"];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:@"UICollectionElementKindSectionHeader"]) {
        LWJiaoLiuGroupCollectionReusableView *seactionView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"LWJiaoLiuGroupCollectionReusableView" forIndexPath:indexPath];
        LWJiaoLiuModel *model = self.listDatas_JiaoLiu[indexPath.section];
        seactionView.titleL.text = model.name;
        return seactionView;
    }
    return nil;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.listDatas_JiaoLiu.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    LWJiaoLiuModel *model = self.listDatas_JiaoLiu[section];
    return model.imGroupList.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LWJiaoLiuModel *listmodel = self.listDatas_JiaoLiu[indexPath.section];
    imGroupListModel *groupmodel =  listmodel.imGroupList[indexPath.row];
    if ([groupmodel.customId isNotBlank]) {
        [self pushToGroupRoom:groupmodel.customId groupname:groupmodel.groupName];
    }else{
        [[zHud shareInstance] showMessage:@"未安装直播平台"];
    }
}


/// 跳转群聊室
/// @param groupid 群聊id
/// @param groupname 群聊n名称
- (void)pushToGroupRoom:(NSString *)groupid groupname:(NSString *)groupname
{
    [self.navigationController pushViewController:[MessageGroupViewController chatRoomViewControllerWithRoomId:groupid roomName:groupname roomType:(LWChatRoomTypeGroup) extend:nil] animated:YES];
}

#pragma mark ---------------lazy-------------------
- (UICollectionView *)collectView
{
    if (!_collectView) {
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        flowlayout.minimumLineSpacing = 10;
        flowlayout.minimumInteritemSpacing = 10;
        flowlayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 30);
        flowlayout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
        flowlayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        CGFloat item_w = (SCREEN_WIDTH-50)/2;
        flowlayout.itemSize = CGSizeMake(item_w, item_w*0.7);
        _collectView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowlayout];
        _collectView.backgroundColor = UIColor.whiteColor;
        _collectView.delegate = self;
        _collectView.dataSource = self;
        [_collectView registerClass:[LWJiaoLiuGroupCollectionCell class] forCellWithReuseIdentifier:@"LWJiaoLiuGroupCollectionCell"];
        [_collectView registerClass:[LWJiaoLiuGroupCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LWJiaoLiuGroupCollectionReusableView"];
        _collectView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestJiaoLiuDatas)];
    }
    return _collectView;
}

//消息
- (UITableView *)messageTableView
{
    if (!_messageTableView) {
        _messageTableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        _messageTableView.delegate = self;
        _messageTableView.dataSource = self;
        _messageTableView.rowHeight = 60;
        [_messageTableView registerClass:[LWJiaoLiuMessageListTableViewCell class] forCellReuseIdentifier:@"LWJiaoLiuMessageListTableViewCell"];
        [_messageTableView registerClass:[LWJiaoLiuContatcsListTableViewCell class] forCellReuseIdentifier:@"LWJiaoLiuContatcsListTableViewCell"];
        _messageTableView.backgroundColor = UIColor.whiteColor;
        _messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _messageTableView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestDatas)];
    }
    return _messageTableView;
}

//联系人
- (UITableView *)contatcsTableView
{
    if (!_contatcsTableView) {
        _contatcsTableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        _contatcsTableView.delegate = self;
        _contatcsTableView.dataSource = self;
        _contatcsTableView.rowHeight = 66;
        [_contatcsTableView registerClass:[LWJiaoLiuContatcsListTableViewCell class] forCellReuseIdentifier:@"LWJiaoLiuContatcsListTableViewCell"];
        _contatcsTableView.backgroundColor = UIColor.whiteColor;
        _contatcsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _contatcsTableView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestDatas)];
    }
    return _contatcsTableView;
}

//群组
- (UITableView *)groupTableView
{
    if (!_groupTableView) {
        _groupTableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        _groupTableView.delegate = self;
        _groupTableView.dataSource = self;
        _groupTableView.rowHeight = 66;
        [_groupTableView registerClass:[LWJiaoLiuContatcsListTableViewCell class] forCellReuseIdentifier:@"LWJiaoLiuContatcsListTableViewCell"];
        _groupTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _groupTableView.backgroundColor = UIColor.whiteColor;
        _groupTableView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestDatas)];
    }
    return _groupTableView;
}

- (UIScrollView *)mainScrollView
{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, self.view.height-60-10)];
        _mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*4, 1000);
        _mainScrollView.backgroundColor = UIColor.whiteColor;
        NSArray *sub = @[self.messageTableView,self.collectView,self.groupTableView,self.contatcsTableView,];
        [_mainScrollView addSubviews:sub];
        for (int i = 0; i< sub.count; i++) {
            [sub[i] mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(_mainScrollView);
                make.width.mas_offset(SCREEN_WIDTH);
                make.height.mas_offset(self.view.height - 60 - TABBAR_HIEGHT-NAVIGATOR_HEIGHT);
                make.left.mas_equalTo(_mainScrollView.mas_left).mas_offset(SCREEN_WIDTH*i);
            }];
        }
        _mainScrollView.scrollEnabled = NO;
    }
    return _mainScrollView;
}

- (NSMutableArray *)listDatas_Group
{
    if (!_listDatas_Group) {
        _listDatas_Group = [[NSMutableArray alloc] init];
        
        _listDatas_Message = [[NSMutableArray alloc] initWithArray:@[]];
        _listDatas_Contatcs = [[NSMutableArray alloc] init];
    }
    return _listDatas_Group;
}

- (NSMutableArray *)listDatas_JiaoLiu
{
    if (!_listDatas_JiaoLiu) {
        _listDatas_JiaoLiu = [[NSMutableArray alloc] init];
    }
    return _listDatas_JiaoLiu;
}

- (LWJiaoLiuAddAlearView *)alearView
{
    if (!_alearView) {
        _alearView = [[LWJiaoLiuAddAlearView alloc] init];
    }
    return _alearView;
}

@end
