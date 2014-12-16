//
//  ViewController.m
//  1107ZJ二维码读取
//
//  Created by base on 15/09/19.
//  Copyright © 2015年 base. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic,strong) AVCaptureSession *session;

@property (nonatomic,weak) AVCaptureVideoPreviewLayer *preview;

@property (nonatomic,strong) AVCaptureDevice *device;

@property (nonatomic,strong) AVCaptureDeviceInput *input;

@property (nonatomic,strong) AVCaptureMetadataOutput *outPut;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    }

/*
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
   //1 获取到摄像头设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    
  // 2 把摄像头设备当做输入设备
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    //3 源数据输出处理对象
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    
    //3.1 设置代理
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //4 连接会话
    self.session = [[AVCaptureSession alloc] init];
    [self.session addOutput:output];
    [self.session addInput:input];
    
    //4.1 设置元数据输出处理类型
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    //4.2 添加预览图层
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    
    layer.frame = self.view.bounds;
    
    [self.view.layer addSublayer:layer];
    self.layer = layer;
    
    //5 启动会话
    [self.session startRunning];
    
}
*/

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self setUpCamera];

}

-(void)setUpCamera
{
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    self.outPut = [[AVCaptureMetadataOutput alloc]init];
    
    [_outPut setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    self.session = [[AVCaptureSession alloc]init];
    
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([self.session canAddInput:self.input])
    {
        [self.session addInput:self.input];
        
    }
    
    if ([self.session canAddOutput:self.outPut])
    {
        [self.session addOutput:self.outPut];
    }
    
    //这一行代码等价于下一行代码，需要放在addOutput后面
//    self.outPut.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
     self.outPut.metadataObjectTypes = [NSArray arrayWithObject:AVMetadataObjectTypeQRCode];
    
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    
    //添加这一行，就可以使得扫面的图形不成正比。
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    _preview.frame =CGRectMake(20,110,280,280);
    
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    [self.session startRunning];
}
#pragma mark -- 元数据处理的代理方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    
    if ([metadataObjects count] > 0 ) {
        
        //
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        
        stringValue = metadataObject.stringValue;
        
        NSLog(@"%@",metadataObject.stringValue);
        
        //只执行一次会话
        [self.session stopRunning];
        
        //将layer层移除
        [self.preview removeFromSuperlayer];
    }
    
    
    
}



@end
