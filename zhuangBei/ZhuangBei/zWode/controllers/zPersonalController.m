//
//  zPersonalController.m
//  ZhuangBei
//
//  Created by aa on 2020/5/3.
//  Copyright © 2020 aa. All rights reserved.
//

#import "zPersonalController.h"
#import "zcityCell.h"
#import "zCityEditFooter.h"
#import "zPersonalModel.h"
#import "zPersonalHeader.h"
#import "zEducationRankTypeInfo.h"
#import "zUpLoadUserModel.h"
#import "zListTypeModel.h"
#import "NSDictionary+NSNull.h"
#import "HeaderManager.h"
#import "LWClientHeader.h"
#import "zPersonalTableHeader.h"

@interface zPersonalController ()<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic)UITableView * persoanTableView;
@property(strong,nonatomic)zPersonalHeader * headerView;
@property(strong,nonatomic)zPersonalTableHeader * personalHeader;
@property(strong,nonatomic)zCityEditFooter * footView;

@property(strong,nonatomic)NSMutableArray * persoanArray;

@property(assign,nonatomic)BOOL canEdit;

@property(strong,nonatomic)zUpLoadUserModel * upLoadModel;

@property(strong,nonatomic)NSString * companyId;

@property(strong,nonatomic)NSString * portrait;

@end

@implementation zPersonalController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(zPersonalTableHeader *)personalHeader
{
    if (!_personalHeader) {
        _personalHeader = [[zPersonalTableHeader alloc]initWithFrame:CGRectZero];
    }
    return _personalHeader;
}

-(zUpLoadUserModel*)upLoadModel
{
    if (!_upLoadModel) {
        _upLoadModel = [[zUpLoadUserModel alloc]init];
        _upLoadModel.userId = [zEducationRankTypeInfo shareInstance].userInfoModel.userId;
        _upLoadModel.userDm = [zEducationRankTypeInfo shareInstance].userInfoModel.userDm;
        _upLoadModel.portrait = [zEducationRankTypeInfo shareInstance].userInfoModel.portrait;
        _upLoadModel.isShowMobile = [zEducationRankTypeInfo shareInstance].userInfoModel.isShowMobile;
        _upLoadModel.isShowJobYear = [zEducationRankTypeInfo shareInstance].userInfoModel.isShowJobYear;
        _upLoadModel.isShowEducation = [zEducationRankTypeInfo shareInstance].userInfoModel.isShowEducation;
        _upLoadModel.isShowBirth = [zEducationRankTypeInfo shareInstance].userInfoModel.isShowBirth;
        _upLoadModel.userName = [zEducationRankTypeInfo shareInstance].userInfoModel.userName!=nil?[zEducationRankTypeInfo shareInstance].userInfoModel.userName:@"";
        _upLoadModel.userName = [zEducationRankTypeInfo shareInstance].userInfoModel.userName!=nil?[zEducationRankTypeInfo shareInstance].userInfoModel.userName:@"";
        _upLoadModel.sex = [zEducationRankTypeInfo shareInstance].userInfoModel.sex!=nil?[zEducationRankTypeInfo shareInstance].userInfoModel.sex:@"";
        _upLoadModel.mobile =[zEducationRankTypeInfo shareInstance].userInfoModel.mobile!=nil?[zEducationRankTypeInfo shareInstance].userInfoModel.mobile:@"";
        _upLoadModel.birth = [zEducationRankTypeInfo shareInstance].userInfoModel.birth!=nil?[zEducationRankTypeInfo shareInstance].userInfoModel.birth:@"";
        _upLoadModel.email = [zEducationRankTypeInfo shareInstance].userInfoModel.email!=nil?[zEducationRankTypeInfo shareInstance].userInfoModel.email:@"";
        _upLoadModel.nativePlace = [zEducationRankTypeInfo shareInstance].userInfoModel.nativePlace!=nil?[zEducationRankTypeInfo shareInstance].userInfoModel.nativePlace:@"";
        _upLoadModel.education = [zEducationRankTypeInfo shareInstance].userInfoModel.education!=nil?[zEducationRankTypeInfo shareInstance].userInfoModel.education:@"";
        _upLoadModel.jobYear = [zEducationRankTypeInfo shareInstance].userInfoModel.jobYear!=nil?[zEducationRankTypeInfo shareInstance].userInfoModel.jobYear:@"";
        _upLoadModel.suoShuGsName = [zEducationRankTypeInfo shareInstance].userInfoModel.suoShuGsName!=nil?[zEducationRankTypeInfo shareInstance].userInfoModel.suoShuGsName:@"";
        _upLoadModel.companyType = [zEducationRankTypeInfo shareInstance].userInfoModel.companyType!=nil?[zEducationRankTypeInfo shareInstance].userInfoModel.companyType:@"";
        _upLoadModel.regLocation = [zEducationRankTypeInfo shareInstance].userInfoModel.regLocation!=nil?[zEducationRankTypeInfo shareInstance].userInfoModel.regLocation:@"";
        _upLoadModel.buMen = [zEducationRankTypeInfo shareInstance].userInfoModel.buMen!=nil?[zEducationRankTypeInfo shareInstance].userInfoModel.buMen:@"";
        _upLoadModel.post =[zEducationRankTypeInfo shareInstance].userInfoModel.post!=nil?[zEducationRankTypeInfo shareInstance].userInfoModel.post:@"";
    }
    return _upLoadModel;
}

