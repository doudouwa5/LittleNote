//
//  MyNavigationController.m
//  My_Bug
//
//  Created by 韩豆豆 on 16/9/13.
//  Copyright © 2016年 HD2. All rights reserved.
//

#import "MyNavigationController.h"
#import <QuartzCore/CALayer.h>

@interface MyNavigationController ()<UIGestureRecognizerDelegate>

@property(strong,nonatomic) UIView *backgrangView;
@property(strong,nonatomic) UIView *showview;
@end

@implementation MyNavigationController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    _backgrangView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, MB_DEVICE_WIDTH, MB_DEVICE_HEIGHT)];
    _backgrangView.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:250.0/255.0 blue:240.0/255.0 alpha:1];
    [self.view addSubview:_backgrangView];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    _headView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, MB_DEVICE_WIDTH, 64)];
    _headView.backgroundColor=[UIColor yellowColor];
    [_backgrangView addSubview:_headView];
    
    
    self.title=@"欢迎";
    
}
  
-(void) addToast:(NSString *) test{
    if(_showview!=nil){
       [_showview removeFromSuperview];
    }
    CGSize size =[test sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
    NSLog(@"%f",size.width);
    UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,size.width+10,30)];
    hintLabel.textAlignment = NSTextAlignmentCenter;
    hintLabel.alpha = 1.0;
    hintLabel.backgroundColor=[UIColor grayColor];
    hintLabel.layer.cornerRadius = 5;
    hintLabel.clipsToBounds = YES;
    hintLabel.text = test;
    [hintLabel setTextColor:[UIColor whiteColor]];


    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    _showview =  [[UIView alloc]init];
    _showview.frame = CGRectMake((MB_DEVICE_WIDTH-size.width-10)/2,MB_DEVICE_HEIGHT/2,size.width+10,30);
    _showview.layer.cornerRadius = 5.0f;
    _showview.layer.masksToBounds = YES;
    [_showview addSubview:hintLabel];
    [window addSubview:_showview];

    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(removeShow) userInfo:nil repeats:NO];

}
-(void) removeShow{
    [_showview removeFromSuperview];

}


@end




