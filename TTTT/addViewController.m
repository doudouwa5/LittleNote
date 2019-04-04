//
//  addViewController.m
//  TTTT
//
//  Created by 韩豆豆 on 17/1/20.
//  Copyright © 2017年 HD2. All rights reserved.
//

#import "addViewController.h"
#import "tableViewController.h"
@interface addViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) UITextField *tit;
@property (nonatomic,strong) UITextView *text;
@property (nonatomic,strong) NSString *time;


@property (nonatomic,assign) int height;

@property (nonatomic,strong) UILabel *frame1;


//推送
@property(nonatomic,copy) NSDate *fireDate;
@property(nonatomic,copy) NSTimeZone *timeZone; //时区

@property(nonatomic) NSCalendarUnit repeatInterval; //重复间隔(枚举)
@property(nonatomic,copy) NSCalendar *repeatCalendar; //重复日期(NSCalendar)

@property(nonatomic,copy) CLRegion *region; //设置区域(设置当进入某一个区域时,发出一个通知)

@property(nonatomic,assign) BOOL regionTriggersOnce; //YES //只会在第一次进入某一个区域时发出通知.NO,每次进入该区域都会发通知

@property(nonatomic,copy) NSString *alertBody;

@property(nonatomic) BOOL hasAction;                //是否隐藏锁屏界面设置的alertAction
@property(nonatomic,copy) NSString *alertAction;    //设置锁屏界面一个文字

@property(nonatomic,copy) NSString *alertLaunchImage;   //启动图片
@property(nonatomic,copy) NSString *alertTitle;

@property(nonatomic,copy) NSString *soundName;

@property(nonatomic) NSInteger applicationIconBadgeNumber;

@property(nonatomic,copy) NSDictionary *userInfo; // 设置通知的额外的数据


@end

@implementation addViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"添加日志";
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    

    
    UIButton *releaseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [releaseButton setTitle:@"完成" forState:normal];
    [releaseButton addTarget:self action:@selector(achievement) forControlEvents:UIControlEventTouchUpInside];
    releaseButton.frame = CGRectMake(0, 0, 40.0f, 30.0f);
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;
    
    [self add];
}

-(void) achievement{
    if([_tit.text isEqualToString:@""]){
        [self addToast:@"题目不能为空"];
        return;
    }
    if([_text.text isEqualToString:@""]){
        [self addToast:@"请输入内容"];
        return;
    }
    
    NSArray * patharray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path =  [patharray objectAtIndex:0];
    NSString * filepath= [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",_name]];
    NSArray * arr = [[NSArray arrayWithContentsOfFile:filepath] mutableCopy] ;
    NSMutableArray * array = [[NSMutableArray alloc]initWithArray:arr];

    NSDate *date1 = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY年MM月dd hh:mm:ss"];
    _time = [formatter stringFromDate:date1];

    
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:_tit.text,@"tittle",_text.text,@"longStr",_time,@"time", nil] ;
    NSDictionary *Dic=[NSDictionary dictionaryWithObjectsAndKeys:dic,@"Dic", nil];
    [array insertObject:Dic atIndex:0];
    
    [array writeToFile:filepath atomically:YES];
    
    NSLog(@"%@",array);
    [UIView animateWithDuration:0.5 animations:^{
        
        [self.view endEditing:YES];
        _text.frame=CGRectMake(10, 64+10+35+30, MB_DEVICE_WIDTH-20, MB_DEVICE_VIEW_HEIGHT-10-30-30-20);
        _frame1.frame=CGRectMake(10, 64+10+35+30, MB_DEVICE_WIDTH-20, MB_DEVICE_VIEW_HEIGHT-10-30-30-20);
    }];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.8f target:self selector:@selector(pop) userInfo:nil repeats:NO];
    
    //推
    [self addLocalNote];
}
-(void) pop{
    [self addToast:@"添加成功"];
    
    NSArray                   * vcArr             = self.navigationController.viewControllers;
    if (vcArr.count > 2) {
        tableViewController * comLowPowerVC = [vcArr objectAtIndex:1];
        // 返回到 业务办理、
        [self.navigationController popToViewController:comLowPowerVC animated:YES];
    }


}

