//
//  ViewController.m
//  6MVPGL
//
//  Created by wangkaiyu on 2019/3/5.
//  Copyright © 2019 wangkaiyu. All rights reserved.
//

#import "ViewController.h"
#import "YView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    YView *yyview = [[YView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:yyview];
    // Do any additional setup after loading the view, typically from a nib.
}


@end
