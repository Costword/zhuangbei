//
//  MarqueeView.m
//  Marquee(Up and Down)
//
//  Created by 花花 on 2017/8/15.
//  Copyright © 2017年 花花. All rights reserved.
//

#import "MarqueeView.h"
#import "UIView+HHAddition.h"
@interface MarqueeView()
@property(assign, nonatomic)int titleIndex;
@property(assign, nonatomic)int index;
@property (nonatomic) NSMutableArray *titles;
/**第一个*/
@property(nonatomic)UIButton *firstBtn;
/**更多个*/
@property(nonatomic)UIButton *moreBtn;
@end
@implementation MarqueeView

#pragma mark - init Methods
-(instancetype)initWithFrame:(CGRect)frame withTitle:(NSArray *)titles{

    if (self = [super initWithFrame:frame]) {
        _titleArr  = titles;
        self.titleColor = [UIColor blackColor];
        self.titleFont =  [UIFont systemFontOfSize:14];
        self.clipsToBounds = YES;
    }
    
    return self;
}

#pragma mark - SEL Methods
-(void)nextAd{
    if (_titleArr.count>0) {
        UIButton *firstBtn = [self viewWithTag:self.index];
        self.moreBtn = [self btnframe: CGRectMake(0, self.bounds.size.height,[UIScreen mainScreen].bounds.size.width -2 *30, self.bounds.size.height)  titleColor:_titleColor action:@selector(clickBtn:)];
        self.moreBtn.tag = self.index + 1;
        if ([self.titles[self.titleIndex+1] isEqualToString:@""]) {
            self.titleIndex = -1;
            self.index = 0;
        }
        if (self.moreBtn.tag == self.titles.count) {
            
            self.moreBtn.tag = 1;
        }
        [self.moreBtn setTitle:self.titles[self.titleIndex+1] forState:UIControlStateNormal];
        [self addSubview:self.moreBtn];
        
        [UIView animateWithDuration:0.25 animations:^{
            firstBtn.y = -self.bounds.size.height;
            self.moreBtn.y = 0;
            
        } completion:^(BOOL finished) {
            [firstBtn removeFromSuperview];
            
        } ];
        self.index++;
        self.titleIndex++;
    }
}
-(void)clickBtn:(UIButton *)btn{
    
    if (self.handlerTitleClickCallBack) {
        self.handlerTitleClickCallBack(btn.tag);
    }
}

#pragma mark - Custom Methods
- (UIButton *)btnframe:(CGRect)frame  titleColor:(UIColor *)titleColor action:(SEL)action{
    
    UIButton *btn = [[UIButton alloc]init];
    btn.frame = frame;
    btn.titleLabel.font = _titleFont;
      //靠左 不居中显示
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;////文字多出部分 在右侧显示点点
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}
#pragma mark - Setter && Getter Methods
- (void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
     [self.firstBtn setTitleColor:titleColor forState:UIControlStateNormal];
     [self.moreBtn setTitleColor:titleColor forState:UIControlStateNormal];

}
- (void)setTitleFont:(UIFont *)titleFont{

    _titleFont = titleFont;
   self.firstBtn.titleLabel.font = titleFont;
   self.moreBtn.titleLabel.font = titleFont;
    
}

-(void)setTitleArr:(NSArray *)titleArr
{
    _titleArr  = titleArr;
    if (_titleArr.count>0) {
        NSMutableArray *MutableTitles = [NSMutableArray arrayWithArray:_titleArr];
        NSString *str = @"";
        self.titles = MutableTitles;
        [self.titles addObject:str]; //加一个空的,防止数组为空奔溃
        self.index = 1;
        self.firstBtn = [self btnframe:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 2 *30, self.bounds.size.height)  titleColor:_titleColor action:@selector(clickBtn:)];
        self.firstBtn .tag = self.index;
        [self.firstBtn  setTitle:self.titles[0] forState:UIControlStateNormal];
        [self addSubview:self.firstBtn];
        [NSTimer scheduledTimerWithTimeInterval:3.0 target:self     selector:@selector(nextAd) userInfo:nil repeats:YES];
    }
}


@end
