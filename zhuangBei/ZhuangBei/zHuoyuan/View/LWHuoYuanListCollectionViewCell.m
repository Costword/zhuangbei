//
//  LWHuoYuanListCollectionViewCell.m
//  ZhuangBei
//
//  Created by LWQ on 2020/4/26.
//  Copyright © 2020 aa. All rights reserved.
//

#import "LWHuoYuanListCollectionViewCell.h"
#import "UIView+Extension.h"

@implementation LWHuoYuanListCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        CGFloat item_w = (SCREEN_WIDTH-50)/2;
        _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,item_w , item_w*0.618)];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFit;
        _bgImageView.image = [_bgImageView z_getPlaceholderImageWithSVG];
        _descL = [UILabel new];
        UIView * descL_bg = [UIView new];
        [self addSubviews:@[_bgImageView,descL_bg,_descL,]];
//        _descL.text = @"测试数据";
        _descL.font = kFont(12);
        _descL.textColor = UIColor.whiteColor;
        descL_bg.backgroundColor = UIColor.blackColor;
        descL_bg.alpha = 0.3;
        [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.top).mas_offset(0);
            make.left.mas_equalTo(self.mas_left).mas_offset(0);
            make.right.mas_equalTo(self.mas_right).mas_offset(-0);
            make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-0);
        }];
        [_descL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.height.mas_offset(20);
            make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-10);
        }];
        [descL_bg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.mas_equalTo(self);
            make.height.mas_offset(20);
            make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-10);
        }];
        
        [self.contentView setBoundWidth:1 cornerRadius:10 boardColor:BASECOLOR_BOARD];
        [_bgImageView setBoundWidth:1 cornerRadius:10 boardColor:BASECOLOR_BOARD];
        _bgImageView.image = [_bgImageView z_getPlaceholderImageWithSVG];
    }
    return self;
}
@end
