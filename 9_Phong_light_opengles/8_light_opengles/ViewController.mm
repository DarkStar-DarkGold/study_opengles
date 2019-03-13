//
//  ViewController.m
//  8_light_opengles
//
//  Created by mac on 2019/3/11.
//  Copyright © 2019 mac. All rights reserved.
//

#import "ViewController.h"
#import "./YView.h"
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
