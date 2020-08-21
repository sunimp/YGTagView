//
//  YGTagEntity.h
//  YGTagView
//
//  Created by Sun on 2020/8/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YGTagEntity : NSObject

#pragma mark - tag 属性
// tag 文字
@property (nonatomic, strong) NSString *text;

// tag 文字字体, 默认 [UIFont systemFontOfSize:14]
@property (nonatomic, strong, nullable) UIFont *textFont;

// tag 选中文字字体, 默认 [UIFont systemFontOfSize:14 weight:UIFontWeightMedium]
@property (nonatomic, strong, nullable) UIFont *selectedTextFont;

// tag 文字颜色, 默认 [UIColor blackColor]
@property (nonatomic, strong, nullable) UIColor *textColor;

// tag 选中文字颜色, 默认 textColor
@property (nonatomic, strong, nullable) UIColor *selectedTextColor;

// tag 背景色 默认 [UIColor whiteColor]
@property (nonatomic, strong, nullable) UIColor *backgroundColor;

// tag 选中背景色 默认 [UIColor colorWithWhite:0.8 alpha:1.0]
@property (nonatomic, strong, nullable) UIColor *selectedBackgroundColor;

// tag 背景圆角, 默认 0
@property (nonatomic, assign) CGFloat cornerRadius;

// tag 的背景边框颜色, 默认 nil
@property (nonatomic, strong, nullable) UIColor *borderColor;

// tag 的背景选中边框颜色, 默认 borderColor
@property (nonatomic, strong, nullable) UIColor *selectedBorderColor;

// tag 的背景边框宽度, 默认 0
@property (nonatomic, assign) CGFloat borderWidth;

// tag 的选中背景边框宽度, 默认 borderWidth
@property (nonatomic, assign) CGFloat selectedBorderWidth;

// tag 文字距离背景上下左右的缩进, 默认 UIEdgeInsetsZero
@property (nonatomic, assign) UIEdgeInsets edgeInsets;

// tag 点击事件的响应 target
@property (nonatomic, strong, nullable) id target;

// tag 点击事件
@property (nonatomic, assign) SEL action;

// tag 是否选中, 默认 NO
@property (nonatomic, assign, getter = isSelected) BOOL selected;

#pragma mark - 构造方法
- (instancetype)initWithText:(NSString *)text;

+ (instancetype)tagWithText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
