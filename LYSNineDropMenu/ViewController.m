//
//  ViewController.m
//  LYSNineDropMenu
//
//  Created by jk on 2017/4/11.
//  Copyright © 2017年 Goldcard. All rights reserved.
//

#import "ViewController.h"

#import "LYSNineDropMenu.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 120, self.view.bounds.size.width, 44);
    [btn setTitle:@"开始" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
      // Do any additional setup after loading the view, typically from a nib.
}

-(void)btnClicked:(UIButton*)sender{
    LYSNineDropMenu *menu = [LYSNineDropMenu new];
    menu.items = @[@"缴费",@"查询",@"查询",@"查询",@"查询",@"查询",@"查询"];
    menu.itemH = 30.f;
    menu.colums = 3;
    menu.rowSpacing = 10.f;
    menu.columnSpacing = 10.f;
    menu.containerViewYOffset = 20.f;
    menu.dismissOnTouchOutside = YES;
    menu.ItemSelectedBlock = ^(NSString *item,NSUInteger index){
        NSLog(@"you choosed %@ at index %lu",item,(unsigned long)index);
    };
    [menu show];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
