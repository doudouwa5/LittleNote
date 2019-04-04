//
//  tableViewController.h
//  TTTT
//
//  Created by 韩豆豆 on 17/1/20.
//  Copyright © 2017年 HD2. All rights reserved.
//

#import "MyNavigationController.h"

@protocol ZhuCeDelegate <NSObject>

-(void) zhuce;

@end

@interface tableViewController : MyNavigationController

@property (nonatomic,copy) NSString *name;
@property (nonatomic,weak) id<ZhuCeDelegate> delegate;


@end
