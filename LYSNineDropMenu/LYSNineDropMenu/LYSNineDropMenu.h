//
//  LYSNineDropMenu.h
//  LYSNineDropMenu
//
//  Created by jk on 2017/4/11.
//  Copyright © 2017年 Goldcard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYSNineDropMenu : UIView

#pragma mark - 数据
@property(nonatomic,copy)NSArray *items;

#pragma mark - 每页显示的列数
@property(nonatomic,assign)NSUInteger colums;

#pragma mark - 行间距
@property(nonatomic,assign)CGFloat rowSpacing;

#pragma mark - item的高度
@property(nonatomic,assign)CGFloat itemH;

#pragma mark - 列间距
@property(nonatomic,assign)CGFloat columnSpacing;

#pragma mark - 点击外面是否关闭窗口
@property(nonatomic,assign)BOOL dismissOnTouchOutside;

#pragma mark - containerViewYOffset
@property(nonatomic,assign)CGFloat containerViewYOffset;

#pragma mark - 选中时的背景颜色
@property(nonatomic,strong)UIColor *selectedItemBgColor;

#pragma mark - 选中的index 默认为-1 表示不选中任何item
@property(nonatomic,assign)CGFloat selectedIndex;

#pragma mark - item选中时的回调
@property(nonatomic,copy) void(^ItemSelectedBlock)(NSString *item,NSUInteger index);

#pragma mark - 显示方法
-(void)show;

@end
