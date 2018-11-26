//
//  ViewController.m
//  1
//
//  Created by wangkaiyu on 2018/11/25.
//  Copyright © 2018 wangkaiyu. All rights reserved.
//

#import "ViewController.h"
#import "YView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    YView *yview = [[YView alloc] initWithFrame:CGRectMake(0.0, 0.0, 400.0, 400.0)];
    [self.view addSubview:yview];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
