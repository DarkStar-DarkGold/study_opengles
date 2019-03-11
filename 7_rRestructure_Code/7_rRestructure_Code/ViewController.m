//
//  ViewController.m
//  7_rRestructure_Code
//
//  Created by mac on 2019/3/9.
//  Copyright © 2019 mac. All rights reserved.
//

#import "ViewController.h"
#import "YView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    YView *_yview = [[YView alloc] initWithFrame:self.view.frame];
    
    [self.view addSubview:_yview];
}


@end
