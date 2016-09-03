//
//  BuildingMarchingAnts.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/20.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "BuildingMarchingAnts.h"
#import "XFCrystalKit.h"

@interface BuildingMarchingAnts ()

@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, assign) CGPoint p1;
@end

@implementation BuildingMarchingAnts


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(setNeedsDisplay)];
        [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.p1 = [[touches anyObject] locationInView:self];
    self.path = nil;
}
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint p2 = [[touches anyObject] locationInView:self];
    CGRect rect = PointsMakeRect(self.p1, p2);
    self.path = [UIBezierPath bezierPathWithRect:rect];
}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesMoved:touches withEvent:event];
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesMoved:touches withEvent:event];
}



// The drawRect: method is called each time the display
// link fires. That's because calling setNeedsDisplay
// on the view notifies the system that the view contents
// need redrawing on the next drawing cycle.

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    
    CGFloat dashes[] = {12, 3};
    CGFloat distance = 15;
    CGFloat secondsPerFrame = 0.75f; // Adjust as desired
    
    NSTimeInterval ti = [NSDate timeIntervalSinceReferenceDate] / secondsPerFrame;
    if((ti - floor(ti)) > 0.98f)
        NSLog(@"%f",(ti - floor(ti)));
    
    BOOL goesCW = YES;
    CGFloat phase = distance * (ti - floor(ti)) * (goesCW ? -1 : 1);
    
    [self.path setLineDash:dashes count:2 phase:phase];
    [self.path stroke:3 color:WHITE_LEVEL(0.75, 1)];
}

@end

