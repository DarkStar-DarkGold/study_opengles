//
//  ViewController.m
//  HelloOpenGL
//
//  Created by wangkaiyu on 2018/10/22.
//  Copyright © 2018年 wangkaiyu. All rights reserved.
//

#import "ViewController.h"
# import "KYopengles.h"

@interface ViewController ()
{
    KYopengles *_glView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    _glView = [[KYopengles alloc] ]
    _glView = [[KYopengles alloc] initWithFrame:self.view.bounds];

//    _glView = [[KYopengles alloc] initWithHeight:500.0 Lenth:500.0];
    //    _glView = [[KYopengles alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 100)];

    
    [self.view addSubview:_glView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