-(void) add{
    
    UILabel *laberTit=[[UILabel alloc] initWithFrame:CGRectMake(10, 10+64, 100, 30)];
    laberTit.text=@"题目:";
    laberTit.font=T5_TEXT_FONT;
    [self.view addSubview:laberTit];
    
    UILabel *frame2=[[UILabel alloc] initWithFrame:CGRectMake(50, 64+10, MB_DEVICE_WIDTH-60, 30)];
    frame2.layer.borderColor= LINE_COLOR.CGColor;
    frame2.layer.cornerRadius =5.0;
    frame2.layer.borderWidth= 1.0f;
    [self.view addSubview: frame2];
    
    _tit=[[UITextField alloc] initWithFrame:CGRectMake(55, 64+10, MB_DEVICE_WIDTH-90, 30)];
    _tit.font=T4_TEXT_FONT;
    _tit.delegate=self;
    _tit.placeholder=@"10个字符以内";
    [self.view addSubview: _tit];
    
    UILabel *laberTit1=[[UILabel alloc] initWithFrame:CGRectMake(10, 10+64+35, 100, 30)];
    laberTit1.text=@"内容:";
    laberTit1.font=T5_TEXT_FONT;
    [self.view addSubview:laberTit1];
    
    _frame1=[[UILabel alloc] initWithFrame:CGRectMake(10, 64+10+35+30, MB_DEVICE_WIDTH-20, MB_DEVICE_VIEW_HEIGHT-10-30-30-20)];
    _frame1.layer.borderColor= LINE_COLOR.CGColor;
    _frame1.layer.cornerRadius =5.0;
    _frame1.layer.borderWidth= 1.0f;
    [self.view addSubview: _frame1];
    
    _text=[[UITextView alloc] initWithFrame:CGRectMake(10, 64+10+35+30, MB_DEVICE_WIDTH-20, MB_DEVICE_VIEW_HEIGHT-10-30-30-20)];
    _text.font=T4_TEXT_FONT;
    _text.backgroundColor=[UIColor clearColor];
    [self.view addSubview: _text];
    
    
}

#pragma mark-  keyboard
- (void)keyboardWillShow:(NSNotification *)aNotification{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    _height = keyboardRect.size.height;
    
    
    [UIView animateWithDuration:0.5 animations:^{
        _text.frame=CGRectMake(10, 64+10+35+30, MB_DEVICE_WIDTH-20, MB_DEVICE_VIEW_HEIGHT-10-30-30-20-_height);
        _frame1.frame=CGRectMake(10, 64+10+35+30, MB_DEVICE_WIDTH-20, MB_DEVICE_VIEW_HEIGHT-10-30-30-20-_height);
    }];
}

//退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    
    [UIView animateWithDuration:0.5 animations:^{
        _text.frame=CGRectMake(10, 64+10+35+30, MB_DEVICE_WIDTH-20, MB_DEVICE_VIEW_HEIGHT-10-30-30-20);
        _frame1.frame=CGRectMake(10, 64+10+35+30, MB_DEVICE_WIDTH-20, MB_DEVICE_VIEW_HEIGHT-10-30-30-20);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _tit) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 10) {
            return NO;
        }
    }
    
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void) addLocalNote{
    // 1.创建一个本地通知
    UILocalNotification *localNote = [[UILocalNotification alloc] init];
    
    // 2.设置本地通知的一些属性(通知发出的时间/通知的内容)
    // 2.1.设置通知发出的时间
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    // HH是24进制，hh是12进制
//    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    // formatter.locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease];
//    NSDate *date = [formatter dateFromString:@"2017-08-16 10:17:00"];
//    localNote.fireDate = date;

    localNote.fireDate = [NSDate dateWithTimeIntervalSinceNow:10.0];

    // 2.2.设置通知的内容
    localNote.alertBody = @"有新日志？快去看看吧";
    // 2.3.设置锁屏界面的文字
    localNote.alertAction = @"查看具体的消息";
    // 2.4.设置锁屏界面alertAction是否有效
    localNote.hasAction = YES;
    // 2.5.设置通过点击通知打开APP的时候的启动图片(无论字符串设置成什么内容,都是显示应用程序的启动图片)
    localNote.alertLaunchImage = @"111";
    // 2.6.设置通知中心通知的标题
    localNote.alertTitle = @"小小日志本增加新日志啦";
    // 2.7.设置音效
    localNote.soundName = @"buyao.wav";
    // 2.8.设置应用程序图标右上角的数字
    localNote.applicationIconBadgeNumber = 1;
    // 2.9.设置通知之后的属性
    localNote.userInfo = @{@"name" : @"张三", @"toName" : @"李四"};
    
    // 3.调度通知
    [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
    
}

@end
