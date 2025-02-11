//
//  zCompanyDetailCell.m
//  ZhuangBei
//
//  Created by aa on 2020/5/8.
//  Copyright © 2020 aa. All rights reserved.
//

#import "zCompanyDetailCell.h"
#import "KKPaddingLabel.h"
#import "zCityCollectionCell.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "zCompanyGoodsCollectionCell.h"
#import "zCompanyCollectionHeaderView.h"

@interface zCompanyDetailCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(strong,nonatomic)UIView * BaseView;

@property(strong,nonatomic)UIImageView * logoImageView;

@property(strong,nonatomic)UILabel * companyName;//名称
@property(strong,nonatomic)UILabel * companyType;//类型
@property(strong,nonatomic)UILabel * companyFaren;//法人
@property(strong,nonatomic)UILabel * companyAddress;//所在地
@property(strong,nonatomic)UILabel * companyDate;//成立日期
@property(strong,nonatomic)UILabel * companyBusiness;//商务联系
@property(strong,nonatomic)UILabel * companyEmail;//邮箱
@property(strong,nonatomic)UILabel * companyWeb;//官网
@property(strong,nonatomic)UILabel * companyDesc;//简介
@property(strong,nonatomic)UILabel * companyCurrentAddress;//办公地址
@property(strong,nonatomic)UILabel * companyPolice;//主营警种

@property(strong,nonatomic)KKPaddingLabel * companyNameContent;//名称
@property(strong,nonatomic)KKPaddingLabel * companyTypeContent;//类型
@property(strong,nonatomic)KKPaddingLabel * companyFarenContent;//法人
@property(strong,nonatomic)KKPaddingLabel * companyAddressContent;//所在地
@property(strong,nonatomic)KKPaddingLabel * companyDateContent;//成立日期
@property(strong,nonatomic)KKPaddingLabel * companyBusinessContent;//商务联系
@property(strong,nonatomic)KKPaddingLabel * companyEmailContent;//邮箱
@property(strong,nonatomic)KKPaddingLabel * companyWebContent;//官网
@property(strong,nonatomic)KKPaddingLabel * companyDescContent;//简介
@property(strong,nonatomic)KKPaddingLabel * companyCurrentAddressContent;//办公地址
@property(strong,nonatomic)KKPaddingLabel * companyPoliceContent;//主营警种

@property(strong,nonatomic)UICollectionView * cityCollectView;

@property(strong,nonatomic)UICollectionView * goodsCollectView;

@end

@implementation zCompanyDetailCell

+(zCompanyDetailCell*)instanceWithTableView:(UITableView*)tableView AndIndexPath:(NSIndexPath*)indexPath
{
    static NSString * cellID = @"zCompanyDetailCell";
    zCompanyDetailCell * cell = [[zCompanyDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(RACSubject *)companySigal
{
    if (!_companySigal) {
        _companySigal = [RACSubject subject];
    }
    return _companySigal;
}

-(UIView*)BaseView
{
    if (!_BaseView) {
        _BaseView = [[UIView alloc]init];
    }
    return _BaseView;
}

-(UIImageView*)logoImageView
{
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH*0.6, SCREEN_WIDTH*0.75*0.6)];
        _logoImageView.image = [_logoImageView z_getPlaceholderImageWithSVG];
    }
    return _logoImageView;
}

//-(UICollectionView*)cityCollectView
//{
//    if (!_cityCollectView) {
//        UICollectionViewLeftAlignedLayout * layout = [[UICollectionViewLeftAlignedLayout alloc]init];
//        layout.sectionInset = UIEdgeInsetsMake(10,0, 10,0);
//        layout.minimumLineSpacing = kWidthFlot(10);
//        layout.minimumInteritemSpacing = kWidthFlot(10);
//        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//        _cityCollectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
//        _cityCollectView.showsVerticalScrollIndicator = NO;
//        _cityCollectView.backgroundColor = [UIColor clearColor];
//        _cityCollectView.delegate = self;
//        _cityCollectView.dataSource = self;
//        _cityCollectView.scrollEnabled = NO;
//        [_cityCollectView registerClass:[zCityCollectionCell class] forCellWithReuseIdentifier:@"zCityCollectionCell"];
//        _cityCollectView.delegate = self;
//        _cityCollectView.dataSource = self;
//    }
//    return _cityCollectView;
//}

