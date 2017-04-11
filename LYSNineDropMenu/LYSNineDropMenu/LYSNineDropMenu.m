//
//  LYSNineDropMenu.m
//  LYSNineDropMenu
//
//  Created by jk on 2017/4/11.
//  Copyright © 2017年 Goldcard. All rights reserved.
//

#import "LYSNineDropMenu.h"


@interface LYSNineDropMenu ()

@property(nonatomic,strong)UIView *containerView;

@end

static NSTimeInterval duration = 0.25;

@implementation LYSNineDropMenu

#pragma mark - 初始化方法
- (instancetype)init{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        [self initConfig];
    }
    return self;
}

-(UIView *)containerView{
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.backgroundColor = [self colorWithHexString:@"ffffff" alpha:1.0];
    }
    return _containerView;
}

#pragma mark -  显示的行数
-(NSUInteger)rows{
    return self.items.count / self.colums + 1;
}

#pragma mark - 初始化配置
-(void)initConfig{
    [self setDefaults];
    self.backgroundColor = [self colorWithHexString:@"000000" alpha:0.4];
    [self addSubview:self.containerView];
}

#pragma mark - 设置数据
-(void)setItems:(NSArray *)items{
    _items = items;
    [self updateSubViews];
}

#pragma mark - 更新子视图
-(void)updateSubViews{
    for(UIView *subView in self.containerView.subviews){
        [subView removeFromSuperview];
    }
    __weak typeof (self)MyWeakSelf = self;
    [self.items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *_itemBtn = [MyWeakSelf createItemBtn:obj atIndex:idx];
        [MyWeakSelf.containerView addSubview:_itemBtn];
    }];
}

#pragma mark - 重写layoutSubviews方法
-(void)layoutSubviews{
    [super layoutSubviews];
    __weak typeof (self)MyWeakSelf = self;
    self.containerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), [self containerH]);
    [self.containerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat itemW = (CGRectGetWidth(MyWeakSelf.frame) - (MyWeakSelf.colums + 1) * MyWeakSelf.columnSpacing) / MyWeakSelf.colums;
        CGFloat xOffset = (idx % MyWeakSelf.colums) * (itemW + MyWeakSelf.columnSpacing) + MyWeakSelf.columnSpacing;
        CGFloat yOffset = (idx / MyWeakSelf.colums) * (MyWeakSelf.itemH + MyWeakSelf.rowSpacing) + MyWeakSelf.rowSpacing + MyWeakSelf.containerViewYOffset;
        obj.frame = CGRectMake(xOffset, yOffset, itemW, MyWeakSelf.itemH);
    }];
}

#pragma mark - 高度
-(CGFloat)containerH{
    return (self.itemH + self.rowSpacing)* [self rows] + self.rowSpacing + self.containerViewYOffset;
}


#pragma mark - 创建item按钮
-(UIButton*)createItemBtn:(NSString*)title atIndex:(NSUInteger)index{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = 1000 + index;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    if (self.selectedIndex != -1){
        btn.selected = self.selectedIndex == index;
    }
    [btn setBackgroundImage:[self createImageWithColor:[self colorWithHexString:@"ffffff" alpha:1.0]] forState:UIControlStateNormal];
    [btn setBackgroundImage:[self createImageWithColor:self.selectedItemBgColor] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[self createImageWithColor:self.selectedItemBgColor] forState:UIControlStateSelected];
    [btn setTitleColor:[self colorWithHexString:@"414141" alpha:1.0] forState:UIControlStateNormal];
    [btn setTitleColor:[self colorWithHexString:@"ffffff" alpha:1.0] forState:UIControlStateHighlighted];
    [btn setTitleColor:[self colorWithHexString:@"ffffff" alpha:1.0] forState:UIControlStateSelected];
    btn.layer.borderWidth = 0.5;
    btn.layer.cornerRadius = 4.f;
    btn.layer.masksToBounds = YES;
    btn.layer.borderColor = [self colorWithHexString:@"e2e3e4" alpha:1.0].CGColor;
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark - 设置选中背景颜色
-(void)setSelectedItemBgColor:(UIColor *)selectedItemBgColor{
    _selectedItemBgColor = selectedItemBgColor;
    [self.items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [self.containerView viewWithTag:1000 + idx];
        [btn setBackgroundImage:[self createImageWithColor:self.selectedItemBgColor] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[self createImageWithColor:self.selectedItemBgColor] forState:UIControlStateSelected];
    }];
}

#pragma mark - 显示
-(void)show{
    [self removeFromSuperview];
    self.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    __weak typeof (self)MyWeakSelf = self;
    __block CGRect containerFrame = self.containerView.frame;
    containerFrame.origin.y = -[self containerH];
    self.containerView.frame = containerFrame;
    [UIView animateWithDuration:duration animations:^{
        containerFrame.origin.y = 0;
        MyWeakSelf.alpha = 1.0;
        MyWeakSelf.containerView.frame = containerFrame;
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - 隐藏
-(void)hide:(void(^)())finishedBlock{
    __weak typeof (self)MyWeakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        __block CGRect containerFrame = MyWeakSelf.containerView.frame;
        containerFrame.origin.y = -[MyWeakSelf containerH];
         MyWeakSelf.containerView.frame = containerFrame;
         MyWeakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        if (finishedBlock) {
            finishedBlock();
        }
        [MyWeakSelf removeFromSuperview];
    }];
}

#pragma mark - 按钮被点击的回调
-(void)btnClicked:(UIButton*)sender{
    __weak typeof (self)MyWeakSelf = self;
    [self hide:^{
        if (MyWeakSelf.ItemSelectedBlock) {
            NSUInteger index = sender.tag - 1000;
            MyWeakSelf.ItemSelectedBlock(MyWeakSelf.items[index],index);
        }
    }];
}

#pragma mark - touchesBegan
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    CGPoint point = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(self.containerView.frame, point)) {
        if(self.dismissOnTouchOutside){
            [self hide:nil];
        }
    }
}

#pragma mark - 将颜色转换成图片
- (UIImage *)createImageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark - 生成16进制颜色
-(UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha{
    
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

#pragma mark - 设置默认值
-(void)setDefaults{
    
    _colums = 3;
    
    _rowSpacing = 5.f;
    
    _selectedIndex = -1;
    
    _columnSpacing = 5.f;
    
    _itemH = 30.f;
    
    _containerViewYOffset = 0.f;
    
    _selectedItemBgColor = [self colorWithHexString:@"1686D5" alpha:1.0];
    
}
@end
