//
//  GTLoginTextField.m
//  GTI8Login
//
//  Created by 郭通 on 17/1/16.
//  Copyright © 2017年 郭通. All rights reserved.
//

#import "GTLoginTextField.h"

#define padding 5
#define heightSpaceing 2

@interface GTLoginTextField()<UITextFieldDelegate>

//注释
@property (nonatomic,strong) UILabel *placeholderLabel;

//填充线
@property (nonatomic,strong) CALayer *lineLayer;

//移动一次
@property (nonatomic,assign) BOOL moved;

@end


@implementation GTLoginTextField

static const CGFloat lineWidth = 1;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _textField = [[UITextField alloc]initWithFrame:CGRectZero];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.font = [UIFont systemFontOfSize:15.f];
        _textField.textColor = [UIColor blackColor];
        _textField.delegate = self;
//        _textField.tintColor = [UIColor whiteColor];
        [self addSubview:_textField];
        
        _placeholderLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _placeholderLabel.font = [UIFont systemFontOfSize:13.f];
        _placeholderLabel.textColor = [UIColor lightGrayColor];
        _placeholderLabel.hidden = YES;
        [self addSubview:_placeholderLabel];
        
        _placeholderNormalStateColor = [UIColor lightGrayColor];
        _placeholderSelectStateColor = [UIColor lightGrayColor];
        
        _lineView = [[UIView alloc]initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_lineView];
        
        _lineLayer = [CALayer layer];
        _lineLayer.frame = CGRectMake(0,0, 0, lineWidth);
        _lineLayer.anchorPoint = CGPointMake(0, 0.5);
        _lineLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
        [_lineView.layer addSublayer:_lineLayer];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(obserValue:) name:UITextFieldTextDidChangeNotification object:_textField];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    _textField.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-lineWidth);
    _placeholderLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-lineWidth);
    _lineView.frame = CGRectMake(0, CGRectGetHeight(self.frame)-lineWidth, CGRectGetWidth(self.frame), lineWidth);
}

-(void)obserValue:(NSNotification *)obj{
    [self changeFrameOfPlaceholder];
}

-(void)changeFrameOfPlaceholder{
    
    CGFloat y = _placeholderLabel.center.y;
    CGFloat x = _placeholderLabel.center.x;
    
    if (self.changeTextBlock) {
        self.changeTextBlock(self.textField.text);
    }
    
    if(_textField.text.length != 0 && !_moved){
        _placeholderLabel.hidden = NO;
        [self moveAnimation:x y:y];
    }else if(_textField.text.length == 0 && _moved){
        [self backAnimation:x y:y];
    }
}

-(void)moveAnimation:(CGFloat)x y:(CGFloat)y{
    __block CGFloat moveX = x;
    __block CGFloat moveY = y;
    
    _placeholderLabel.font = [UIFont systemFontOfSize:10.f];
    _placeholderLabel.textColor = _placeholderSelectStateColor;
    
    [UIView animateWithDuration:0.25 animations:^{
        moveY -= _placeholderLabel.frame.size.height/2 + heightSpaceing;
        moveX -= padding;
        _placeholderLabel.center = CGPointMake(moveX, moveY);
        _placeholderLabel.alpha = 1;
        _moved = YES;
        _lineLayer.bounds = CGRectMake(0, 0, CGRectGetWidth(self.frame), lineWidth);
    }];
}

-(void)backAnimation:(CGFloat)x y:(CGFloat)y{
    __block CGFloat moveX = x;
    __block CGFloat moveY = y;
    
    _placeholderLabel.font = [UIFont systemFontOfSize:13.f];
    _placeholderLabel.textColor = _placeholderNormalStateColor;
    
    [UIView animateWithDuration:0.15 animations:^{
        moveY += _placeholderLabel.frame.size.height/2 + heightSpaceing;
        moveX += padding;
        _placeholderLabel.center = CGPointMake(moveX, moveY);
        _placeholderLabel.alpha = 0;
        _moved = NO;
        _lineLayer.bounds = CGRectMake(0, 0, 0, lineWidth);
    }completion:^(BOOL finished) {
    }];
}

-(void)setLy_placeholder:(NSString *)ly_placeholder{
    _ly_placeholder = ly_placeholder;
    _placeholderLabel.text = ly_placeholder;
    _textField.placeholder = ly_placeholder;
}
- (void) setKeyboardType:(UIKeyboardType)keyboardType
{
    _textField.keyboardType = keyboardType;
}
- (void) setTextAlignment:(NSTextAlignment)textAlignment
{
    _textField.textAlignment = textAlignment;
}
-(void)setCursorColor:(UIColor *)cursorColor{
    _textField.tintColor = cursorColor;
}
- (void) setAutocorrection:(UITextAutocorrectionType)autocorrection
{
    _textField.autocorrectionType = autocorrection;
}
- (void) setTextMode:(UITextFieldViewMode)textMode
{
    _textField.clearButtonMode = textMode;
}
- (void) setEnableReturnKey:(BOOL)enableReturnKey
{
    _textField.enablesReturnKeyAutomatically =enableReturnKey;
}
- (void) setSecureTextEntry:(BOOL)secureTextEntry
{
    _textField.secureTextEntry = secureTextEntry;
}
- (void) setAutocapitalization:(UITextAutocapitalizationType)autocapitalization
{
    _textField.autocapitalizationType = autocapitalization;
}
-(void)setPlaceholderNormalStateColor:(UIColor *)placeholderNormalStateColor{
    if(!placeholderNormalStateColor){
        _placeholderLabel.textColor = [UIColor lightGrayColor];
    }else{
        _placeholderLabel.textColor = placeholderNormalStateColor;
    }
}
-(void)setPlaceholderSelectStateColor:(UIColor *)placeholderSelectStateColor{
    if(!placeholderSelectStateColor){
        _placeholderSelectStateColor = [UIColor whiteColor];
    }else{
        _placeholderSelectStateColor = placeholderSelectStateColor;
    }
}
- (NSString *) textValue
{
    return self.textField.text;
}
- (void) regsinField
{
    [self.textField  resignFirstResponder];
}
- (void) becomeAction
{
    [self.textField becomeFirstResponder];
}
@end
