//
//  ViewController.m
//  BarcodeReader
//
//  Created by Bilgehan IŞIKLI on 24/04/2017.
//  Copyright © 2017 Blesh. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (weak, nonatomic) IBOutlet UIView *container;

@end

@implementation ViewController {
    UIButton *closeButton;
    NSArray* metaDatas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    metaDatas = @[AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeCode128Code];
    // Do any additional setup after loading the view, typically from a nib.
    [self searchQR];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)searchQR {
    
    NSError *error;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:metaDatas];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:self.container.layer.bounds];
    [self.container.layer addSublayer:_videoPreviewLayer];
    
    [_captureSession startRunning];
    

    closeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.container.frame.size.width-60, 20, 60, 30)];
    NSMutableDictionary* attributes = [[NSMutableDictionary alloc] init];
    
    [attributes setObject:[UIFont boldSystemFontOfSize:18]  forKey:NSFontAttributeName];
    
    [attributes setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    [closeButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"KAPAT" attributes:attributes] forState:UIControlStateNormal];
    
    [closeButton addTarget:self action:@selector(stopReading) forControlEvents:UIControlEventTouchUpInside];
    
    [self.container addSubview:closeButton];
}



- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([metaDatas containsObject:[metadataObj type]]) {
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                NSLog(@"deviceID : %@",[metadataObj stringValue]);
                //[self stopReading];
                
                
            });
            
            
        }
    }
}

-(void)stopReading{
    
    [closeButton removeFromSuperview];
    [_captureSession stopRunning];
    _captureSession = nil;
    [_videoPreviewLayer removeFromSuperlayer];
    [self.view setNeedsLayout];
}

@end
