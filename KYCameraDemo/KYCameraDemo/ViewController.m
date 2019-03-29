//
//  ViewController.m
//  KYCameraDemo
//
//  Created by wangkaiyu on 2018/11/28.
//  Copyright © 2018 wangkaiyu. All rights reserved.
//

#import "ViewController.h"
#import "KYView.h"
#import <AVFoundation/AVFoundation.h>
//#import <AssetsLibrary/ALAssetsLibrary.h>
@interface ViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate>
{
    dispatch_queue_t mProcessQueue;
}
@property (nonatomic , strong) AVCaptureSession *mCaptureSession;
@property (nonatomic , strong) AVCaptureDeviceInput *mCaptureDeviceInput;
@property (nonatomic , strong) AVCaptureVideoDataOutput *mCaptureDeviceOutput;

@property (nonatomic , strong) KYView *mkyView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mkyView = [[KYView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.mkyView];
    [self.mkyView setupGL];
    
    
    self.mCaptureSession = [[AVCaptureSession alloc] init];
    self.mCaptureSession.sessionPreset = AVCaptureSessionPresetiFrame1280x720;
    mProcessQueue = dispatch_get_main_queue();
//    mProcessQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);

    AVCaptureDevice *inputCamera = nil;
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == AVCaptureDevicePositionFront)
        {
            inputCamera = device;
        }
    }
    
    self.mCaptureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:inputCamera error:nil];
    
    if ([self.mCaptureSession canAddInput:self.mCaptureDeviceInput]) {
        [self.mCaptureSession addInput:self.mCaptureDeviceInput];
    }
    
    self.mCaptureDeviceOutput = [[AVCaptureVideoDataOutput alloc] init];
    [self.mCaptureDeviceOutput setAlwaysDiscardsLateVideoFrames:YES];
    

    [self.mCaptureDeviceOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
//        dispatch_queue_t queue = dispatch_queue_create("kySerialQueue", DISPATCH_QUEUE_SERIAL);
    [self.mCaptureDeviceOutput setSampleBufferDelegate:self queue:mProcessQueue];
    if ([self.mCaptureSession canAddOutput:self.mCaptureDeviceOutput]) {
        [self.mCaptureSession addOutput:self.mCaptureDeviceOutput];
    }
    
    AVCaptureConnection *connection = [self.mCaptureDeviceOutput connectionWithMediaType:AVMediaTypeVideo];
    [connection setVideoOrientation:AVCaptureVideoOrientationPortraitUpsideDown];

    [self.mCaptureSession startRunning];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(self.view.frame.size.width/2-25.0, 0,50 , 50);
    btn.layer.cornerRadius=btn.frame.size.width/2;
    btn.layer.masksToBounds = YES; //(带图片的必须设置这一项，默认是NO，如果只设置背景色，则可不用设置这一项)
    [btn setImage:[UIImage imageNamed:@"icon50.png"]
         forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(swapFrontAndBackCameras) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    [self.mkyView displayPixelBuffer:pixelBuffer];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position )
            return device;
    return nil;
}

- (void)swapFrontAndBackCameras {
    // Assume the session is already running
//    AVCaptureConnection *connection = [self.mCaptureDeviceOutput connectionWithMediaType:AVMediaTypeVideo];
    
    NSArray *inputs = self.mCaptureSession.inputs;
    for ( AVCaptureDeviceInput *input in inputs ) {
        AVCaptureDevice *device = input.device;
        if ( [device hasMediaType:AVMediaTypeVideo] ) {
            AVCaptureDevicePosition position = device.position;
            AVCaptureDevice *newCamera = nil;
            AVCaptureDeviceInput *newInput = nil;
            
            if (position == AVCaptureDevicePositionFront)
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            else
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
            
            // beginConfiguration ensures that pending changes are not applied immediately
            [self.mCaptureSession beginConfiguration];
            
            [self.mCaptureSession removeInput:input];
            [self.mCaptureSession addInput:newInput];
            
            // Changes take effect once the outermost commitConfiguration is invoked.
            
            [self.mCaptureSession commitConfiguration];
            AVCaptureConnection *connection = [self.mCaptureDeviceOutput connectionWithMediaType:AVMediaTypeVideo];
            [connection setVideoOrientation:AVCaptureVideoOrientationPortraitUpsideDown];
            if (position == AVCaptureDevicePositionBack){
                connection.videoMirrored = NO;
            }else{
                connection.videoMirrored = YES;
            }
           break;
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
