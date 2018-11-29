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
#import <AssetsLibrary/ALAssetsLibrary.h>
@interface ViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate>


@property (nonatomic , strong) AVCaptureSession *mCaptureSession;
@property (nonatomic , strong) AVCaptureDeviceInput *mCaptureDeviceInput;
@property (nonatomic , strong) AVCaptureVideoDataOutput *mCaptureDeviceOutput;

@property (nonatomic , strong) KYView *mGLView;
@property (nonatomic , strong) UILabel *mLabel;

@end

@implementation ViewController
{
    dispatch_queue_t mProcessQueue;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mGLView = [[KYView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.mGLView];
    [self.mGLView setupGL];
    
    self.mCaptureSession = [[AVCaptureSession alloc] init];
    self.mCaptureSession.sessionPreset = AVCaptureSessionPreset1280x720;
    //    mProcessQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    mProcessQueue = dispatch_queue_create("mProcessQueue", DISPATCH_QUEUE_SERIAL);
    //    mProcessQueue = dispatch_get_main_queue();
    
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
    [self.mCaptureDeviceOutput setAlwaysDiscardsLateVideoFrames:NO];
    
    [self.mCaptureDeviceOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
    [self.mCaptureDeviceOutput setSampleBufferDelegate:self queue:mProcessQueue];
    if ([self.mCaptureSession canAddOutput:self.mCaptureDeviceOutput]) {
        [self.mCaptureSession addOutput:self.mCaptureDeviceOutput];
    }
    
    AVCaptureConnection *connection = [self.mCaptureDeviceOutput connectionWithMediaType:AVMediaTypeVideo];
    [connection setVideoOrientation:AVCaptureVideoOrientationPortraitUpsideDown];
    
    [self.mCaptureSession startRunning];
    //    mProcessQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 0, 100, 100);
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(swapFrontAndBackCameras) forControlEvents:UIControlEventTouchUpInside];
    //    self.view.userInteractionEnabled = YES;
    btn.userInteractionEnabled = YES;
    [self.view addSubview:btn];
    
    self.mLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 500, 100, 100)];
    self.mLabel.textColor = [UIColor redColor];
    [self.view addSubview:self.mLabel];
    
    //    [[UIApplication sharedApplication].keyWindow addSubview:btn];
}
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    static int frameID = 0;
    ++frameID;
    CFRetain(sampleBuffer);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        self.mLabel.text = [NSString stringWithFormat:@"%d", frameID];
        [self.mGLView displayPixelBuffer:pixelBuffer];
        CFRelease(sampleBuffer);
        
    });
    
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
            AVCaptureConnection *connection = [self.mCaptureDeviceOutput connectionWithMediaType:AVMediaTypeVideo];
            [connection setVideoOrientation:AVCaptureVideoOrientationPortraitUpsideDown];
            
            if (position == AVCaptureDevicePositionBack) {
                connection.videoMirrored = NO;
            }else{
                connection.videoMirrored = YES;
            }
            [self.mCaptureSession commitConfiguration];
            
            break;
        }
    }
}
//@interface ViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate>
//
//@property (nonatomic , strong) AVCaptureSession *mCaptureSession;
//@property (nonatomic , strong) AVCaptureDeviceInput *mCaptureDeviceInput;
//@property (nonatomic , strong) AVCaptureVideoDataOutput *mCaptureDeviceOutput;
//@property (nonatomic , strong) UIButton *btn;
//
//@property (nonatomic , strong) KYView *mkyView;
//@property (nonatomic , strong) UILabel *mLabel;
//
//@end
//
//@implementation ViewController
//{
//    dispatch_queue_t mProcessQueue;
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    self.mkyView = [[KYView alloc] initWithFrame:self.view.frame];
//    [self.view addSubview:self.mkyView];
//
//    [self.mkyView setupGL];
//
//    self.mCaptureSession = [[AVCaptureSession alloc] init];
//    self.mCaptureSession.sessionPreset = AVCaptureSessionPresetiFrame1280x720;
////    mProcessQueue = dispatch_get_main_queue();
////    mProcessQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
//    mProcessQueue = dispatch_queue_create("mProcessQueue", DISPATCH_QUEUE_SERIAL);
//
//    AVCaptureDevice *inputCamera = nil;
//    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
//    for (AVCaptureDevice *device in devices)
//    {
//        if ([device position] == AVCaptureDevicePositionFront)
//        {
//            inputCamera = device;
//        }
//    }
//
//    self.mCaptureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:inputCamera error:nil];
//
//    if ([self.mCaptureSession canAddInput:self.mCaptureDeviceInput]) {
//        [self.mCaptureSession addInput:self.mCaptureDeviceInput];
//    }
//
//    self.mCaptureDeviceOutput = [[AVCaptureVideoDataOutput alloc] init];
//    [self.mCaptureDeviceOutput setAlwaysDiscardsLateVideoFrames:NO];
//
//    [self.mCaptureDeviceOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
//    [self.mCaptureDeviceOutput setSampleBufferDelegate:self queue:mProcessQueue];
//    if ([self.mCaptureSession canAddOutput:self.mCaptureDeviceOutput]) {
//        [self.mCaptureSession addOutput:self.mCaptureDeviceOutput];
//    }
//
//    AVCaptureConnection *connection = [self.mCaptureDeviceOutput connectionWithMediaType:AVMediaTypeVideo];
//    [connection setVideoOrientation:AVCaptureVideoOrientationPortraitUpsideDown];
//
//    [self.mCaptureSession startRunning];
//
//    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.btn.frame = CGRectMake(0, 0, 100, 100);
//    self.btn.backgroundColor = [UIColor redColor];
//    [self.btn addTarget:self action:@selector(swapFrontAndBackCameras) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.btn];
//    self.mLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 100, 100)];
//    self.mLabel.textColor = [UIColor redColor];
//    [self.view addSubview:self.mLabel];
//
//}
//
//
//- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
//    static long frameID = 0;
//    ++frameID;
//    CFRetain(sampleBuffer);
//    dispatch_async(dispatch_get_main_queue(), ^{
//        CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
//        self.mLabel.text = [NSString stringWithFormat:@"%ld", frameID];
//        [self.mkyView displayPixelBuffer:pixelBuffer];
//
//        CFRelease(sampleBuffer);
//    });
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}
//
//- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
//{
//    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
//    for ( AVCaptureDevice *device in devices )
//        if ( device.position == position )
//            return device;
//    return nil;
//}
//
//- (void)swapFrontAndBackCameras {
//    // Assume the session is already running
////    AVCaptureConnection *connection = [self.mCaptureDeviceOutput connectionWithMediaType:AVMediaTypeVideo];
//
//    NSArray *inputs = self.mCaptureSession.inputs;
//    for ( AVCaptureDeviceInput *input in inputs ) {
//        AVCaptureDevice *device = input.device;
//        if ( [device hasMediaType:AVMediaTypeVideo] ) {
//            AVCaptureDevicePosition position = device.position;
//            AVCaptureDevice *newCamera = nil;
//            AVCaptureDeviceInput *newInput = nil;
//
//            if (position == AVCaptureDevicePositionFront)
//                newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
//            else
//                newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
//            newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
//
//            // beginConfiguration ensures that pending changes are not applied immediately
//            [self.mCaptureSession beginConfiguration];
//
//            [self.mCaptureSession removeInput:input];
//            [self.mCaptureSession addInput:newInput];
//
//            // Changes take effect once the outermost commitConfiguration is invoked.
//
//            [self.mCaptureSession commitConfiguration];
//            AVCaptureConnection *connection = [self.mCaptureDeviceOutput connectionWithMediaType:AVMediaTypeVideo];
//            [connection setVideoOrientation:AVCaptureVideoOrientationPortraitUpsideDown];
//            if (position == AVCaptureDevicePositionBack){
//                connection.videoMirrored = NO;
//            }else{
//                connection.videoMirrored = YES;
//            }
//           break;
//        }
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
