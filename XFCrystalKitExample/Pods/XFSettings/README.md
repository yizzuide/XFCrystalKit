![XFSettings logo](./ScreenShot/XFSettingLogo.png)

[![CocoaPods](https://img.shields.io/badge/cocoapods-v2.2.1-brightgreen.svg)](http://cocoadocs.org/docsets/XFSettings)
![Language](https://img.shields.io/badge/language-ObjC-orange.svg)
![License](https://img.shields.io/hexpm/l/plug.svg)
![Version](https://img.shields.io/badge/platform-ios7%2B-green.svg)

基于UITableView的界面定制，目标是更快更方便地构建设置界面，特点是易维护、可扩展性强。

![XFSettings usage1](./ScreenShot/usage.gif)

##安装
1、通过cocoapods
> pod 'XFSettings','2.2.1'

2、手动加入

把XFSettings整个目录拖入到工程

##更新记录
* 2016/7/14   V2.2.1  修复在第二级控制器旋转屏幕后，返回到设置界面无法正确适配问题
* 2016/7/13   V2.2.0  支持横竖屏自适配，开发者无需修改代码
* 2016/7/8    V2.1.0  重要！修复使用"UIViewController+XFSettings"分类方式引发其它基于TableView的控制器崩溃问题，请及时更新！
* 2016/7/4    V2.0.2  支持动态设置右边文字后自适应大小，优化布局计算，"UIViewController+XFSettings.h"分类方式需要手动导入
* 2016/7/1    V2.0.1  修复自定义线色未设置为空问题，支持设置TableViewStyle
* 2016/6/23   V2.0.0  使用非侵入式分类UIViewController+XFSettings方式构建设置界面
* 2015/6/28   V1.0.0  提交第一个版本，支持基本配置功能


##开发文档
###一、快速开始使用
1.导入主头文件`#import "XFSettings.h`和分类`#import "UIViewController+XFSettings.h"`

2.在`viewDidLoad`方法使用`self.xf_cellAttrsData`设置`XFCellAttrsData`类型参数

3.设置数据源`self.xf_dataSource`并调用`[self xf_setup]`进行配置

4.实现`XFSettingTableViewDataSource`协议的`- (NSArray *)settingItems`数据源方法返回`NSArray`以供库内部的渲染

```objc
//.m
#import "XFSettings.h"
#import "UIViewController+XFSettings.h"

@interface ViewController () <XFSettingTableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // set cell attrs
    XFCellAttrsData *cellAttrsData = [[XFCellAttrsData alloc] init];
    // 设置图标大小
    cellAttrsData.contentIconSize = 20;
    // 设置内容间距
    cellAttrsData.contentEachOtherPadding = 15;
    // 标题文字大小（其它文字会按个大小自动调整）
    cellAttrsData.contentTextMaxSize = 13;
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
    return @[ // groupArr
             @{ // groupModel
                 XFSettingGroupHeader: @"基本信息",
                 XFSettingGroupItems : @[ // items
                         @{ // itemModel
                             XFSettingItemTitle: @"我的朋友",
                             XFSettingItemIcon : @"1435582804_group",
                             // 这个字段用于判断是否有右边辅助功能的cell,不写则没有
                             XFSettingItemClass : [XFSettingInfoItem class], 
                             XFSettingItemAttrDetailText : @"你的好友",
                             // 自定义的cell
                             XFSettingItemRelatedCellClass:[XFSettingInfoDotCell class],
                             // 如果有目标控制器
                            XFSettingItemDestViewControllerClass : [XFNewFriendViewController class], 
                            // 目标控制器带有参数
                             XFSettingItemDestViewControllerUserInfo : @{@"url":@"http://www.yizzuide.com"},
                             // 如果有可选操作
                             XFSettingOptionActionBlock : ^(XFSettingInfoDotCell *cell,XFSettingPhaseType phaseType,id intentData){
                                // 如果被点击
                                 if (phaseType == XFSettingPhaseTypeCellInteracted) {
                                     cell.rightInfoLabel.hidden = YES;
                                 }
                             }
                             },// end itemModel
                         ],// end items
                 XFSettingGroupFooter : @"lalala~"
                 }// end groupModel
             ];// endgroupArr
}
@end
```

###二、框架文档
整体框架图如下：
![](./ScreenShot/framework.png)
####1. 框架集成的两种方式
1.1. 集成之继承`XFSettingTableViewController`（过时）  
注意：从2.0.0开始，这种方式就标为过时了，因为一个类只能继承一个类，不方便开发者自由使用  
使用方式：
- 导入主头文件`#import "XFSettings.h`
- 使目标控制器继承`XFSettingTableViewController`
- 在`viewDidLoad`方法里设置`XFCellAttrsData`参数
- 设置数据源`self.dataSource`
- 实现`XFSettingTableViewDataSource`协议的`- (NSArray *)settingItems`数据源方法返回`NSArray`以供库内部的渲染

1.2. 集成之分类`UIViewController+XFSettings`（推荐使用）  
注意：从2.0.0开始支持  
使用方式：见上面**快速开始使用**

####2. 数据源格式
使用`- (NSArray *)settingItems`返回数据源的格式如下，该方法不能返回`nil`。
```objc
- (NSArray *)settingItems
{
    return @[ // 对应UITableView的Section数组
            @{ // 每一个Section
                XFSettingGroupHeader: @"Section的Header",
                XFSettingGroupItems : @[ // 对应UITableView的cell数组
                    @{ // 每一个cell
                        // ...item的具体配置
                    }
                ],
                XFSettingGroupFooter : @"Section的Footer"
            }
    ];
}
```

####3.全局配置
使用`XFCellAttrsData`类全局配置设置界面：
```objc
// Cell Color
@property (nonatomic, strong) UIColor *cellBackgroundColor;
@property (nonatomic, strong) UIColor *cellSelectedBackgroundColor;
@property (nonatomic, strong) UIView *cellBackgroundView;
@property (nonatomic, strong) UIView *cellSelectedBackgroundView;
// cell下线颜色
@property (nonatomic, strong) UIColor *cellBottomLineColor;
// 只显示下方的画线
@property (nonatomic, assign) BOOL cellFullLineEnable;

// 标题颜色
@property (nonatomic, strong) UIColor *contentTitleTextColor;
// 详细文字颜色
@property (nonatomic, strong) UIColor *contentDetailTextColor;
// 右边辅助文字颜色
@property (nonatomic, strong) UIColor *contentInfoTextColor;
// 标题文字大小（其它文字会按个大小自动调整）
@property (nonatomic, assign) CGFloat contentTextMaxSize;
// 设置图标大小
@property (nonatomic, assign) CGFloat contentIconSize;
// 设置内容间距
@property (nonatomic, assign) CGFloat contentEachOtherPadding;
// 禁止显示第一条线
@property (nonatomic, assign) BOOL disableTopLine;
// 列表显示风格（注意：只适用于使用分类UIViewController+XFSettings.h方式）
@property (nonatomic, assign) UITableViewStyle tableViewStyle;
```

####4. 配置属性
每一个Cell的显示内容，都会根据以下配置字段：
```objc
// 组信息
/**
 *  分组头信息
 */
extern NSString * const XFSettingGroupHeader;
/**
 *  每一组的多个Cell
 */
extern NSString * const XFSettingGroupItems;
/**
 *  分组页脚信息
 */
extern NSString * const XFSettingGroupFooter;

// 每个Item的可用配置
/**
 *  Cell的模型类型
 */
extern NSString * const XFSettingItemClass;
/**
 *  Cell标题
 */
extern NSString * const XFSettingItemTitle;
/**
 *  Cell图标
 */
extern NSString * const XFSettingItemIcon;
/**
 *  cell arrow图标
 */
extern NSString * const XFSettingItemArrowIcon;
/**
 *  CellView的类型
 */
extern NSString * const XFSettingItemRelatedCellClass;
/**
 *  第二级跳转控制器Class
 */
extern NSString * const XFSettingItemDestViewControllerClass;
/**
 *  使用XFSettingArrowItem时，第二级跳转控制器传参数信息（新的控制器里添加XFSettingIntentUserInfo协议）
 */
extern NSString * const XFSettingItemDestViewControllerUserInfo;
/**
 *  Cell点击后的执行代码块
 */
extern NSString * const XFSettingOptionActionBlock;
/**
 * 使用XFSettingInfoItem和XFSettingInfoCell时的属性,详细信息
 */
extern NSString * const XFSettingItemAttrDetailText;
/**
 *  使用XFSettingInfoItem和XFSettingInfoCell时的属性,右边辅助信息
 */
extern NSString * const XFSettingItemAttrRightInfo;
/**
 *  使用XFSettingAssistImageItem和XfSettingAssistImageCell时的属性，右边辅助图
 */
extern NSString * const XFSettingItemAttrAssistImageName;
```

####4. Cell的可选操作
每个Cell有布局阶段和有交互事件，在布局阶段可以用代码修改一些信息，被点击时可执行相应操作  
可选操作定义如下：
```objc
typedef enum : NSUInteger {
    XFSettingPhaseTypeCellInit, // 布局阶段
    XFSettingPhaseTypeCellInteracted // 有交互事件
} XFSettingPhaseType;

// cell: 可转换到开发者自己通过XFSettingItemRelatedCellClass字段配置的Cell类型
// intentData: 为传回的变化数据，如：模型XFSettingSwitchItem类型的Cell,会在UISwitch改变时发出XFSettingPhaseTypeCellInteracted事件
typedef void(^SettingItemOptionBlock)(UITableViewCell *cell,XFSettingPhaseType phaseType,id intentData);
```

####5. 预定义模型类和Cell搭配
框架有定义一些预设的模型数据类（如：`XFSettingItem`）和Cell（如：`XFSettingCell`），用于搭配出不同的显示内容：
- 无交互事件的Cell: `XFSettingItem` + `XFSettingCell`
- 带UISwitch的Cell: `XFSettingSwitchItem` + `XFSettingCell`
- 带右边箭头图标的Cell: `XFSettingArrowItem` + `XFSettingCell`
- 带右边箭头、有右边消息文字/点的Cell: `XFSettingInfoItem` + `XFSettingInfoCell/XFSettingInfoCountCell/XFSettingInfoDotCell`
- 带右边箭头、有右边图片的Cell: `XFSettingAssistImageItem` + `XFSettingAssistImageCell`

####6. 组装显示各种类型的Cell
#####6.1. 普通显示无交互事件的Cell
可以不用配置`XFSettingItem`和`XFSettingCell`,因为默认就是这种类型，如：
```objc
    @{
        XFSettingItemTitle: @"标题",
        XFSettingItemIcon : @"img",
        }
```
#####6.2. 普通显示有交互事件的Cell
```objc
    @{
        XFSettingItemTitle: @"标题",
        XFSettingItemIcon : @"img",
        XFSettingOptionActionBlock : ^(XFSettingCell *cell,XFSettingPhaseType phaseType,id intentData){
                  if (phaseType == XFSettingPhaseTypeCellInteracted) {
                        // todo...
                    }               
            }
        }
```
#####6.3. 普通显示带右边箭头且有交互事件跳转控制器的Cell
有无右边的箭头不仅是设置`XFSettingItemClass`为`XFSettingArrowItem`,还要设置`XFSettingItemDestViewControllerClass`，不加后者将不会显示箭头
```objc
     @{
        XFSettingItemTitle: @"标题",
        XFSettingItemIcon : @"img",
        XFSettingItemClass: [XFSettingArrowItem class],
        XFSettingItemDestViewControllerClass:[ViewController class],
        }
```
#####6.4. 普通显示带自定义右边箭头图标无交互事件的Cell
在要显示右边箭头，又不能跳转控制器的情况下，设置` XFSettingItemDestViewControllerClass:[NSObject class]`
```objc
    @{
        XFSettingItemTitle: @"标题",
        XFSettingItemIcon : @"img",
        // 使用自定义向右箭头
        XFSettingItemArrowIcon : @"CellArrow",
        XFSettingItemClass: [XFSettingArrowItem class],
        // 当不使用控制器类时可以实现有箭头并且不会跳转
        XFSettingItemDestViewControllerClass:[NSObject class],
        }
```
#####6.5. 显示有详细信息文字的Cell
```objc
    @{
        XFSettingItemTitle: @"标题",
        XFSettingItemIcon : @"img",
        XFSettingItemAttrDetailText : @"左边的详细说明",
        XFSettingItemAttrRightInfo : @"右边的信息文字",
        XFSettingItemClass: [XFSettingInfoItem class],
        XFSettingItemRelatedCellClass:[XFSettingInfoCell class],
        }
```

#####6.6 显示右边带图图片的Cell
```objc
    @{
        XFSettingItemTitle: @"标题",
        XFSettingItemIcon : @"img",
        XFSettingItemAttrAssistImageName : @"assistImg",
        XFSettingItemClass: [XFSettingAssistImageItem class],
        XFSettingItemRelatedCellClass:[XFSettingAssistImageCell class],
        }
```
####7. 扩展模型子类和子Cell
开发者可以扩展自己Cell显示的内容，扩展形式可以参考`XFSettingAssistImageItem` 和 `XFSettingAssistImageCell`
#####7.1. 扩展模型数据类
自定义类继承`XFSettingArrowItem`，添加一些必要的`property`
#####7.2. 扩展Cell
1) 自定义Cell继承`XFSettingCell`  
2) 覆盖`- (void)setItem:(XFSettingItem *)item`方法，填充自己的数据到视图  
3）覆盖`- (void)layoutSubviews`方法，并调用`[super layoutSubviews]`父类实现，对子视图进行布局  
4) 覆盖`+ (NSString *)settingCellReuseIdentifierString`方法，为自定义的Cell打一个标签，用于循环利用  
















