//
//  SDCollectionViewCell.m
//  SDCycleScrollView
//
//  Created by aier on 15-3-22.
//  Copyright (c) 2015年 GSD. All rights reserved.
//


/*
 
 *********************************************************************************
 *
 * 🌟🌟🌟 新建SDCycleScrollView交流QQ群：185534916 🌟🌟🌟
 *
 * 在您使用此自动轮播库的过程中如果出现bug请及时以以下任意一种方式联系我们，我们会及时修复bug并
 * 帮您解决问题。
 * 新浪微博:GSD_iOS
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios
 *
 * 另（我的自动布局库SDAutoLayout）：
 *  一行代码搞定自动布局！支持Cell和Tableview高度自适应，Label和ScrollView内容自适应，致力于
 *  做最简单易用的AutoLayout库。
 * 视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * 用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 * GitHub：https://github.com/gsdios/SDAutoLayout
 *********************************************************************************
 
 */


#import "SDCollectionViewCell.h"
#import "UIView+SDExtension.h"

static const CGFloat kAdvertWidth = 26.0f;

@implementation SDCollectionViewCell
{
    __weak UILabel *_titleLabel;
    UILabel *_adLabel;
    UIView *bottomView;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupImageView];
        [self setupTitleLabel];
    }
    
    return self;
}

- (void)setTitleLabelBackgroundColor:(UIColor *)titleLabelBackgroundColor
{
    _titleLabelBackgroundColor = titleLabelBackgroundColor;
    bottomView.backgroundColor = titleLabelBackgroundColor;
}

- (void)setTitleLabelTextColor:(UIColor *)titleLabelTextColor
{
    _titleLabelTextColor = titleLabelTextColor;
    _titleLabel.textColor = titleLabelTextColor;
}

- (void)setTitleLabelTextFont:(UIFont *)titleLabelTextFont
{
    _titleLabelTextFont = titleLabelTextFont;
    _titleLabel.font = titleLabelTextFont;
}

- (void)setupImageView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    _imageView = imageView;
    [self.contentView addSubview:imageView];
}

- (void)setupTitleLabel
{
    bottomView = [[UIView alloc] init];
    [self.contentView addSubview:bottomView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    _titleLabel = titleLabel;
    _titleLabel.hidden = YES;
    [self.contentView addSubview:titleLabel];
    
    _adLabel = [[UILabel alloc] init];
    _adLabel.layer.cornerRadius = 4.0;
    _adLabel.font = [UIFont systemFontOfSize:9];
    _adLabel.textAlignment = NSTextAlignmentCenter;
    _adLabel.clipsToBounds = YES;
    _adLabel.layer.borderColor = [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0].CGColor;
    _adLabel.layer.borderWidth = 1.0f;
    _adLabel.backgroundColor = [UIColor clearColor];
    _adLabel.hidden = YES;
    _adLabel.textColor = [UIColor colorWithRed:188.0/255.0 green:188.0/255.0 blue:188.0/255.0 alpha:1.0];
    _adLabel.text = @"广告";
    [self.contentView addSubview:_adLabel];
}

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    if (self.titleBottomMargin) {
        _titleLabel.text = title;
    } else {
        _titleLabel.text = [NSString stringWithFormat:@"   %@", title];
    }
    if (_titleLabel.hidden) {
        _titleLabel.hidden = NO;
    }
}

-(void)setTitleLabelTextAlignment:(NSTextAlignment)titleLabelTextAlignment
{
    _titleLabelTextAlignment = titleLabelTextAlignment;
    _titleLabel.textAlignment = titleLabelTextAlignment;
}

- (void)setTitleNumberOfLines:(NSInteger)titleNumberOfLines {
    _titleNumberOfLines = titleNumberOfLines;
    _titleLabel.numberOfLines = titleNumberOfLines;
}

- (void)setIsAd:(BOOL)isAd
{
    _isAd = isAd;
    _adLabel.hidden = !isAd;
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.onlyDisplayText) {
        _titleLabel.frame = self.bounds;
    } else {
        _imageView.frame = self.bounds;
        CGFloat titleLabelW = self.sd_width - _rightMargin - 12;
        if (_isAd) {
            titleLabelW -= kAdvertWidth;
        }
        
        CGFloat titleLabelH = _titleLabelHeight;
        CGFloat titleLabelX = 0;
        CGFloat titleLabelY = self.sd_height - titleLabelH;
        
        if (self.titleBottomMargin) {
            CGSize size = [_titleLabel sizeThatFits:CGSizeMake(self.sd_width - 50, titleLabelH)];
            _titleLabel.frame = CGRectMake(25, self.sd_height - self.titleBottomMargin - size.height, self.sd_width - 50, size.height);
        } else {
            _titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
        }
        
        bottomView.frame = CGRectMake(titleLabelX, titleLabelY, self.sd_width, titleLabelH);
        _adLabel.frame = CGRectMake(titleLabelW, _titleLabel.center.y - (kAdvertWidth / 2.0 / 2.0), kAdvertWidth, kAdvertWidth / 2.0);
        if (_bottomGradualViewHeight) {
            self.bottomGradualView.frame = CGRectMake(0, self.sd_height - _bottomGradualViewHeight, self.sd_width, _bottomGradualViewHeight);
        }
    }
}

- (UIView *)bottomGradualView {
    if (!_bottomGradualView) {
        _bottomGradualView = [[UIView alloc] initWithFrame:CGRectMake(0,self.sd_height - _bottomGradualViewHeight,self.sd_width,_bottomGradualViewHeight)];
        _bottomGradualView.backgroundColor = [UIColor clearColor];
        [self.contentView insertSubview:_bottomGradualView aboveSubview:_imageView];
        // gradient
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = CGRectMake(0,0,self.sd_width,_bottomGradualViewHeight);
        gl.startPoint = CGPointMake(0, 0);
        gl.endPoint = CGPointMake(0, 1);
        gl.colors = @[(__bridge id)[UIColor colorWithWhite:0 alpha:0.0].CGColor, (__bridge id)[UIColor colorWithWhite:0 alpha:0.5600].CGColor];
        gl.locations = @[@(0), @(1.0f)];
        [self.bottomGradualView.layer addSublayer:gl];
    }
    return _bottomGradualView;
}

@end