-(NSMutableArray*)persoanArray
{
    if (!_persoanArray) {
        NSArray * citys = [zEducationRankTypeInfo shareInstance].citys;
        if (citys == nil) {
            citys = @[];
        }
        NSArray * persoanl = @[
//            @{
//                @"name":@"姓名（必填）",
//                @"content":[NSString stringWithFormat:@"%@",[zEducationRankTypeInfo shareInstance].userInfoModel.userName!=nil?[zEducationRankTypeInfo shareInstance].userInfoModel.userName:@""],
//                @"canShow":@(0)
//            },@{
//                @"name":@"性别（必填）",
//                @"content":[NSString stringWithFormat:@"%@",[zEducationRankTypeInfo shareInstance].userInfoModel.sex!=nil?[zEducationRankTypeInfo shareInstance].userInfoModel.sex:@""],
//                @"canShow":@(0)
//            },@{
//                @"name":@"手机号码",
//                @"content":[NSString stringWithFormat:@"%@",[zEducationRankTypeInfo shareInstance].userInfoModel.mobile!=nil?[zEducationRankTypeInfo shareInstance].userInfoModel.mobile:@""],
//                @"canShow":@(1)
//            },@{
//                @"name":@"出生日期",
//                @"content":[NSString stringWithFormat:@"%@",[zEducationRankTypeInfo shareInstance].userInfoModel.birth!=nil?[zEducationRankTypeInfo shareInstance].userInfoModel.birth:@""],
//                @"canShow":@(1)
//            },@{
//                @"name":@"E-mail",
//                @"content":[NSString stringWithFormat:@"%@",[zEducationRankTypeInfo shareInstance].userInfoModel.email!=nil?[zEducationRankTypeInfo shareInstance].userInfoModel.email:@""],
//                @"canShow":@(0)
//            },@{
//                @"name":@"籍贯",
//                @"content":[NSString stringWithFormat:@"%@",[zEducationRankTypeInfo shareInstance].userInfoModel.nativePlace!=nil?[zEducationRankTypeInfo shareInstance].userInfoModel.nativePlace:@""],
//                @"canShow":@(0)
//            },@{
//                @"name":@"学历",
//                @"content":[NSString stringWithFormat:@"%@",[zEducationRankTypeInfo shareInstance].userInfoModel.education!=nil?[zEducationRankTypeInfo shareInstance].userInfoModel.education:@""],
//                @"canShow":@(1)
//            },@{
//                @"name":@"工作年限",
//                @"content":[NSString stringWithFormat:@"%@",[zEducationRankTypeInfo shareInstance].userInfoModel.jobYear!=nil?[zEducationRankTypeInfo shareInstance].userInfoModel.jobYear:@""],
//                @"canShow":@(1)
//            },@{
//                @"name":@"公司名称",
//                @"content":[NSString stringWithFormat:@"%@",[zEducationRankTypeInfo shareInstance].userInfoModel.suoShuGsName!=nil?[zEducationRankTypeInfo shareInstance].userInfoModel.suoShuGsName:@""],
//                @"canShow":@(0)
//            },@{
//                @"name":@"公司类型",
//                @"content":[NSString stringWithFormat:@"%@",[zEducationRankTypeInfo shareInstance].userInfoModel.companyType!=nil?[zEducationRankTypeInfo shareInstance].userInfoModel.companyType:@""],
//                @"canShow":@(0)
//            },@{
//                @"name":@"公司所在省份（必选）",
//                @"content":[NSString stringWithFormat:@"%@",[zEducationRankTypeInfo shareInstance].userInfoModel.regLocation!=nil?[zEducationRankTypeInfo shareInstance].userInfoModel.regLocation:@""],
//                @"canShow":@(0)
//            },@{
//                @"name":@"部门（必填）",
//                @"content":[NSString stringWithFormat:@"%@",[zEducationRankTypeInfo shareInstance].userInfoModel.buMen!=nil?[zEducationRankTypeInfo shareInstance].userInfoModel.buMen:@""],
//                @"canShow":@(0)
//            },@{
//                @"name":@"职务",
//                @"content":[NSString stringWithFormat:@"%@",[zEducationRankTypeInfo shareInstance].userInfoModel.post!=nil?[zEducationRankTypeInfo shareInstance].userInfoModel.post:@""],
//                @"canShow":@(0)
//            },
            @{
                @"name":@"管辖地",
                @"content":@"请选择",
                @"canShow":@(0),
                @"city":citys
            },
        ];
        NSMutableArray * mutableArray = [NSMutableArray array];
        [persoanl enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary * dic = persoanl[idx];
            zPersonalModel * model = [zPersonalModel mj_objectWithKeyValues:dic];
            model.index = idx;
            [mutableArray addObject:model];
        }];
        _persoanArray = mutableArray;
    }
    return _persoanArray;
}

