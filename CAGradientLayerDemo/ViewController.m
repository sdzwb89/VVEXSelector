//
//  ViewController.m
//  CAGradientLayerDemo
//
//  Created by zhangbin on 2018/7/14.
//  Copyright © 2018年 VVEX. All rights reserved.
//

#import "ViewController.h"
#import "VVEXGradientView.h"

@interface ViewController ()<VVEXGradientViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = UIColor.lightGrayColor;
    
    VVEXGradientView *gv = [[VVEXGradientView alloc] initWithFrame:CGRectMake(0, 200, self.view.bounds.size.width, 100)];
    gv.delegate = self;
    [self.view addSubview:gv];
}

- (void)choiceAtIndex:(NSInteger)index {
    
    NSLog(@"%zd",index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
