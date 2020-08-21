//
//  YGViewController.m
//  YGTagView
//
//  Created by holaux@gmail.com on 08/21/2020.
//  Copyright (c) 2020 holaux@gmail.com. All rights reserved.
//

#import "YGViewController.h"
#import <YGTagView/YGTagView.h>

@interface YGViewController ()

@property (nonatomic, strong) YGTagView *tagView;

@end

@implementation YGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tagView = [[YGTagView alloc] initWithFrame:CGRectMake(20, 100, 300, 200)];
    _tagView.itemSpacing = 10;
    _tagView.lineSpacing = 10;
    _tagView.sectionInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    _tagView.backgroundColor = [UIColor lightGrayColor];
    
    NSArray *tags = @[@"测试1",
                      @"测试2",
                      @"测试33333",
                      @"测试4",
                      @"测试5",
                      @"测试6",
                      @"测试7777",
                      @"测试8",
                      @"测试9",
                      @"测试10000000"];
    for (NSString *tag in tags) {
        YGTagEntity *entity = [YGTagEntity tagWithText:tag];
        entity.selectedBorderColor = [UIColor purpleColor];
        entity.selectedBorderWidth = 1;
        entity.target = self;
        entity.edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        entity.action = @selector(handleTagAction:);
        entity.cornerRadius = 5;
        entity.selected = arc4random() % 2 == 0 ? NO : YES;
        [_tagView addTag:entity];
    }
    [self.view addSubview:_tagView];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)handleTagAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    NSLog(@"tag:%@", sender.titleLabel.text);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
