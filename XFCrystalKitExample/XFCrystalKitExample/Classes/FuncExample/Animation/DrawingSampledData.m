//
//  DrawingSampledData.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/20.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "DrawingSampledData.h"
#import "XFCrystalKit.h"

#define RANDOM(_X_)     (NSInteger)(random() % _X_)

@interface DrawingSampledData ()

@property (nonatomic, strong) NSMutableArray<NSValue *> *samples;
@property (nonatomic, assign) NSInteger offset;
@end

@implementation DrawingSampledData


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.samples = [[NSMutableArray<NSValue *> alloc] init];
        // 模拟数据，应该在远程加载小段数据添加到数据后面
        for (int i = 0; i<1000; i++) {
            [self.samples addObject:[NSValue valueWithCGPoint:CGPointMake(i * 5.f, random() % 380)]];
        }
        
        
        CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(setNeedsDisplay)];
        [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        link.frameInterval = 10;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGFloat amount = 50;
    
    // draw line
    UIBezierPath *line = [UIBezierPath bezierPathWithRect:CGRectMake(0, rect.size.height - amount, rect.size.width, 0.5f)];
    [[UIColor orangeColor] setStroke];
    [line stroke];
    
    for (int i=1; i<4; i++) {
        OffsetPath(line, CGSizeMake(0, -amount));
        [[UIColor orangeColor] setStroke];
        [line stroke];
    }
    
    // draw samples
    UIBezierPath *node = [UIBezierPath bezierPath];
    NSInteger count = self.samples.count;
    for (NSInteger i= 0; i<self.offset+100 && i < count; i++) {
        NSValue *value = self.samples[i];
        if (i == 0) {
            [node moveToPoint:[value CGPointValue]];
        }
        [node addLineToPoint:[value CGPointValue]];
    }
    // 向右渐进
    OffsetPath(node, CGSizeMake(-self.offset, 0));
    [node stroke:1 color:[UIColor purpleColor]];
    
    self.offset++;
    
    // 当每次向右前进5次，就把数组前面删除一个
    if (self.offset % 5 == 0) {
        [self.samples removeObjectAtIndex:0];
    }
}
@end