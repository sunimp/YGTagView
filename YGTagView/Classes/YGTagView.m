//
//  YGTagView.m
//  YGTagView
//
//  Created by Sun on 2020/8/21.
//

#import "YGTagView.h"

static UIEdgeInsets const kDefaultInnerInsets = {5, 5, 5, 5};

#pragma mark - Tag Button
@interface YGTagButton ()

@property (nonatomic, strong) UIColor *normalBackgroundColor;

@property (nonatomic, strong) UIFont *textFont;

@property (nonatomic, strong) UIColor *borderColor;

@property (nonatomic, assign) CGFloat borderWidth;


@property (nonatomic, strong) UIColor *selectedBackgroundColor;

@property (nonatomic, strong) UIFont *selectedTextFont;

@property (nonatomic, strong) UIColor *selectedBorderColor;

@property (nonatomic, assign) CGFloat selectedBorderWidth;

@end

@implementation YGTagButton

- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    size.width += 10;
    return size;
}

- (void)setNormalBackgroundColor:(UIColor *)normalBackgroundColor {
    _normalBackgroundColor = normalBackgroundColor;
    self.backgroundColor = normalBackgroundColor;
}

- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    self.titleLabel.font = textFont;
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    self.layer.borderWidth = borderWidth;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        if (_selectedBackgroundColor == nil) {
            _selectedBackgroundColor = self.normalBackgroundColor;
        }
        
        if (_selectedTextFont == nil) {
            _selectedTextFont = self.textFont;
        }
        
        self.backgroundColor = _selectedBackgroundColor;
        self.titleLabel.font = _selectedTextFont;
        self.layer.borderColor = _selectedBorderColor.CGColor;
        self.layer.borderWidth = _selectedBorderWidth;
    } else {
        self.backgroundColor = self.normalBackgroundColor;
        self.titleLabel.font = self.textFont;
        self.layer.borderColor = _borderColor.CGColor;
        self.layer.borderWidth = _borderWidth;
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    self.clipsToBounds = YES;
    UIGraphicsBeginImageContext(CGSizeMake(1.0, 1.0));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, 1.0, 1.0));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self setBackgroundImage:image forState:state];
}

@end

#pragma mark - Tag View
@interface YGTagView ()

@property (nonatomic, strong) NSMutableArray<YGTagButton *> *allTags;
@property (nonatomic, assign) CGFloat intrinsicHeight;

@end

@implementation YGTagView

// 获取UIEdgeInsets在水平方向上的值
CG_INLINE CGFloat
UIEdgeInsetsGetHorizontalValue(UIEdgeInsets insets) {
    return insets.left + insets.right;
}

// 获取UIEdgeInsets在垂直方向上的值
CG_INLINE CGFloat
UIEdgeInsetsGetVerticalValue(UIEdgeInsets insets) {
    return insets.top + insets.bottom;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _sectionInsets = UIEdgeInsetsZero;
        _lineSpacing = 0;
        _itemSpacing = 0;
        _alignment = YBTagAligmentLeft;
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(self.frame.size.width, self.intrinsicHeight);
}

