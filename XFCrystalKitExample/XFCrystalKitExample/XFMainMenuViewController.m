//
//  ViewController.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/18.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "XFMainMenuViewController.h"
#import "XFSettings.h"
#import "UIViewController+XFSettings.h"
#import "XFFuncMenuViewController.h"
#import "UsingCGUectDivide.h"
#import "RectangleUtilities.h"
#import "FitDrawing.h"
#import "FillDrawing.h"
#import "CreateACustomImage.h"
#import "BuildingAThumbnailImage.h"
#import "ExtractingPortionsOfImages.h"
#import "ConvertingAnImageToGrayscale.h"
#import "WatermarkingImages.h"
#import "BuildingStretchableImages.h"
#import "BuildingAPatternImage.h"
#import "RenderingAPdf.h"
#import "BuildingABezierPath.h"
#import "FillingPathWithEvent_OddRule.h"
#import "TransformingPaths.h"
#import "FittingBezierPaths.h"
#import "CreatingBezierPathsFromStrings.h"
#import "BuildingAPolygonPath.h"
#import "InflectedShapes.h"
#import "StarShapes.h"
#import "PathGetLenAndGetOnePoint.h"
#import "DrawAroundPath.h"
#import "RetrievingSubpaths.h"
#import "InvertingPaths.h"
#import "DrawingShadows.h"
#import "DrawingInnerShadow.h"
#import "EmbossingAShape.h"
#import "BevelEffectShape.h"
#import "Glows.h"
#import "linearGradient.h"
#import "TracingAPathProgression.h"
#import "WaitDotLoading.h"
#import "RadialGradient.h"
#import "BuildingGradients.h"
#import "EasingGradient.h"
#import "AddingEdgeEffects.h"
#import "StateAndTransparencyLayers.h"
#import "ReversingGradientOval.h"
#import "MixingLinearRadialGradient.h"
#import "GradientsOnPathEdges.h"
#import "Drawing3DLetters.h"
#import "BuildingIndentedGraphics.h"
#import "CombiningGradientsAndTexture.h"
#import "AddingNoiseTexture.h"
#import "GradientBasedGloss.h"
#import "ClippedGloss.h"
#import "AddingBottomGlow.h"
#import "DrawingTopShine.h"
#import "SimpleMasking.h"
#import "ComplexMasking.h"
#import "GaussianBlurring.h"
#import "BlurWithDrawingBlock.h"
#import "BlurredMasks.h"
#import "BlurredSpotlights.h"
#import "DrawingReflections.h"
#import "BuildingMarchingAnts.h"
#import "DrawingSampledData.h"
#import "DrawAudioRecording.h"
#import "ApplyingCoreImageTransitions.h"
#import "CreatingAttributedStrings.h"
#import "DrawingWithCoreText.h"
#import "DrawingColumns.h"
#import "ImageCutouts.h"
#import "DrawingAttributedTextAlongAPath.h"
#import "FontFitting.h"
#import "Seats.h"

@interface XFMainMenuViewController () <XFSettingTableViewDataSource>

@end

@implementation XFMainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"XFCrytalKit";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // set cell attrs
    XFCellAttrsData *cellAttrsData = [[XFCellAttrsData alloc] init];
    // 设置图标大小
    cellAttrsData.contentIconSize = 20;
    // 设置内容间距
    cellAttrsData.contentEachOtherPadding = 25;
    // 标题文字大小（其它文字会按个大小自动调整）
    cellAttrsData.contentTextMaxSize = 15;
    
    cellAttrsData.cellFullLineEnable = YES;
    cellAttrsData.cellBottomLineColor = [UIColor purpleColor];
    
    // 表格风格
    cellAttrsData.tableViewStyle = UITableViewStyleGrouped;
    
    self.xf_cellAttrsData = cellAttrsData;
    // 设置数据源
    self.xf_dataSource = self;
    // 调用配置设置
    [self xf_setup];
    
}

