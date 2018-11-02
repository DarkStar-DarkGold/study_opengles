//
//  ViewController.m
//  KY_GIF
//
//  Created by wangkaiyu on 2018/10/29.
//  Copyright © 2018年 wangkaiyu. All rights reserved.
//

#import "ViewController.h"
#import "KYView.h"
#import "KYFbo.h"
@interface ViewController (){
    UIButton *_btn;
    int ind;
    KYView *openGLView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    openGLView = [[KYView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:openGLView];
//    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _btn.frame = CGRectMake(0.0, 50.0, 50.0, 50.0);
//    _btn.backgroundColor = [UIColor redColor];
//    [_btn setTitle:@"暂停" forState:UIControlStateNormal];
//    [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_btn addTarget:self action:@selector(clickbtn) forControlEvents:UIControlEventTouchUpInside];
//    [self.view insertSubview:_btn atIndex:10];
//    [[[UIApplication sharedApplication] keyWindow] addSubview:_btn];
    
}

//- (void)clickbtn{
//    ind ++;
//    if(ind == 2){
////        UIImage *image = [[NSBundle mainBundle]
//        UIImage* image=[UIImage imageNamed:@"timg.jpg"];
//        UIImageView  *imageView=[[UIImageView alloc] initWithImage:image];
//        [self.view addSubview:imageView];
//    }else{
//         [self.view addSubview:openGLView];
//        [self.view addSubview:_btn];
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
