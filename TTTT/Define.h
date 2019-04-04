//
//  Define.h
//  My_Bug
//
//  Created by 韩豆豆 on 16/9/13.
//  Copyright © 2016年 HD2. All rights reserved.
//

#ifndef Define_h
#define Define_h


//ARC判断代码，好处是有些第三方库不使用ARC
#if __has_feature(objc_arc)
#define MB_AUTORELEASE(exp) exp
#define MB_RELEASE(exp) exp
#define MB_RETAIN(exp) exp
#define MB_NIL(exp) exp
#else
#define MB_AUTORELEASE(exp) [exp autorelease]
#define MB_RELEASE(exp) [exp release]
#define MB_RETAIN(exp) [exp retain]
#define MB_NIL(exp) exp = nil
#endif

//项目Delegate上下文
#define SHAREAPP ((AppDelegate *)[[UIApplication sharedApplication] delegate])

//识别符
#define CLIENT_TYPE (@"iphone")

//背景色
//文本框输入文字颜色
#define INPUT_TEXT_COLOR [UIColor colorWithRed:255.0/255.0 green:250.0/255.0 blue:240.0/255.0 alpha:1]

//字体规范
#define T1_TEXT_FONT [UIFont systemFontOfSize:11]
#define T2_TEXT_FONT [UIFont systemFontOfSize:12]
#define T3_TEXT_FONT [UIFont systemFontOfSize:13]
#define T4_TEXT_FONT [UIFont systemFontOfSize:14]
#define T5_TEXT_FONT [UIFont systemFontOfSize:15]
#define T6_TEXT_FONT [UIFont systemFontOfSize:16]
#define T7_TEXT_FONT [UIFont systemFontOfSize:17]
#define T8_TEXT_FONT [UIFont systemFontOfSize:25]
#define T9_TEXT_FONT [UIFont systemFontOfSize:28]
#define T10_TEXT_FONT [UIFont systemFontOfSize:21]

#define T18_TEXT_FONT [UIFont systemFontOfSize:18]
#define T19_TEXT_FONT [UIFont systemFontOfSize:19]
#define T20_TEXT_FONT [UIFont systemFontOfSize:20]



//设备自适应VIEW高度
#define MB_DEVICE_VIEW_HEIGHT [[UIScreen mainScreen] bounds].size.height - 20 - 44

#define MB_DEVICE_HEIGHT [[UIScreen mainScreen] bounds].size.height

//设备的屏宽
#define MB_DEVICE_WIDTH     [[UIScreen mainScreen] bounds].size.width
//设备自适应Frame
#define MB_DEVICE_FULLSCREEN CGRectMake(0, 0, 320, MB_DEVICE_HEIGHT)

#define MB_IMAGELOADER(exp) [UIImage imageNamed:exp]

#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

//导航栏背景图
#define MB_NAVIGATION_BACK_IMAGE [UIImage imageNamed:@"navigationBackground"]


//新的背景色
#define NewDefaultColor [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]
//文本框输入文字颜色
#define INPUT_TEXT_COLOR [UIColor colorWithRed:98.0/255.0 green:98.0/255.0 blue:98.0/255.0 alpha:1]
//文本框标题文字颜色
#define TITLE_TEXT_COLOR [UIColor colorWithRed:175.0/255.0 green:175.0/255.0 blue:175.0/255.0 alpha:1]
//文本框里默认提示文字颜色
#define TEXT_HOLDER_COLOR [UIColor colorWithRed:202.0/255.0 green:216.0/255.0 blue:221.0/255.0 alpha:1]
//分割线条颜色
#define LINE_COLOR [UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1]


#endif /* Define_h */