- (void)addTag:(YGTagEntity *)tag {
    
    // set button
    YGTagButton *button = [[YGTagButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [button setTitle:tag.text forState:UIControlStateNormal];
    
    button.textFont = tag.textFont;
    button.selectedTextFont = tag.selectedTextFont;
    
    button.normalBackgroundColor = tag.backgroundColor;
    button.selectedBackgroundColor = tag.selectedBackgroundColor;
    
    button.borderColor = tag.borderColor;
    button.selectedBorderColor = tag.selectedBorderColor;
    
    button.borderWidth = tag.borderWidth;
    button.selectedBorderWidth = tag.selectedBorderWidth;
    
    [button setTitleColor:tag.textColor forState:UIControlStateNormal];
    [button setTitleColor:tag.selectedTextColor forState:UIControlStateSelected];
    
    [button addTarget:tag.target action:tag.action forControlEvents:UIControlEventTouchUpInside];
    
    button.selected = tag.selected;
    
    CGSize buttonSize = CGSizeZero;
    CGSize constraintSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
    
    if (tag.textFont) {
        NSMutableParagraphStyle *paragraphStyle = [NSParagraphStyle defaultParagraphStyle].mutableCopy;
        [paragraphStyle setAlignment:NSTextAlignmentLeft];
        [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
        
        NSDictionary *stringAttributes = @{NSFontAttributeName:tag.textFont,
                                           NSParagraphStyleAttributeName:paragraphStyle};
        buttonSize = [tag.text boundingRectWithSize:constraintSize
                                            options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                         attributes:stringAttributes
                                            context:nil].size;
    }
    
    if (CGSizeEqualToSize(buttonSize, CGSizeZero)) return;
    UIEdgeInsets tagInsets = tag.edgeInsets;
    if (UIEdgeInsetsEqualToEdgeInsets(tagInsets, UIEdgeInsetsZero)) {
        tagInsets = kDefaultInnerInsets;
    }
    buttonSize.width  += UIEdgeInsetsGetHorizontalValue(tagInsets);
    buttonSize.height += UIEdgeInsetsGetVerticalValue(tagInsets);
    button.layer.cornerRadius = tag.cornerRadius;
    button.layer.masksToBounds = true;

    CGRect rect = CGRectMake(0, 0, buttonSize.width, buttonSize.height);
    button.frame = rect;

    [self.allTags addObject:button];
    [self rearrangeTags];
}

#pragma mark - Tag removal

- (void)removeTagWithText:(NSString *)tagText {
  
    YGTagButton *button = nil;
    for (YGTagButton *tag in self.allTags) {
        if ([tagText isEqualToString:tag.titleLabel.text]) {
            button = tag;
        }
    }

  if (!button) return;

  [button removeFromSuperview];
  [self.allTags removeObject:button];
  [self rearrangeTags];
}

- (void)removeAllTags {
  
    for (YGTagButton *tag in self.allTags) {
        [tag removeFromSuperview];
    }
    [self.allTags removeAllObjects];
    [self rearrangeTags];
}

- (void)rearrangeTags {
    // 左对齐布局
    if (_alignment == YBTagAligmentLeft) {
        
        [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        
        __block float maxY = self.sectionInsets.top;
        __block float maxX = self.sectionInsets.left;
        __block CGSize size;
        
        [self.allTags enumerateObjectsUsingBlock:^(YGTagButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            size = obj.frame.size;
            
            [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[YGTagButton class]]) {
                    maxY = MAX(maxY, CGRectGetMinY(obj.frame));
                }
            }];
            
            [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[YGTagButton class]]) {
                    if (CGRectGetMinY(obj.frame) == maxY) {
                        maxX = MAX(maxX, CGRectGetMinX(obj.frame) + CGRectGetWidth(obj.frame));
                    }
                }
            }];
            
            // 如果 tag 放不下换到新的一行
            if (size.width + maxX + self.itemSpacing > (CGRectGetWidth(self.frame) - self.sectionInsets.right)) {
                maxY += size.height + self.lineSpacing;
                maxX = self.sectionInsets.left;
            }
            obj.frame = CGRectMake(maxX + self.itemSpacing, maxY, size.width, size.height);
            [self addSubview:obj];
        }];
        
        CGRect rect = self.frame;
        CGFloat contentHeight = maxY + size.height + self.sectionInsets.bottom;
        self.intrinsicHeight = contentHeight > self.intrinsicHeight ? contentHeight : self.intrinsicHeight;
        self.frame = CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetWidth(rect), self.intrinsicHeight);
    } else { // 右对齐布局
        [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        __block float maxY = self.sectionInsets.top;
        __block float maxX = self.sectionInsets.left;
        __block CGSize size;
        [self.allTags enumerateObjectsUsingBlock:^(YGTagButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            size = obj.frame.size;
            [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[YGTagButton class]]) {
                    maxY = MAX(maxY, CGRectGetMinY(obj.frame));
                }
            }];
            
            [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[YGTagButton class]]) {
                    if (CGRectGetMinY(obj.frame) == maxY) {
                        maxX = MAX(maxX, CGRectGetWidth(self.frame) - CGRectGetMinX(obj.frame));
                    }
                }
            }];
            
            // 如果放不下换到新的一行
            if (size.width + maxX + self.itemSpacing > (CGRectGetWidth(self.frame) - self.sectionInsets.right)) {
                maxY += size.height + self.lineSpacing;
                maxX = self.sectionInsets.left;
            }
            obj.frame = CGRectMake(CGRectGetWidth(self.frame) - CGRectGetWidth(obj.frame) - maxX - self.itemSpacing, maxY, size.width, size.height);
            [self addSubview:obj];
        }];
        
        CGRect rect = self.frame;
        CGFloat contentHeight = maxY + size.height + self.sectionInsets.bottom;
        self.intrinsicHeight = contentHeight > self.intrinsicHeight ? contentHeight : self.intrinsicHeight;
        self.frame = CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetWidth(rect), self.intrinsicHeight);
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self rearrangeTags];
}

- (NSMutableArray<YGTagButton *> *)allTags {
    if (!_allTags) {
        _allTags = [NSMutableArray array];
    }
    return _allTags;
}

@end