-(UICollectionView *)goodsCollectView
{
    if (!_goodsCollectView) {
        UICollectionViewLeftAlignedLayout * layout = [[UICollectionViewLeftAlignedLayout alloc]init];
        layout.sectionInset = UIEdgeInsetsMake(10,10, 10,10);
        layout.minimumLineSpacing = kWidthFlot(10);
        layout.minimumInteritemSpacing = kWidthFlot(10);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _goodsCollectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _goodsCollectView.showsVerticalScrollIndicator = NO;
        _goodsCollectView.backgroundColor = [UIColor clearColor];
        _goodsCollectView.delegate = self;
        _goodsCollectView.dataSource = self;
        _goodsCollectView.scrollEnabled = NO;
        [_goodsCollectView registerClass:[zCompanyGoodsCollectionCell class] forCellWithReuseIdentifier:@"zCompanyGoodsCollectionCell"];
        [_goodsCollectView registerClass:[zCompanyCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"zCompanyCollectionHeaderView"];
        _goodsCollectView.delegate = self;
        _goodsCollectView.dataSource = self;
    }
    return _goodsCollectView;
}



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.BaseView];
//        self.companyName =           [self creatNameLabel];
//        self.companyName.text = @"公司名称*";
        [self.BaseView addSubview:self.logoImageView];
        self.companyType =           [self creatNameLabel];
        self.companyType.text = @"公司类型";
        self.companyFaren =          [self creatNameLabel];
        self.companyFaren.text = @"公司法人";
        self.companyAddress =        [self creatNameLabel];
        self.companyAddress.text = @"公司所在省";
        self.companyDate =           [self creatNameLabel];
        self.companyDate.text = @"成立日期";
        self.companyBusiness=        [self creatNameLabel];
        self.companyBusiness.text = @"商务联系";
        self.companyEmail =          [self creatNameLabel];
        self.companyEmail.text = @"邮箱";
        self.companyWeb =            [self creatNameLabel];
        self.companyWeb.text = @"公司官网";
        self.companyDesc =           [self creatNameLabel];
        self.companyDesc.text = @"公司简介";
        self.companyCurrentAddress = [self creatNameLabel];
        self.companyCurrentAddress.text = @"办公地址";
        self.companyPolice =         [self creatNameLabel];
        self.companyPolice.text = @"主营产品";
        
//        self.companyNameContent =           [self creatContentLabel];
        self.companyTypeContent =           [self creatContentLabel];
        self.companyFarenContent =          [self creatContentLabel];
        self.companyAddressContent =        [self creatContentLabel];
        self.companyDateContent =           [self creatContentLabel];
        self.companyBusinessContent =       [self creatContentLabel];
        self.companyEmailContent =          [self creatContentLabel];
        self.companyWebContent =            [self creatContentLabel];
        self.companyDescContent =           [self creatContentLabel];
        [self setLabelTextWith:@"公司简介，名字会有很长很长哦很多蚊子多文字适配，多文字处理换行情况，换换行换行，公司简介，名字会有很长很长哦很多蚊子多文字适配，多文字处理换行情况，换换行换行公司简介，名字会有很长很长哦很多蚊子多文字适配，多文字处理换行情况，换换行换行公司简介，名字会有很长很长哦很多蚊子多文字适配，多文字处理换行情况，换换行换行" AndLabel:self.companyDescContent];
        self.companyCurrentAddressContent = [self creatContentLabel];
        self.companyCurrentAddressContent.text = @"北京市朝阳区外大街北京警备装备科技大厦2栋8层8001";
        self.companyPoliceContent =         [self creatContentLabel];
        
        [self.BaseView addSubview:self.cityCollectView];
        [self.BaseView addSubview:self.goodsCollectView];
        [self updateConstraintsForView];
    }
    return self;
}