- (NSArray *)settingItems
{
    return @[
             @{
                 XFSettingGroupItems : @[
                         @{
                             XFSettingItemTitle: @"几何方法",
                             XFSettingItemClass: [XFSettingArrowItem class],
                             XFSettingItemDestViewControllerClass: [XFFuncMenuViewController class],
                             XFSettingItemDestViewControllerUserInfo: @{
                                     @"items": @[
                                             @{XFSettingItemTitle:@"使用CGRectDivide",@"ViewClass":[UsingCGUectDivide class]},
                                             @{XFSettingItemTitle:@"文字Rect居中绘制",@"ViewClass":[RectangleUtilities class]},
                                              @{XFSettingItemTitle:@"图像在Rect中Fit绘制",@"ViewClass":[FitDrawing class]},
                                             @{XFSettingItemTitle:@"图像在Rect中Fill绘制",@"ViewClass":[FillDrawing class]}
                                             ]},
                             },
                         @{
                             XFSettingItemTitle: @"图像处理",
                             XFSettingItemClass: [XFSettingArrowItem class],
                             XFSettingItemDestViewControllerClass: [XFFuncMenuViewController class],
                             XFSettingItemDestViewControllerUserInfo: @{
                                     @"items": @[
                                             @{XFSettingItemTitle:@"Drawing转图像绘制",@"ViewClass":[CreateACustomImage class]},
                                             @{XFSettingItemTitle:@"抽取图像Thumbnail绘制",@"ViewClass":[BuildingAThumbnailImage class]},
                                              @{XFSettingItemTitle:@"截取图像一小部分绘制",@"ViewClass":[ExtractingPortionsOfImages class]},
                                             @{XFSettingItemTitle:@"RGB图像转灰色图像",@"ViewClass":[ConvertingAnImageToGrayscale class]},
                                              @{XFSettingItemTitle:@"图像添加水印文本",@"ViewClass":[WatermarkingImages class]},
                                             @{XFSettingItemTitle:@"绘制可拉伸的图像",@"ViewClass":[BuildingStretchableImages class]},
                                             @{XFSettingItemTitle:@"创建模板图像平铺绘制",@"ViewClass":[BuildingAPatternImage class]},
                                             @{XFSettingItemTitle:@"绘制PDF中某一页",@"ViewClass":[RenderingAPdf class]},
                                             ]},
                             
                             },
                         @{
                             XFSettingItemTitle: @"路径解剖",
                             XFSettingItemClass: [XFSettingArrowItem class],
                             XFSettingItemDestViewControllerClass: [XFFuncMenuViewController class],
                             XFSettingItemDestViewControllerUserInfo: @{
                                     @"items": @[
                                             @{XFSettingItemTitle:@"UIBezierPath的使用",@"ViewClass":[BuildingABezierPath class]},
                                             @{XFSettingItemTitle:@"返转路径的填充规则",@"ViewClass":[FillingPathWithEvent_OddRule class]},
                                              @{XFSettingItemTitle:@"路径应用Transforming",@"ViewClass":[TransformingPaths class]},
                                             @{XFSettingItemTitle:@"路径在Rect中Fit方式",@"ViewClass":[FittingBezierPaths class]},
                                             @{XFSettingItemTitle:@"文本转路径定制绘制",@"ViewClass":[CreatingBezierPathsFromStrings class]},
                                             @{XFSettingItemTitle:@"多边形路径绘制",@"ViewClass":[BuildingAPolygonPath class]},
                                             @{XFSettingItemTitle:@"放射性路径绘制",@"ViewClass":[InflectedShapes class]},
                                              @{XFSettingItemTitle:@"星形放射性路径绘制",@"ViewClass":[StarShapes class]},
                                              @{XFSettingItemTitle:@"获得路径百分点位置",@"ViewClass":[PathGetLenAndGetOnePoint class]},
                                             @{XFSettingItemTitle:@"环绕路径绘制图形",@"ViewClass":[DrawAroundPath class]},
                                             @{XFSettingItemTitle:@"多路径组合与分解",@"ViewClass":[RetrievingSubpaths class]},
                                             @{XFSettingItemTitle:@"路径反转填充",@"ViewClass":[InvertingPaths class]},
                                             ]},
                             },
                         @{
                             XFSettingItemTitle: @"阴影高光",
                             XFSettingItemClass: [XFSettingArrowItem class],
                             XFSettingItemDestViewControllerClass: [XFFuncMenuViewController class],
                             XFSettingItemDestViewControllerUserInfo: @{
                                     @"items": @[
                                             @{XFSettingItemTitle:@"绘制外部阴影",@"ViewClass":[DrawingShadows class]},
                                             @{XFSettingItemTitle:@"绘制内部阴影",@"ViewClass":[DrawingInnerShadow class]},
                                             @{XFSettingItemTitle:@"上压印浮凸效果",@"ViewClass":[EmbossingAShape class]},
                                             @{XFSettingItemTitle:@"斜面光照效果",@"ViewClass":[BevelEffectShape class]},
                                             @{XFSettingItemTitle:@"背面光照效果",@"ViewClass":[Glows class]},
                                                ]},
                             },
                         @{
                             XFSettingItemTitle: @"渐变填充",
                             XFSettingItemClass: [XFSettingArrowItem class],
                             XFSettingItemDestViewControllerClass: [XFFuncMenuViewController class],
                             XFSettingItemDestViewControllerUserInfo: @{
                                     @"items": @[
                                             @{XFSettingItemTitle:@"线性渐变效果",@"ViewClass":[linearGradient class]},
                                              @{XFSettingItemTitle:@"辐射状渐变效果",@"ViewClass":[RadialGradient class]},
                                             @{XFSettingItemTitle:@"构建蒙层渐变效果",@"ViewClass":[BuildingGradients class]},
                                             @{XFSettingItemTitle:@"缓冲蒙层渐变效果",@"ViewClass":[EasingGradient class]},
                                             @{XFSettingItemTitle:@"球形光照效果",@"ViewClass":[AddingEdgeEffects class]},
                                             @{XFSettingItemTitle:@"图层与状态的使用",@"ViewClass":[StateAndTransparencyLayers class]},
                                             @{XFSettingItemTitle:@"渐变实现凹陷效果",@"ViewClass":[ReversingGradientOval class]},
                                             @{XFSettingItemTitle:@"混合渐变效果",@"ViewClass":[MixingLinearRadialGradient class]},
                                             @{XFSettingItemTitle:@"路径上渐变效果",@"ViewClass":[GradientsOnPathEdges class]},
                                             @{XFSettingItemTitle:@"3D文字效果",@"ViewClass":[Drawing3DLetters class]},
                                              @{XFSettingItemTitle:@"凹下路径效果",@"ViewClass":[BuildingIndentedGraphics class]},
                                             @{XFSettingItemTitle:@"图像渐变填充效果",@"ViewClass":[CombiningGradientsAndTexture class]},
                                              @{XFSettingItemTitle:@"材质燥点填充效果",@"ViewClass":[AddingNoiseTexture class]},
                                             @{XFSettingItemTitle:@"水晶按钮样式一",@"ViewClass":[GradientBasedGloss class]},
                                             @{XFSettingItemTitle:@"水晶按钮样式二",@"ViewClass":[ClippedGloss class]},
                                              @{XFSettingItemTitle:@"底光效果",@"ViewClass":[AddingBottomGlow class]},
                                             @{XFSettingItemTitle:@"顶部捏压效果",@"ViewClass":[DrawingTopShine class]},
                                             ]},
                             },
                         @{
                             XFSettingItemTitle: @"遮罩模糊",
                             XFSettingItemClass: [XFSettingArrowItem class],
                             XFSettingItemDestViewControllerClass: [XFFuncMenuViewController class],
                             XFSettingItemDestViewControllerUserInfo: @{
                                     @"items": @[
                                             @{XFSettingItemTitle:@"简单的遮罩",@"ViewClass":[SimpleMasking class]},
                                              @{XFSettingItemTitle:@"复杂的遮罩",@"ViewClass":[ComplexMasking class]},
                                              @{XFSettingItemTitle:@"图像高斯模糊",@"ViewClass":[GaussianBlurring class]},
                                              @{XFSettingItemTitle:@"绘制高斯模糊层",@"ViewClass":[BlurWithDrawingBlock class]},
                                             @{XFSettingItemTitle:@"图像模糊边缘效果",@"ViewClass":[BlurredMasks class]},
                                             @{XFSettingItemTitle:@"模糊灯光效果",@"ViewClass":[BlurredSpotlights class]},
                                             @{XFSettingItemTitle:@"图像倒影效果",@"ViewClass":[DrawingReflections class]},
                                             ]},
                             },
                         @{
                             XFSettingItemTitle: @"动画与手势",
                             XFSettingItemClass: [XFSettingArrowItem class],
                             XFSettingItemDestViewControllerClass: [XFFuncMenuViewController class],
                             XFSettingItemDestViewControllerUserInfo: @{
                                     @"items": @[
                                             @{XFSettingItemTitle:@"指针转动动画",@"ViewClass":[TracingAPathProgression class]},
                                             @{XFSettingItemTitle:@"等待打点转动动画",@"ViewClass":[WaitDotLoading class]},
                                             @{XFSettingItemTitle:@"区域选择框动画",@"ViewClass":[BuildingMarchingAnts class]},
                                             @{XFSettingItemTitle:@"绘制动态数据曲线",@"ViewClass":[DrawingSampledData class]},
                                             @{XFSettingItemTitle:@"绘制录音数据波",@"ViewClass":[DrawAudioRecording class]},
                                             // Core Image在模拟器上很慢，用真机打开会很快
                                            #if TARGET_IPHONE_SIMULATOR//模拟器
                                            #elif TARGET_OS_IPHONE//真机
                                                         @{XFSettingItemTitle:@"图像高光扫描动画",@"ViewClass":[ApplyingCoreImageTransitions class]},
                                            #endif
                                             @{XFSettingItemTitle:@"移动的座位",@"ViewClass":[Seats class]},
                                             ]},
                             },
                         @{
                             XFSettingItemTitle: @"文本与路径",
                             XFSettingItemClass: [XFSettingArrowItem class],
                             XFSettingItemDestViewControllerClass: [XFFuncMenuViewController class],
                             XFSettingItemDestViewControllerUserInfo: @{
                                     @"items": @[
                                             @{XFSettingItemTitle:@"绘制属性文本",@"ViewClass":[CreatingAttributedStrings class]},
                                              @{XFSettingItemTitle:@"绘制形状内文本",@"ViewClass":[DrawingWithCoreText class]},
                                              @{XFSettingItemTitle:@"绘制分页文本",@"ViewClass":[DrawingColumns class]},
                                              @{XFSettingItemTitle:@"图文混排效果",@"ViewClass":[ImageCutouts class]},
                                              @{XFSettingItemTitle:@"文本环绕路径效果",@"ViewClass":[DrawingAttributedTextAlongAPath class]},
                                              @{XFSettingItemTitle:@"文本字体自适应",@"ViewClass":[FontFitting class]},
                                             ]},
                             },
                         ]
                 }
             ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
