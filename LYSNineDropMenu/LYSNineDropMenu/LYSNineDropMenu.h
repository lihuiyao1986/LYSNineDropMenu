//
//  LYSNineDropMenu.h
//  LYSNineDropMenu
//
//  Created by jk on 2017/4/11.
//  Copyright © 2017年 Goldcard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYSNineDropMenu : UIView

@property(nonatomic,copy)NSArray *items;

@property(nonatomic,assign)NSUInteger colums;

@property(nonatomic,assign)CGFloat rowSpacing;

@property(nonatomic,assign)CGFloat itemH;

@property(nonatomic,assign)CGFloat columnSpacing;

@property(nonatomic,assign)BOOL dismissOnTouchOutside;

@property(nonatomic,assign)CGFloat containerViewYOffset;

@property(nonatomic,strong)UIColor *selectedItemBgColor;

@property(nonatomic,assign)CGFloat selectedIndex;

@property(nonatomic,copy) void(^ItemSelectedBlock)(NSString *item,NSUInteger index);

-(void)show;

@end
