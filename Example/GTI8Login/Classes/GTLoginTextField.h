//
//  GTLoginTextField.h
//  GTI8Login
//
//  Created by 郭通 on 17/1/16.
//  Copyright © 2017年 郭通. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTLoginTextField : UIView

//注释信息
@property (nonatomic,copy) NSString *ly_placeholder;

//光标颜色
@property (nonatomic,strong) UIColor *cursorColor;

//注释普通状态下颜色
@property (nonatomic,strong) UIColor *placeholderNormalStateColor;

//注释选中状态下颜色
@property (nonatomic,strong) UIColor *placeholderSelectStateColor;

@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, assign) UIKeyboardType  keyboardType;
@property (nonatomic, assign) UITextAutocorrectionType autocorrection;
@property (nonatomic, assign) UITextFieldViewMode textMode;
@property (nonatomic, assign) BOOL enableReturnKey;
@property (nonatomic, assign) BOOL secureTextEntry;
@property (nonatomic, assign) UITextAutocapitalizationType autocapitalization;
- (void) regsinField;
- (void) becomeAction;

- (NSString *) textValue;

@end
