//
//  YGTagEntity.m
//  YGTagView
//
//  Created by Sun on 2020/8/21.
//

#import "YGTagEntity.h"

@implementation YGTagEntity

- (instancetype)initWithText:(NSString *)text {
    if (self = [super init]) {
        
        _text = text.copy;
        
        _textFont = [UIFont systemFontOfSize:14];
        _selectedTextFont = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        
        _textColor = [UIColor blackColor];
        _selectedTextColor = _textColor;
        
        _backgroundColor = [UIColor whiteColor];
        _selectedBackgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        
        _cornerRadius = 0;
        
        _borderColor = nil;
        _selectedBorderColor = _borderColor;
        
        _borderWidth = 0;
        _selectedBorderWidth = _borderWidth;
        
        _edgeInsets = UIEdgeInsetsZero;
        
        _selected = NO;
    }
    return self;
}

+ (instancetype)tagWithText:(NSString *)text {
    return [[self alloc] initWithText:text];
}

@end