-(UITableView*)persoanTableView
{
    if (!_persoanTableView) {
        _persoanTableView  = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _persoanTableView.backgroundColor = [UIColor whiteColor];
        _persoanTableView.delegate = self;
        _persoanTableView.dataSource = self;
        _persoanTableView.allowsSelection = NO;
        _persoanTableView.estimatedRowHeight = kWidthFlot(44);
        _persoanTableView.estimatedSectionHeaderHeight = 2;
        _persoanTableView.estimatedSectionFooterHeight = 2;
        _persoanTableView.showsVerticalScrollIndicator = NO;
        _persoanTableView.rowHeight = UITableViewAutomaticDimension;
        _persoanTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _persoanTableView;
}
-(zPersonalHeader*)headerView
{
    if (!_headerView) {
        __weak typeof(self) weakSelf = self;
        _headerView = [[zPersonalHeader alloc]init];
        _headerView.imageID = [NSString stringWithFormat:@"%@",[zEducationRankTypeInfo shareInstance].userInfoModel.portrait];
        _headerView.personalTap = ^{
          
            [HeaderManager.inst showMenuWithController:weakSelf startUpload:^{
                //开始
                NSLog(@"开始上传");
            } change:^(UIImage * _Nonnull image, NSString * _Nonnull ossUrl) {
                //改变
                weakSelf.headerView.imageID = ossUrl;
                weakSelf.portrait = ossUrl;
                NSLog(@"上传成功");
            } fail:^{
                //失败
                NSLog(@"上传失败");
            }];
        };
    }
    return _headerView;
}

-(zCityEditFooter*)footView
{
    if (!_footView) {
        __weak typeof(self)weakSelf = self;
        _footView = [[zCityEditFooter alloc]init];
        _footView.tapBack = ^(NSInteger type) {
            if ([zEducationRankTypeInfo shareInstance].typesModel.section.count >0) {
                if (type == 1) {
                    weakSelf.canEdit = YES;
                }else if (type == 2)
                {
                    weakSelf.canEdit = NO;
                }else
                {
                    if (weakSelf.upLoadModel.userName.length==0) {
                        [[zHud shareInstance]showMessage:@"用户名必填"];
                        return;
                    }
                    if (weakSelf.upLoadModel.sex.length==0) {
                        [[zHud shareInstance]showMessage:@"性别必填"];
                        return;
                    }
                    if (weakSelf.upLoadModel.regLocation.length==0) {
                        [[zHud shareInstance]showMessage:@"公司所在地必填"];
                        return;
                    }
                    if (weakSelf.upLoadModel.buMen.length==0) {
//                        [[zHud shareInstance]showMessage:@"部门必填"];
//                        return;
                        weakSelf.upLoadModel.buMen = @"";
                    }
                    if (weakSelf.upLoadModel.post.length==0) {
//                        [[zHud shareInstance]showMessage:@"职务必填"];
//                        return;
                        weakSelf.upLoadModel.post = @"";
                    }
                    if ([weakSelf.upLoadModel.email isEqualToString:@"(null)"]) {
                        weakSelf.upLoadModel.email = @"";
                    }
                    if ([weakSelf.upLoadModel.birth isEqualToString:@"(null)"]) {
                        weakSelf.upLoadModel.birth = @"";
                    }
                    if (weakSelf.portrait != nil) {
                        weakSelf.upLoadModel.portrait = weakSelf.portrait;
                    }
                    NSDictionary * dic = [weakSelf.upLoadModel mj_keyValues];
                    weakSelf.canEdit = NO;
                    NSMutableDictionary * tureDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
                    if (weakSelf.companyId != nil) {
                    [tureDic setObject:weakSelf.companyId forKey:@"suoShuGs"];
                    }
                    NSString * url = [NSString stringWithFormat:@"%@%@",kApiPrefix,kupUserInfo];
                    [weakSelf postDataWithUrl:url WithParam:tureDic];
                }
                [weakSelf.persoanTableView reloadData];
            }
        };
        
    }
    return _footView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.persoanTableView];
    
    NSString * type = @"sex,education,jobYear,section,rank,companyType";
    NSString * url = [NSString stringWithFormat:@"%@%@?type=%@",kApiPrefix,kgetStudyRank,type];
    
    if ([zEducationRankTypeInfo shareInstance].typesModel.section.count > 0) {
        NSLog(@"类型：%@",[zEducationRankTypeInfo shareInstance].typesModel);
        
    }else
    {
        [self postDataWithUrl:url WithParam:nil];
    }
    
    NSString * checkCompanyUrl = [NSString stringWithFormat:@"%@%@?name=%@",kApiPrefix,kgetCompanyID,[zEducationRankTypeInfo shareInstance].userInfoModel.suoShuGsName];
    
    [self postDataWithUrl:checkCompanyUrl WithParam:nil];
    
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.persoanTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }
    return self.persoanArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    zcityCell * cell = [zcityCell instanceWithTableView:tableView AndIndexPath:indexPath];
    cell.canEdit = self.canEdit;
    cell.upModel = self.upLoadModel;
    cell.changeModelBack = ^(zUpLoadUserModel * _Nonnull upModel, zPersonalModel * _Nonnull perModel) {
        zPersonalModel * model = weakSelf.persoanArray[perModel.index];
        model.content = perModel.content;
        weakSelf.upLoadModel = upModel;
    };
    zPersonalModel * model = self.persoanArray[indexPath.row];
    cell.persoamModel = model;
    return cell;
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        self.headerView.canEdit = self.canEdit;
        return self.headerView;
    }
    self.personalHeader.upModel = self.upLoadModel;
    self.personalHeader.canEdit = self.canEdit;
    //耗性能写法，重制类型数组，后台接口太乱了，懒得整理了。
    self.personalHeader.typesModel = nil;
    @weakify(self);
    [RACObserve(self.personalHeader, refresh) subscribeNext:^(id x) {
        @strongify(self);
        if ([x boolValue]) {
            self.upLoadModel = self.personalHeader.upModel;
        }
    }];
    return self.personalHeader;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section==0) {
        return nil;
    }
    self.footView.canEdit = self.canEdit;
    return self.footView;
}