-(void)updateConstraintsForView
{
    CGFloat height = kWidthFlot(30);
    
    [self.BaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    CGFloat left = kWidthFlot(10);
    CGFloat top = kWidthFlot(10);
    CGFloat width = kWidthFlot(80);
    CGFloat right = kWidthFlot(150);
    
//    [self.companyName mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(left);
//        make.top.mas_equalTo(top);
//        make.width.mas_equalTo(width);
//        make.height.mas_equalTo(height);
//    }];
//    [self.companyNameContent mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.companyName.mas_right).offset(top);
//        make.top.mas_equalTo(top);
//        make.right.mas_equalTo(-right);
//        make.height.mas_equalTo(height);
//    }];
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(top);
        make.right.mas_equalTo(-5);
        make.size.mas_equalTo(CGSizeMake(kWidthFlot(140),kWidthFlot(104)));
    }];
    [self.companyType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left);
        make.top.mas_equalTo(top);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
    [self.companyTypeContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.companyType.mas_right).offset(top);
        make.top.mas_equalTo(top);
        make.right.mas_equalTo(-right);
        make.height.mas_equalTo(height);
    }];
    [self.companyDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left);
        make.top.mas_equalTo(self.companyType.mas_bottom).offset(top);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
    [self.companyDateContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.companyDate.mas_right).offset(top);
        make.top.mas_equalTo(self.companyType.mas_bottom).offset(top);
        make.right.mas_equalTo(-right);
        make.height.mas_equalTo(height);
    }];
    
    [self.companyAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left);
        make.top.mas_equalTo(self.companyDate.mas_bottom).offset(top);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
    [self.companyAddressContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.companyAddress.mas_right).offset(top);
        make.top.mas_equalTo(self.companyDate.mas_bottom).offset(top);
        make.right.mas_equalTo(-right);
        make.height.mas_equalTo(height);
    }];
    
    [self.companyFaren mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left);
        make.top.mas_equalTo(self.companyAddress.mas_bottom).offset(top);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
    [self.companyFarenContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.companyFaren.mas_right).offset(top);
        make.top.mas_equalTo(self.companyAddress.mas_bottom).offset(top);
        make.right.mas_equalTo(-right);
        make.height.mas_equalTo(height);
    }];
    
    [self.companyCurrentAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left);
        make.top.mas_equalTo(self.companyFaren.mas_bottom).offset(top);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
    [self.companyCurrentAddressContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.companyCurrentAddress.mas_right).offset(top);
        make.top.mas_equalTo(self.companyFaren.mas_bottom).offset(top);
        make.right.mas_equalTo(-right);
    }];
    
    [self.companyBusiness mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left);
        make.top.mas_equalTo(self.companyCurrentAddress.mas_bottom).offset(top);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
    [self.companyBusinessContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.companyBusiness.mas_right).offset(top);
        make.top.mas_equalTo(self.companyCurrentAddress.mas_bottom).offset(top);
        make.right.mas_equalTo(-right);
        make.height.mas_equalTo(height);
    }];
    
    [self.companyEmail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left);
        make.top.mas_equalTo(self.companyBusiness.mas_bottom).offset(top);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
    
    
    [self.companyEmailContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.companyEmail.mas_right).offset(top);
        make.top.mas_equalTo(self.companyBusiness.mas_bottom).offset(top);
        make.right.mas_equalTo(-right);
        make.height.mas_equalTo(height);
    }];

    //公司官网
    [self.companyWeb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left);
        make.top.mas_equalTo(self.companyEmail.mas_bottom).offset(top);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
    [self.companyWebContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.companyWeb.mas_right).offset(top);
        make.top.mas_equalTo(self.companyEmail.mas_bottom).offset(top);
        make.right.mas_equalTo(-right);
        make.height.mas_equalTo(height);
    }];
    
    //主营产品
    [self.companyPolice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left);
        make.top.mas_equalTo(self.companyWeb.mas_bottom).offset(top);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
    [self.companyPoliceContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left);
        make.top.mas_equalTo(self.companyPolice.mas_bottom).offset(top);
        make.right.mas_equalTo(-right);
        make.height.mas_equalTo(height);
    }];
    
    //公司简介
    [self.companyDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left);
        make.top.mas_equalTo(self.companyPoliceContent.mas_bottom).offset(top);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
    [self.companyDescContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left);
        make.top.mas_equalTo(self.companyDesc.mas_bottom).offset(top);
        make.right.mas_equalTo(-right);
        make.height.mas_equalTo(height);
    }];
    
    //已上架货源
    [self.goodsCollectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.companyDescContent.mas_bottom).offset(kWidthFlot(10));
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(kWidthFlot(1)).priorityLow();
        make.bottom.mas_equalTo(-kWidthFlot(top));
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == self.cityCollectView) {
        return 0;
    }else
    {
        return self.goodsArray.count;
    }
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    zCompanyGoodsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"zCompanyGoodsCollectionCell" forIndexPath:indexPath];
    zCompanyGoodsModel * model = self.goodsArray[indexPath.row];
    cell.goosModel = model;
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    zCompanyCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"zCompanyCollectionHeaderView" forIndexPath:indexPath];
    return headerView;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    zCompanyGoodsModel * model = self.goodsArray[indexPath.row];
    
    [self.companySigal sendNext:model];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH-20-kWidthFlot(20))/3, kWidthFlot(90));
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, kWidthFlot(50));
}

