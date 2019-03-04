//
//  ViewController.m
//  纹理stb
//
//  Created by wangkaiyu on 2019/3/4.
//  Copyright © 2019 wangkaiyu. All rights reserved.
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
