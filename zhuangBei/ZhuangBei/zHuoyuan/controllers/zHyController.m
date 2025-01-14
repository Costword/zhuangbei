//
//  zHyController.m
//  ZhuangBei
//
//  Created by aa on 2020/4/22.
//  Copyright © 2020 aa. All rights reserved.
//

#import "zHyController.h"
#import "LWHuoYuanListCollectionViewCell.h"
#import "LWHuoYuanItemsListViewController.h"
#import "LWHuoYuanDaTingModel.h"
#import "zNetWorkManger.h"

@interface zHyController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView * collectView;
@property (nonatomic, strong) NSMutableArray<LWHuoYuanDaTingModel *> * listDatasMutableArray;

@end

@implementation zHyController

//货源大厅一级列表
- (void)requestDatas
{
    [self requestPostWithUrl:@"app/appzhuangbeitype/list" paraString:@{@"parentId":@"1"} success:^(id  _Nonnull response) {
        //        [self.collectView.mj_footer setHidden:NO];
        [self.collectView.mj_header endRefreshing];
        //        [self.collectView.mj_footer endRefreshing];
        
        //        LWLog(@"-------------货源大厅一级列表:%@",response);
        if ([response[@"code"] integerValue] == 0) {
            NSDictionary *page = response[@"page"];
            self.currPage = [page[@"currPage"] integerValue];
            self.totalPage = [page[@"totalPage"] integerValue];
            NSArray *list = page[@"list"];
            if (self.currPage == 1) {
                [self.listDatasMutableArray removeAllObjects];
            }
            
            LWHuoYuanDaTingModel *model = [LWHuoYuanDaTingModel new];
            model.name = @"联盟爆款";
            model.isBaoKuan = 1;
            NSString *imageurl = @"https://zhkj001.oss-cn-beijing.aliyuncs.com/联盟爆款.jpg";
            imageurl = [imageurl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            model.imageUrl = imageurl;
            [self.listDatasMutableArray addObject:model];
            
            for (NSDictionary *dict in list) {
                [self.listDatasMutableArray addObject: [LWHuoYuanDaTingModel modelWithDictionary:dict]];
            }
            
            if (self.currPage >= self.totalPage) {
                [self.collectView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.collectView.mj_footer resetNoMoreData];
            }
        }
        if (self.listDatasMutableArray.count == 0) {
            [self.view bringSubviewToFront:self.nothingView];
        }else{
            [self.view sendSubviewToBack:self.nothingView];
        }
        self.nothingView.alpha = self.listDatasMutableArray.count == 0 ? 1:0;
        self.collectView.mj_footer.hidden = self.listDatasMutableArray.count == 0;
        [self.collectView reloadData];
    } failure:^(NSError * _Nonnull error) {
        [self.collectView.mj_header endRefreshing];
        [self.collectView.mj_footer endRefreshing];
        if (self.currPage == 1) {
            [self.collectView.mj_footer setHidden:YES];
        }
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"货源大厅";
    [self confiUI];
    __weak typeof(self)weakSelf  = self;
    self.noContentView.retryTapBack = ^{
        [weakSelf  requestDatas];
    };
    [self requestDatas];
}

- (void)confiUI
{
    [self.view addSubview:self.collectView];
    [self.collectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LWHuoYuanListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LWHuoYuanListCollectionViewCell" forIndexPath:indexPath];
    LWHuoYuanDaTingModel *model = self.listDatasMutableArray[indexPath.row];
    cell.descL.text = model.name;
    if (model.isBaoKuan == 1) {
        NSURL *url = [NSURL URLWithString:model.imageUrl];
        [cell.bgImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholdericon.svg"]];
        cell.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    }else{
        cell.bgImageView.contentMode = UIViewContentModeScaleAspectFit;
        [cell.bgImageView z_imageWithImageId:model.imagesId];
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.listDatasMutableArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LWHuoYuanDaTingModel *model = self.listDatasMutableArray[indexPath.row];
    if (model.isBaoKuan == 1) {
        [self showBaoKuanAleartView:@"本订单为公司行为，支付10000个功勋币即可获得联盟爆款的推广，时间周期为1个月"];
    }else{
        LWHuoYuanItemsListViewController *itemslist = [LWHuoYuanItemsListViewController new];
        itemslist.titleStr = model.name;
        itemslist.parentId = model.customId;
        [self.navigationController pushViewController:itemslist animated:YES];
    }
}

- (UICollectionView *)collectView
{
    if (!_collectView) {
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        flowlayout.minimumLineSpacing = 10;
        flowlayout.minimumInteritemSpacing = 10;
        flowlayout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
        flowlayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        CGFloat item_w = (SCREEN_WIDTH-50)/2;
        flowlayout.itemSize = CGSizeMake(item_w, item_w*0.8);
        _collectView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowlayout];
        _collectView.backgroundColor = UIColor.whiteColor;
        _collectView.delegate = self;
        _collectView.dataSource = self;
        [_collectView registerClass:[LWHuoYuanListCollectionViewCell class] forCellWithReuseIdentifier:@"LWHuoYuanListCollectionViewCell"];
        _collectView.mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
        //        _collectView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
        
    }
    return _collectView;
}

- (NSMutableArray *)listDatasMutableArray
{
    if (!_listDatasMutableArray) {
        _listDatasMutableArray = [[NSMutableArray alloc] init];
    }
    return _listDatasMutableArray;
}
@end
