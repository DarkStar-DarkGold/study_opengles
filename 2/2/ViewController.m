//
//  ViewController.m
//  2
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
    
    YView *yview = [[YView alloc]initWithFrame:self.view.bounds];
    
    [self.view addSubview:yview];
    // Do any additional setup after loading the view, typically from a nib.
}


@end
