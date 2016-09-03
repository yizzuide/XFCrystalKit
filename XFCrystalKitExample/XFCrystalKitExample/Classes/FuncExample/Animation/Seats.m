//
//  Seats.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/20.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "Seats.h"
#import "XFCrystalKit.h"

@interface Seats ()

@property (nonatomic, strong) NSMutableArray *seatMArr;

@property (nonatomic, assign) CGFloat currentOffsetX;
@property (nonatomic, assign) CGFloat sumOffsetX;
@property (nonatomic, assign) BOOL isDragEnd;
@property (nonatomic, strong) UIBezierPath *seatPath;

@property (nonatomic, assign) CGRect selectRect;
@property (nonatomic, strong) NSString *selectName;
@end

@implementation Seats

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.seatMArr = @[@"张无忌",@"令狐冲",@"段誉",@"郭靖",@"杨过",
                          @"赵敏",@"周芷若",@"殷离",@"小昭",@"杨不悔",
                          @"岳灵珊",@"任盈盈",@"东方不败",@"钟灵",@"木婉清",
                          @"王语嫣",@"黄容",@"华筝",@"小龙女",@"陆无双"].mutableCopy;
        self.userInteractionEnabled = YES;
        
        // 移动手势识别
         UIPanGestureRecognizer *dragGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(drag:)];
        [self addGestureRecognizer:dragGesture];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    NSString *text = @"东方不败";
    CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    
    
    NSInteger seatCount = self.seatMArr.count;
    
    CGFloat margin = 15;
    CGFloat padding = 8;
    NSInteger cols = 5;
    NSInteger rows = ceil(seatCount / (float)cols);
    // 单元格宽高
    CGSize cellWH = CGSizeMake(textSize.width + padding * 2 , textSize.height + padding * 2);
    // box宽高
    CGFloat boxW = cellWH.width * cols + (margin * (cols + 1));
    CGFloat boxH = cellWH.height * rows + (margin * (rows + 1));
    CGRect seatRect = CGRectMake(self.currentOffsetX, 0, boxW, boxH);
    
    if (self.isDragEnd) {
        // 如果向右拉出空白
        if (self.currentOffsetX > 0 && seatRect.origin.x > 0) {
            self.sumOffsetX = 0;
            // 拖动停止时设置当前偏移
            //self.currentOffsetX = self.sumOffsetX;
            // 重新设置座位范围Rect
            seatRect = CGRectMake(self.sumOffsetX, 0, boxW, boxH);
        // 如果向左拉出空白
        }else if(self.currentOffsetX < 0 && fabs(seatRect.origin.x) > (seatRect.size.width - self.frame.size.width)){
            self.sumOffsetX = -(seatRect.size.width - self.frame.size.width);
            // 拖动停止时设置当前偏移
            //self.currentOffsetX = self.sumOffsetX;
            // 重新设置座位范围Rect
            seatRect = CGRectMake(self.sumOffsetX, 0, boxW, boxH);
        }
    }
    
    UIBezierPath *seatPath = [UIBezierPath bezierPathWithRect:seatRect];
    [seatPath stroke:5 color:[UIColor redColor]];
    
    for (int i = 0; i<seatCount; i++) {
        CGFloat cellX = ((i % cols) * cellWH.width) + (margin * ((i % cols) + 1)) + seatRect.origin.x;
        CGFloat cellY = ((i / cols) * cellWH.height) + (margin * ((i / cols) + 1)) + seatRect.origin.y;
        CGRect cellRect = CGRectMake(cellX, cellY, cellWH.width, cellWH.height);
        //NSLog(@"i = %d,rect=%@",i,NSStringFromCGRect(cellRect));
        UIBezierPath *cell = [UIBezierPath bezierPathWithRect:cellRect];
        [seatPath appendPath:cell];
        
        // Draw the string
        NSString *name = self.seatMArr[i];
        CGRect target = RectAroundCenter(RectGetCenter(cell.bounds), [name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}]);
        [name drawInRect:target withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
        
        /*CGRect offsetSelectRect = CGRectMake(self.selectRect.origin.x + self.currentOffsetX, self.selectRect.origin.y, self.selectRect.size.width, self.selectRect.size.height);*/
        if(!self.selectName){
            if (CGRectEqualToRect(self.selectRect, cell.bounds)) {
                self.selectName = name;
                [cell stroke:1 color:[UIColor redColor]];
                continue;
            }
        }else if([self.selectName isEqualToString:name]){
            [cell stroke:1 color:[UIColor redColor]];
            continue;
        }
        
        [cell stroke:1 color:[UIColor orangeColor]];
    }
    
    self.seatPath = seatPath;
}

- (void)drag:(UIPanGestureRecognizer *)recognizer {
    // 获取偏移量
    CGPoint offset = [recognizer translationInView:self];
    CGFloat tx = offset.x;
    //CGFloat ty = offset.y;
    
    if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        // 累计上一次的移动位置
        self.sumOffsetX += tx;
        self.isDragEnd = YES;
        [self setNeedsDisplay];
    
    }else if(recognizer.state == UIGestureRecognizerStateChanged) {
        self.currentOffsetX = tx + self.sumOffsetX;
        // 从左向右
        /*if(tx > 0)
        {
            //NSLog(@"从左向右: %f",tx);
            if (self.seatPath.bounds.origin.x) {
                
            }
        }else{// 从右向左
            //NSLog(@"从右向左: %f",tx);
        }*/
        self.isDragEnd = NO;
        [self setNeedsDisplay];
    }
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    NSArray *supaths = self.seatPath.subpaths;
    for (UIBezierPath *path in supaths) {
        // 如果是最外围路径
        if (path.bounds.size.width > 200) {
            continue;
        }
        BOOL clicked = [path containsPoint:point];
        if (clicked) {
            NSLog(@"selcted path: %@",NSStringFromCGRect(path.bounds));
            self.selectRect = path.bounds;
            self.selectName = nil;
            [self setNeedsDisplay];
            return;
        }
    }
    
}
@end
