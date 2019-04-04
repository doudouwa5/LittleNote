//
//  MyNavigationController.h
//  My_Bug
//
//  Created by 韩豆豆 on 16/9/13.
//  Copyright © 2016年 HD2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "Define.h"
@protocol MyNavigationDelegate <NSObject>

@optional
- (void)navigationWithNavigation:(id)navi withViewController:(UIViewController *)vc withLeftButton:(UIButton *)btn;

@end

@interface MyNavigationController : UIViewController

@property (nonatomic,strong) UIView *headView;


-(void) addToast:(NSString *) test;
@end
