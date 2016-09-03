//
//  RenderingAPdf.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/19.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "RenderingAPdf.h"
#import "XFCrystalKit.h"
/**
 *  When you have that document, follow these steps:
 1. Check the number of pages in the document by calling
 CGPDFDocumentGetNumberOfPages().
 2. Retrieve each page by using CGPDFDocumentGetPage(). The page count starts with
 page 1, not page 0, as you might expect.
 3. Make sure you release the document with CGPDFDocumentRelease() after you finish your work.
 
 
 Upon grabbing CGPDFPageRef pages, that enables you to draw each one into an image context, using a rectangle you specify. What’s challenging is that the PDF functions draw using the Quartz coordinate system (with the origin at the bottom left), and the destinations you’ll want to draw to are in the UIKit coordinate system (with the origin at the top left).
 
 To handle this, you have to play a little hokey-pokey with your destination and with the context. First, you flip the entire context vertically, to ensure that the PDF page draws from the top down. Next, you transform your destination rectangle, so the page draws at the right place.
 
 You might wonder why you need to perform this double transformation, and the answer is this: After you flip your coordinate system to enable top-to-bottom Quartz drawing, your destination rectangle that used to be, for example, at the top right, will now draw at the bottom right. That’s because it’s still living in a UIKit world. After you adjust the drawing context’s transform, your rectangle must adapt to that transform，If you skip this step, your PDF output appears at the bottom right instead of the top right, as you intended.
 
 I encourage you to try this out on your own by commenting out the rectangle transform step and testing various destination locations. What you’ll discover is an important lesson in coordinate system conformance. Flipping the context doesn’t just “fix” the Quartz drawing; it affects all position definitions. You’ll see this same problem pop up in Chapter 7, when you draw text into UIKit paths. In that case, you won’t be working with just rectangles. You must vertically mirror the entire path in the drawing destination.
 
 When you’ve performed coordinate system adjustments, you calculate a proper-fitting rectangle for the page. As Chapter 2 discusses, fitting rectangles retain aspect while centering context within a destination. This requires one last context adjustment, so the drawing starts at the top left of that fitting rectangle. Finally, you draw. The CGContextDrawPDFPage() function renders page contents into the active context.
 
 The DrawPDFPageInRect() function is meant only for drawing to UIKit images destinations. It cannot be used when drawing PDF pages into PDF contexts. It depends on retrieving a UIImage from the context in order to perform its geometric adjustments. To adapt this listing for more general use, you need to supply both a context parameter (rather than retrieve one from UIKit) and a context size, for the vertical transformation.
 */

@implementation RenderingAPdf

- (void)drawRect:(CGRect)rect {
    // Opening a PDF Document
    NSString *pdfPath = [[NSBundle mainBundle]
                         pathForResource:@"NodeCraftsman" ofType:@"pdf"];
    /*CGPDFDocumentRef pdfRef = CGPDFDocumentCreateWithURL((__bridge CFURLRef)[NSURL fileURLWithPath:pdfPath]);
     if (pdfRef == NULL)
     {
     NSLog(@"Error loading PDF");
     return;
     }
     // ... use PDF document here
     void DrawPDFPageInRect(CGPDFPageRef, CGRect);
     
     CGPDFPageRef pageRef = CGPDFDocumentGetPage(pdfRef, 1);
     
     DrawPDFPageInRect(pageRef, rect);
     
     
     CGPDFDocumentRelease(pdfRef);*/
    
    [XFCrystal drawPDFPageWithFilePath:pdfPath pageNumber:1 toTargetRect:rect];
}
@end
