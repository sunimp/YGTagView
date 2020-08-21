//
//  YGTagView.h
//  YGTagView
//
//  Created by Sun on 2020/8/21.
//

#import <UIKit/UIKit.h>
#import "YGTagEntity.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YBTagAligment) {
    YBTagAligmentLeft = 1,
    YBTagAligmentRight,
};

#pragma mark - Tag Button
@interface YGTagButton: UIButton

@end

@interface YGTagView : UIView

// tag 背景上下左右的缩进，默认 UIEdgeInsetsZero
@property (nonatomic, assign) UIEdgeInsets sectionInsets;

// 每行 tag 的间距, 默认 0
@property (nonatomic, assign) CGFloat lineSpacing;

// 每个 tag 之间的间距, 默认 0
@property (nonatomic, assign) CGFloat itemSpacing;

// tag 对齐方式, 默认 YBTagAligmentLeft
@property (nonatomic, assign) YBTagAligment alignment;

- (void)addTag:(YGTagEntity *)tag;

- (void)removeAllTags;

- (void)removeTagWithText:(NSString *)tagText;

@end

NS_ASSUME_NONNULL_END
