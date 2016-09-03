//
//  XFContextFunc.h
//  XFCrystalKit
//
//  Created by yizzuide on 15/12/7.
//  Copyright © 2015年 yizzuide. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 翻转通过CGBitmapContextCreate(...)<默认原点从左下角开始>方法创建的Context坐标系 */
void FlipContextVertically(CGSize size);
void FlipContextHorizontally(CGSize size);

/** 翻转通过UIGraphicsBeginImageContextWithOptions()<默认原点从左上角开始，UIKit标准>创建的Context坐标系 */
void FlipImageContextVertically();
void FlipImageContextHorizontally();

// 翻转一张图片
UIImage *ImageMirroredVertically(UIImage *source);

/** 获得由UIGraphicsBeginImageContextWithOptions()<创建时是根据UIScreen.scale大小来的>创建的Point单位大小*/
CGSize GetUIKitContextSize();

/** Flip the path vertically with respect to the context*/
void MirrorPathVerticallyInContext(UIBezierPath *path);

// 旋转Context
void RotateContext(CGSize size, CGFloat theta);
// 移动Context
void MoveContextByVector(CGPoint vector);
