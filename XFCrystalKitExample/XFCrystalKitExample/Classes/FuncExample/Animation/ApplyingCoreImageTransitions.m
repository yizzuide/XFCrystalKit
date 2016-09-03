//
//  ApplyingCoreImageTransitions.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/20.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "ApplyingCoreImageTransitions.h"
#import "XFCrystalKit.h"


@interface ApplyingCoreImageTransitions ()

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, weak)  CADisplayLink *link;

@property (nonatomic, strong) UIImage *source;
@property (nonatomic, strong) UIImage *target;
@end

@implementation ApplyingCoreImageTransitions

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(setNeedsDisplay)];
        [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        self.link = link;
        
        self.source = [UIImage imageNamed:@"source"];
        self.target = [UIImage imageNamed:@"target"];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    self.progress += 1.0f/20.f;
    
    if (self.progress > 1.0f) {
        // Our work here is done
        [self.link invalidate];
    }
    
    
    UIImage *image = [XFCrystal imageForTransitionCopyMachineFromImage:self.source targetImage:self.target progress:self.progress];
    
    [XFCrystal drawImage:image targetRect:rect drawingPattern:XFImageDrawingPatternFitting];
    
}

@end