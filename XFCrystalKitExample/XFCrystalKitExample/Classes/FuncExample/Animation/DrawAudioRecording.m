//
//  DrawAudioRecording.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/20.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

@import AVFoundation;

#import "DrawAudioRecording.h"
#import "DataTube.h"
#import "XFCrystalKit.h"


@implementation DrawAudioRecording
{
    int offset;
    UIBezierPath *vGrid;
    UIBezierPath *hGrid;
    
    AVAudioRecorder *recorder;
    
    DataTube *tube;
}

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return self;
    
    // 存储最近100个数据
    tube = [[DataTube alloc] initWithSize:100];
    
    // 检测是否可以录音
    if (![self startAudioSession])
    {
        printf("Error establishing audio session");
        return self;
    }
    
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(setNeedsDisplay)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    // 开始记录数据
    [self startListening];
    
    return self;
}

- (void) drawRect:(CGRect)rect
{
    // 添加录音频率数据
    [recorder updateMeters];
    CGFloat averagePower = pow(10, 0.05f * [recorder averagePowerForChannel:0]);
    [tube push:@(averagePower)];
    
    if (!tube.count)
        return;
    
    UIColor *blueColor = [[UIColor blueColor] colorWithAlphaComponent:0.5f];
    UIColor *redColor = [[UIColor redColor] colorWithAlphaComponent:0.5f];
    UIColor *whiteColor = [UIColor whiteColor];
    UIFont *font = [UIFont systemFontOfSize:18];
    
    // Don't graph until the tube is full of samples
    /*if (_tube.count < 100)
     {
     UIBezierPath *sampling = BezierPathFromString(@"Sample",font,nil);
     MovePathCenterToPoint(sampling, RectGetCenter(rect));
     [sampling fill:blueColor];
     return;
     }*/
    
    // Draw the background
    CGFloat deltaY = self.bounds.size.height / 5;  // 20%
    
    // Draw horizontal lines
    if (!hGrid)
    {
        hGrid = [UIBezierPath bezierPath];
        for (int i = 0; i < 5; i++)
        {
            CGFloat dy = deltaY + ((CGFloat) i / 5.0f) * self.bounds.size.height;
            [hGrid moveToPoint:CGPointMake(0, dy)];
            [hGrid addLineToPoint:CGPointMake(self.bounds.size.width, dy)];
        }
    }
    [hGrid stroke:1.5 color:redColor];
    
    // Draw the moving vertical markers
    CGFloat deltaX = self.bounds.size.width / 100; // 1%
    
    // Build a basic grid
    if (!vGrid)
    {
        vGrid = [UIBezierPath bezierPath];
        for (int i = 0; i < 10; i++)
        {
            CGFloat dx = ((CGFloat) i / 3.0f) * self.bounds.size.width;
            [vGrid moveToPoint:CGPointMake(dx, 0)];
            [vGrid addLineToPoint:CGPointMake(dx, self.bounds.size.height)];
        }
    }
    
    // Draw dashed offset vertical lines
    PushDraw(^{
        UIBezierPath *vPath = [vGrid safeCopy];
        // 每一帧滚动1%，到100%时又回到1%，刚好接着上帧
        offset = (offset + 1) % 100;
        OffsetPath(vPath, CGSizeMake(-offset * deltaX, 0));
        AddDashesToPath(vPath);
        [vPath stroke:1 color:blueColor];
    });
    
    // Draw the label markers
    NSString *test = @"100%";
    CGSize testSize = [test sizeWithAttributes:@{NSFontAttributeName:font}];
    [blueColor set];
    for (int i = 0; i < 4; i++)
    {
        CGFloat dy = deltaY - testSize.height + ((CGFloat) i / 5.0f) * self.bounds.size.height;
        CGPoint p = CGPointMake(self.bounds.size.width - (testSize.width + 8), dy);
        NSString *each = @[@"80%", @"60%", @"40%", @"20%"][i];
        [each drawAtPoint:p withAttributes:@{NSFontAttributeName:font}];
    }
    
    // Draw out the data within the tube
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, self.bounds.size.height * (1 - [tube[0] floatValue]))];
    CGFloat dX = self.bounds.size.width / 100;
    // 把100个数据通过dX扩展到整个视图宽度上
    for (int i = 0; i < tube.count; i++)
        [path addLineToPoint:CGPointMake(i * dX, self.bounds.size.height * (1 - [tube[i] floatValue]))];
    [path stroke:2 color:whiteColor];
}




#pragma mark - 音频相关方法
- (BOOL) startAudioSession
{
    // Prepare the audio session
    NSError *error;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    if (![session setCategory:AVAudioSessionCategoryRecord error:&error])
    {
        NSLog(@"Error setting session category: %@", error.localizedFailureReason);
        return NO;
    }
    
    if (![session setActive:YES error:&error])
    {
        NSLog(@"Error activating audio session: %@", error.localizedFailureReason);
        return NO;
    }
    
    return session.inputAvailable; // used to be inputIsAvailable
}

// Begin recording
- (void) startListening
{
    NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
    settings[AVFormatIDKey] = @(kAudioFormatAppleLossless);
    settings[AVSampleRateKey] = @(44100.0);
    settings[AVNumberOfChannelsKey] = @(1); // mono
    settings[AVEncoderAudioQualityKey] = @(AVAudioQualityMax);
    
    NSError *error;
    recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    if (!recorder)
    {
        NSLog(@"Failed to establish recorder: %@", error.localizedDescription);
        return;
    }
    
    [recorder prepareToRecord];
    recorder.meteringEnabled = YES;
    [recorder record];
    
    if (!recorder.isRecording)
    {
        NSLog(@"Error: is not recording");
        return;
    }
}

- (void) stopListening
{
    if (recorder)
    {
        [recorder stop];
        recorder = nil;
        
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:NO error:nil];
    }
}

- (void)dealloc
{
    [self stopListening];
}
@end
