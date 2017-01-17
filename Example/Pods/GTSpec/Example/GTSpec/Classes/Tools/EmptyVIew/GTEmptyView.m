//
//  GTEmptyView.m
//  GTEmptyView
//
//  Created by 郭通 on 16/5/15.
//  Copyright © 2016年 郭通. All rights reserved.
//

#import "GTEmptyView.h"

static NSInteger kGTEmptyViewTag = -949127;

// 提示文案
#define kLabelHeight 16                     //  文案高度
#define kTextColor HEXCOLOR(0x999999)       //  文案颜色
#define kTextFontSize 15                    //  文案字号
#define kLabel_Image_Margin 0               //  文案和图片的间距

//  按钮
#define kButtonWidth 100                    //  按钮宽度
#define kButtonHeight 25                    //  文案高度
#define kButtonColor RGB(33, 133, 244) //HEXCOLOR(0xFF3366)     //  按钮颜色
#define kButtonTitleFontSize 14             //  按钮字号
#define kButton_Label_Margin 15             //  按钮和文案的间距


@interface GTEmptyView()

@property (nonatomic ,strong) UIImageView *imageView;
@property (nonatomic ,strong) UILabel *label;
@property (nonatomic ,strong) UIButton *button;
@property (nonatomic ,assign) CGPoint viewOffset;
@property (nonatomic, strong) UIView *superTheView;
@property (nonatomic, copy) void (^buttonHander)(void);
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, assign) CGSize imageSize;

@end

@implementation GTEmptyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(void)showInView:(UIView *)aView
         withText:(NSString *)text
        withImage:(UIImage *)image {
    
    [GTEmptyView showInView:aView
                    withText:text
                   withImage:image
             withButtonTitle:nil
           withButtonHandler:nil];
}

+(void)showInView:(UIView *)aView
         withText:(NSString *)text
        withImage:(UIImage *)image
  withButtonTitle:(NSString *)buttonTitle
withButtonHandler:(void (^)(void))buttonHandler {
    
    [GTEmptyView showInView:aView
                    withText:text withImage:image
             withButtonTitle:buttonTitle
           withButtonHandler:buttonHandler
                  withOffset:CGPointZero];
}

+ (void)showInView:(UIView *)aView
          withText:(NSString *)text
         withImage:(UIImage *)image
   withButtonTitle:(NSString *)buttonTitle
 withButtonHandler:(void(^)(void))buttonHandler
        withOffset:(CGPoint)offset {
    
    GTEmptyView *emptyView = [aView viewWithTag:kGTEmptyViewTag];
    emptyView.viewHeight = 0;
    if (!emptyView) {
        emptyView = [[GTEmptyView alloc] init];
        emptyView.tag = kGTEmptyViewTag;
        emptyView.superTheView = aView;
        emptyView.backgroundColor = [UIColor clearColor];
        [emptyView showInView:aView];
    }
    emptyView.viewOffset = offset;
    if (image) {
        emptyView.imageView.image = image;
        emptyView.imageSize = image.size;
        emptyView.viewHeight += image.size.height;
        [emptyView addSubview:emptyView.imageView];
    }
    if (text.length) {
        emptyView.label.text = text;
        emptyView.viewHeight += kLabelHeight;
        [emptyView addSubview:emptyView.label];
    }
    if (buttonTitle.length) {
        [emptyView.button setTitle:buttonTitle forState:UIControlStateNormal];
        [emptyView.button addTarget:emptyView action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        emptyView.buttonHander = buttonHandler;
        emptyView.viewHeight += kButtonHeight;
        [emptyView addSubview:emptyView.button];
    }
    if (image && text.length) {
        emptyView.viewHeight += kLabel_Image_Margin;
    }
    if (text.length && buttonTitle.length) {
        emptyView.viewHeight += kButton_Label_Margin;
    }
    if (image && text.length == 0 && buttonTitle.length) {
        emptyView.viewHeight += kLabel_Image_Margin;
    }
    [emptyView setNeedsLayout];
}
- (void) layoutSubviews{
    [super layoutSubviews];
    float topMargin = (self.superTheView.height - self.viewHeight)/2 + self.viewOffset.y;
    float viewWidth = self.superTheView.width - 20 - self.viewOffset.x;
    if (viewWidth < 0 || viewWidth > [UIScreen mainScreen].bounds.size.width) {
        viewWidth = self.superTheView.width - 20;
    }
    float viewLeft = 10 + self.viewOffset.x;
    if (viewLeft < 0 || viewLeft > [UIScreen mainScreen].bounds.size.width - viewWidth - 10) {
        viewLeft = 10;
    }
    @weakify(self);
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(self.superTheView).offset(topMargin);
        make.left.mas_equalTo(self.superTheView).offset(viewLeft);
        make.right.mas_equalTo(self.superTheView).offset(-10);
        make.height.mas_equalTo(self.viewHeight);
    }];
    if (self.imageView.image) {
        float imageLeft = (viewWidth - self.imageSize.width)/2;
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.size.mas_equalTo(self.imageSize);
            make.top.mas_equalTo(self);
            make.left.mas_equalTo(self).offset(imageLeft);
        }];
    }
    if (self.label.text) {
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.mas_equalTo(self).offset(self.imageSize.height + kLabel_Image_Margin);
            make.left.right.equalTo(self);
            make.height.mas_equalTo(kLabelHeight);
        }];
    }
    if (self.button.titleLabel.text) {
        float buttonLeft = (viewWidth - kButtonWidth)/2;
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.bottom.mas_equalTo(self);
            make.width.mas_equalTo(kButtonWidth);
            make.height.mas_equalTo(kButtonHeight);
            make.left.mas_equalTo(self).offset(buttonLeft);
        }];
    }
}
- (void)showInView:(UIView *)aView
{
    [aView addSubview:self];
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}
- (void)dismissAnimated:(BOOL)aAnimated
{
    if (aAnimated)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
    else
    {
        [self removeFromSuperview];
    }
}

- (void)clickButton:(UIButton *)sender {
    if (self.buttonHander) {
        self.buttonHander();
    }
}
+(void)removeFromView:(UIView *)aView {
    GTEmptyView *emptyView = [aView viewWithTag:kGTEmptyViewTag];
    if (!emptyView) {
        return;
    }
    [emptyView dismissAnimated:YES];
}

#pragma mark - property
- (UIImageView *) imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [_imageView setBackgroundColor:[UIColor clearColor]];
    }
    return _imageView;
}
- (UILabel *) label{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = kTextColor;
        _label.font = [UIFont systemFontOfSize:kTextFontSize];
    }
    return _label;
}
- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitleColor:kButtonColor forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont systemFontOfSize:kButtonTitleFontSize];
        _button.layer.borderWidth = 1.0f;
        _button.layer.borderColor = kButtonColor.CGColor;
//        _button.layer.cornerRadius = 2;
//        _button.layer.masksToBounds = YES;
    }
    return _button;
}
@end