- (CGSize)stringSize:(NSString *)string {
    if (string.length == 0) return CGSizeZero;
    UIFont * font = [UIFont systemFontOfSize:17];
    CGFloat yOffset = 3.0f;
    CGFloat width = self.bounds.size.width - 20;
    CGSize contentSize = [string boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    CGSize size = CGSizeMake(MIN(contentSize.width + 20,width) , MAX(22, contentSize.height + 2 * yOffset + 1));
    return size;
}

-(void)setTypesArray:(NSArray *)typesArray
{
    [self.cityCollectView reloadData];
    [self.cityCollectView layoutIfNeeded];
    CGFloat height = self.cityCollectView.collectionViewLayout.collectionViewContentSize.height;

    [self.cityCollectView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height).priorityHigh();
    }];
}

-(void)setGoodsArray:(NSArray *)goodsArray
{
    _goodsArray = goodsArray;
    [self.goodsCollectView reloadData];
    [self.goodsCollectView layoutIfNeeded];
    CGFloat height = self.goodsCollectView.collectionViewLayout.collectionViewContentSize.height;

    [self.goodsCollectView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height).priorityHigh();
    }];
    
}

-(UILabel*)creatNameLabel
{
    UILabel *  nameLabel = [[UILabel alloc]init];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    CGFloat fitSize = kWidthFlot(14);
    nameLabel.font = kFont(fitSize);
    nameLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
    [self.BaseView addSubview:nameLabel];
    return nameLabel;
}

-(KKPaddingLabel*)creatContentLabel
{
    KKPaddingLabel *  contentLabel = [[KKPaddingLabel alloc]init];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    CGFloat fitSize = kWidthFlot(14);
    contentLabel.font = kFont(fitSize);
    contentLabel.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
//    contentLabel.layer.borderWidth = 1;
//    contentLabel.layer.borderColor =[UIColor colorWithHexString:@"#9B9B9B"].CGColor;
    contentLabel.numberOfLines = 0;
    contentLabel.padding = UIEdgeInsetsMake(10, 5, 10, 5);
    [self.BaseView addSubview:contentLabel];
    return contentLabel;
}

-(void)setLabelTextWith:(NSString*)text AndLabel:(KKPaddingLabel*)label
{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.alignment = NSTextAlignmentLeft;  //对齐
    paraStyle.headIndent = 0.0f;//行首缩进
    //参数：（字体大小17号字乘以2，34f即首行空出两个字符）
    paraStyle.tailIndent = 0.0f;//行尾缩进
    paraStyle.lineSpacing = 2.0f;//行间距
    
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:text attributes:@{NSParagraphStyleAttributeName:paraStyle}];
    
    label.attributedText = attrText;
}

-(void)setGoosModel:(zGoodsContentModel *)goosModel
{
    _goosModel = goosModel;
    //公司名
    self.companyNameContent.text = goosModel.name;
    //公司类型
    
    NSInteger companytype  = [goosModel.companyType integerValue];
    
    switch (companytype) {
        case 0:
        {
            //生产厂家
            self.companyTypeContent.text =@"生产厂家";
        }
            break;
        case 1:
        {
            //渠道经销商
            self.companyTypeContent.text =@"渠道经销商";
        }
            break;
        case 2:
        {
            //全国总代理
            self.companyTypeContent.text =@"全国总代理";
        }
            break;
            
        default:
            break;
    }
    NSString * dateStr =nil;
    if (goosModel.createDate.length>0) {
        dateStr = [goosModel.createDate substringToIndex:10];
    }
    
    //成立日期
    self.companyDateContent.text = dateStr==nil?@"暂无":dateStr;
    //公司 法人
    self.companyFarenContent.text = goosModel.faRen.length==0?@"暂无":goosModel.faRen;
    //商务联系
    self.companyBusinessContent.text = goosModel.phone.length==0?@"暂无":goosModel.phone;;
    //邮箱
    self.companyEmailContent.text = goosModel.email.length==0?@"暂无":goosModel.email;
    //公司官网
    self.companyWebContent.text = goosModel.gongSiUrl.length==0?@"暂无":goosModel.gongSiUrl;
    //公司简介
    self.companyDescContent.text = goosModel.approveText.length==0?@"暂无":goosModel.approveText;
    self.companyAddressContent.text =goosModel.regLocation.length==0?@"暂无":goosModel.regLocation;
    self.companyCurrentAddressContent.text = goosModel.regLocation.length==0?@"暂无":goosModel.regLocation;
    self.companyPoliceContent.text = goosModel.mainPoliceClassification.length==0?@"暂无":goosModel.mainPoliceClassification;
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        
    }else{
        
    }
}


@end