-(void)RequsetFileWithUrl:(NSString*)url WithError:(NSError*)err
{
    if ([url containsString:kgetStudyRank]) {
        
        if (err.code == -1001) {
            [[zHud shareInstance] showMessage:@"无法连接服务器"];
        }
        [[zHud shareInstance] showMessage:@"资源获取失败"];
    }
    if ([url containsString:kupUserInfo]) {
        if (err.code == -1001) {
            [[zHud shareInstance] showMessage:@"无法连接服务器"];
        }
    }
    if ([url containsString:kgetCompanyID]) {
           [[zHud shareInstance] showMessage:@"无法连接服务器"];
    }
}

-(void)RequsetSuccessWithData:(id)data AndUrl:(NSString*)url
{
    if ([url containsString:kgetStudyRank]) {
        NSDictionary * dic = data[@"data"];
        zTypesModel * model = [zTypesModel mj_objectWithKeyValues:dic];
        //性别
        NSMutableArray * sexArr = [NSMutableArray array];
        [model.sex enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary * dic = model.sex[idx];
            zListTypeModel * sexModel = [zListTypeModel mj_objectWithKeyValues:dic];
            sexModel.select = NO;
            [sexArr addObject:sexModel];
        }];
        model.sex = sexArr;
        
        //学历
        NSMutableArray * educationArr = [NSMutableArray array];
        [model.education enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary * dic = model.education[idx];
            zListTypeModel * sexModel = [zListTypeModel mj_objectWithKeyValues:dic];
            sexModel.select = NO;
            [educationArr addObject:sexModel];
        }];
        model.education = educationArr;
        
        //职务
        NSMutableArray * rankArr = [NSMutableArray array];
        [model.rank enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary * dic = model.rank[idx];
            zListTypeModel * sexModel = [zListTypeModel mj_objectWithKeyValues:dic];
            sexModel.select = NO;
            [rankArr addObject:sexModel];
        }];
        model.rank = rankArr;
        
        //公司类型
        NSMutableArray * companyTypeArr = [NSMutableArray array];
        [model.companyType enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary * dic = model.companyType[idx];
            zListTypeModel * sexModel = [zListTypeModel mj_objectWithKeyValues:dic];
            sexModel.select = NO;
            [companyTypeArr addObject:sexModel];
        }];
        model.companyType = companyTypeArr;
        
        //工作年限
        NSMutableArray * jobYearArr = [NSMutableArray array];
        [model.jobYear enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary * dic = model.jobYear[idx];
            zListTypeModel * sexModel = [zListTypeModel mj_objectWithKeyValues:dic];
            sexModel.select = NO;
            [jobYearArr addObject:sexModel];
        }];
        model.jobYear = jobYearArr;
        
        //部门
        NSMutableArray * sectionArr = [NSMutableArray array];
        [model.section enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary * dic = model.section[idx];
            zListTypeModel * sexModel = [zListTypeModel mj_objectWithKeyValues:dic];
            sexModel.select = NO;
            [sectionArr addObject:sexModel];
        }];
        model.section = sectionArr;
        [zEducationRankTypeInfo shareInstance].typesModel = model;
        [[zEducationRankTypeInfo shareInstance] saveTypeInfo];
        [self.persoanTableView reloadData];
        return;
    }
    if ([url containsString:kupUserInfo]) {
        NSDictionary * dic = data[@"data"];
         NSString * code = data[@"code"];
        NSString * msg = data[@"msg"];
        if ([code integerValue] == 500) {
            [[zHud shareInstance]showMessage:msg];
            return;
        }
        NSLog(@"提交信息%@",dic);
        [LWClientManager.share requestAllGroupInforDatas];
    }
    
    if ([url containsString:kgetCompanyID]) {
        NSString * code = data[@"code"];
        NSDictionary * dic = data[@"data"];
        NSDictionary * trueDic = [NSDictionary nullDicToDic:dic];
        
        self.companyId = trueDic[@"id"];
        
        if ([code integerValue] == 0) {
            //验证成功
//            * 已认证的企业，公司名称、企业类型、所在部门、所属职务、管辖地不可修改
            if ([zEducationRankTypeInfo shareInstance].userInfoModel.operationStatus==2) {
                self.personalHeader.cantChange = YES;
            }
        }
        NSLog(@"公司认证信息%@",dic);
    }
}


@end
