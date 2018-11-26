//
//  ViewController.m
//  3
//
//  Created by wangkaiyu on 2018/11/26.
//  Copyright © 2018 wangkaiyu. All rights reserved.
//

#import "ViewController.h"
#import "YView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    YView *yview = [[YView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:yview];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
