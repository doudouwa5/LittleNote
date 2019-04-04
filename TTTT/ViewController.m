//
//  ViewController.m
//  TTT
//
//  Created by 韩豆豆 on 17/1/19.
//  Copyright © 2017年 HD2. All rights reserved.
//

#import "ViewController.h"
#import "RegisterViewController.h"
#import "tableViewController.h"

@interface ViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) UIScrollView *logBack;
@property (nonatomic,strong) UITextField *zhanghaoField;
@property (nonatomic,strong) UITextField *mimaField;

@property (nonatomic,strong) UIImageView *isRemer;
@property (nonatomic,strong) UIImageView *isAuto;
@property (nonatomic,assign) BOOL is1;
@property (nonatomic,assign) BOOL is2;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    _is1=NO;
    _is2=NO;
    NSArray * patharray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path =  [patharray objectAtIndex:0];
    NSString * filepath= [path stringByAppendingPathComponent:[NSString stringWithFormat:@"isJiZhuDengLu.plist"]];
    NSArray * arr = [[NSArray arrayWithContentsOfFile:filepath] mutableCopy] ;
    NSMutableArray * array = [[NSMutableArray alloc]initWithArray:arr];
    if(array.count!=0){
        if([[[array[0] objectForKey:@"is"] objectForKey:@"is1"] isEqualToString:@"0"]){
            _is1=NO;
        }else{
            _is1=YES;
        }
    
        if([[[array[0] objectForKey:@"is"] objectForKey:@"is2"] isEqualToString:@"0"]){
            _is2=NO;
        }else{
            _is2=YES;
        }
    }
    
    [self setLog];
    if(array.count!=0){
        _zhanghaoField.text=[[array[0] objectForKey:@"is"] objectForKey:@"name"];
    }
    if(!_is1){
        _isRemer.image=[UIImage imageNamed:@"fg_unselected"];
        _mimaField.text=@"";
    }else{
        _isRemer.image=[UIImage imageNamed:@"fg_selted"];
        if(array.count!=0){
            _mimaField.text=[[array[0] objectForKey:@"is"] objectForKey:@"mima"];
        }
    }
    if(!_is2){
        _isAuto.image=[UIImage imageNamed:@"fg_unselected"];
    }else{
        _isAuto.image=[UIImage imageNamed:@"fg_selted"];
        [self DengLuTar];
    }
    [self removeNotification];
}

#pragma mark 移除本地通知，在不需要此通知时记得移除
-(void)removeNotification{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

-(void) setLog{
    _logBack=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, MB_DEVICE_WIDTH, MB_DEVICE_VIEW_HEIGHT+64)];
    [self.view addSubview:_logBack];
    
    
    UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake(20, 30, MB_DEVICE_WIDTH-40, 200)];
    image.image=[UIImage imageNamed:@"fu"];
    [_logBack addSubview:image];
    
    UILabel *zhanghao=[[UILabel alloc] initWithFrame:CGRectMake(40, MB_DEVICE_HEIGHT-200-64-15, 100, 40)];
    zhanghao.text=@"用户名:";
    [_logBack addSubview:zhanghao];
    
    UILabel *mima=[[UILabel alloc] initWithFrame:CGRectMake(40, MB_DEVICE_HEIGHT-160-64-15, 100, 40)];
    mima.text=@"密    码:";
    [_logBack addSubview:mima];
    
    _zhanghaoField=[[UITextField alloc] initWithFrame:CGRectMake(110, MB_DEVICE_HEIGHT-197.5-64-15, MB_DEVICE_WIDTH-170, 35)];
    _zhanghaoField.returnKeyType=UIReturnKeyDone;
    _zhanghaoField.placeholder = @"请输入账户名";
    _zhanghaoField.delegate=self;
    [_zhanghaoField setTextColor:[UIColor grayColor]];
//    zhanghaoField.layer.borderColor= [UIColor redColor].CGColor;
//    zhanghaoField.layer.borderWidth= 1.0f;
//    zhanghaoField.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    [_logBack addSubview:_zhanghaoField];
    
    UILabel *frame1=[[UILabel alloc] initWithFrame:CGRectMake(100, MB_DEVICE_HEIGHT-197.5-64-15, MB_DEVICE_WIDTH-150, 35)];
    frame1.layer.borderColor= LINE_COLOR.CGColor;
    frame1.layer.cornerRadius =5.0;
    frame1.layer.borderWidth= 1.0f;
    [_logBack addSubview: frame1];
    
    _mimaField=[[UITextField alloc] initWithFrame:CGRectMake(110, MB_DEVICE_HEIGHT-197.5+40-64-15, MB_DEVICE_WIDTH-170, 35)];
    _mimaField.returnKeyType=UIReturnKeyDone;
    _mimaField.placeholder = @"请输入账密码";
    _mimaField.secureTextEntry = YES;
    [_mimaField setTextColor:[UIColor grayColor]];
    _mimaField.delegate=self;
    //    zhanghaoField.layer.borderColor= [UIColor redColor].CGColor;
    //    zhanghaoField.layer.borderWidth= 1.0f;
    //    zhanghaoField.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    [_logBack addSubview:_mimaField];
    
    UILabel *frame2=[[UILabel alloc] initWithFrame:CGRectMake(100, MB_DEVICE_HEIGHT-197.5+40-64-15, MB_DEVICE_WIDTH-150, 35)];
    frame2.layer.borderColor= LINE_COLOR.CGColor;
    frame2.layer.cornerRadius =5.0;
    frame2.layer.borderWidth= 1.0f;
    [_logBack addSubview: frame2];
    
    
    _isRemer=[[UIImageView alloc] initWithFrame:CGRectMake(45, MB_DEVICE_HEIGHT-197.5+40-64-15+35+7, 15, 15)];
//    _isRemer.image=[UIImage imageNamed:@"fg_unselected"];
    [_logBack addSubview:_isRemer];
    
    UILabel *isR=[[UILabel alloc] initWithFrame:CGRectMake(65, MB_DEVICE_HEIGHT-197.5+40-64-15+35+7, 80, 15)];
    isR.text=@"记住密码";
    isR.font=T3_TEXT_FONT;
    [isR setTextColor:INPUT_TEXT_COLOR];
    [_logBack addSubview:isR];

    
    _isAuto=[[UIImageView alloc] initWithFrame:CGRectMake(MB_DEVICE_WIDTH-122, MB_DEVICE_HEIGHT-197.5+40-64-15+35+7, 15, 15)];
//    _isAuto.image=[UIImage imageNamed:@"fg_unselected"];
    [_logBack addSubview:_isAuto];
    
    UILabel *isA=[[UILabel alloc] initWithFrame:CGRectMake(MB_DEVICE_WIDTH-102, MB_DEVICE_HEIGHT-197.5+40-64-15+35+7, 80, 15)];
    isA.text=@"自动登录";
    isA.font=T3_TEXT_FONT;
    [isA setTextColor:INPUT_TEXT_COLOR];
    [_logBack addSubview:isA];
    
    
    UIButton *isRe=[[UIButton alloc] initWithFrame:CGRectMake(45, MB_DEVICE_HEIGHT-197.5+40-64-15+35+7, 100, 15)];
    [isRe addTarget:self action:@selector(isReadTar) forControlEvents:UIControlEventTouchUpInside];
    [_logBack addSubview:isRe];
    
    UIButton *isAutobtn=[[UIButton alloc] initWithFrame:CGRectMake(MB_DEVICE_WIDTH-122, MB_DEVICE_HEIGHT-197.5+40-64-15+35+7, 100, 15)];
    [isAutobtn addTarget:self action:@selector(isAutoTar) forControlEvents:UIControlEventTouchUpInside];
    [_logBack addSubview:isAutobtn];
    
    
    UIButton *log=[[UIButton alloc] initWithFrame:CGRectMake(40, MB_DEVICE_HEIGHT-105-64, MB_DEVICE_WIDTH-80, 40)];
    log.backgroundColor=[UIColor colorWithRed:65.0/255.0 green:105.0/255.0 blue:225.0/255.0 alpha:1.0];
    log.layer.cornerRadius =5.0;
    [log setTitle:@"登   录" forState:UIControlStateNormal];
    [log addTarget:self action:@selector(DengLuTar) forControlEvents:UIControlEventTouchUpInside];
    [_logBack addSubview:log];
    
    UIButton *zhuce=[[UIButton alloc] initWithFrame:CGRectMake(MB_DEVICE_WIDTH-90, MB_DEVICE_HEIGHT-50-64, 50, 20)];
    zhuce.backgroundColor=[UIColor colorWithRed:65.0/255.0 green:105.0/255.0 blue:225.0/255.0 alpha:0.8];
    zhuce.layer.cornerRadius =2.0;
    zhuce.titleLabel.font    = [UIFont systemFontOfSize: 12];
    [zhuce setTitle:@"注册" forState:UIControlStateNormal];
    [zhuce addTarget:self action:@selector(Zhucetar) forControlEvents:UIControlEventTouchUpInside];
    [_logBack addSubview:zhuce];
    
    
    UILabel *tit=[[UILabel alloc] initWithFrame:CGRectMake(MB_DEVICE_WIDTH-280,MB_DEVICE_HEIGHT-50-64, 200, 20)];
    tit.text=@"如果您还没有账号请点击此处:";
    tit.font=T4_TEXT_FONT;
    [tit setTextColor:[UIColor colorWithRed:98.0/255.0 green:98.0/255.0 blue:98.0/255.0 alpha:0.8]];
    [_logBack addSubview:tit];
    
}
-(void) isReadTar{
    if(_is1){
        _isRemer.image=[UIImage imageNamed:@"fg_unselected"];
        _isAuto.image=[UIImage imageNamed:@"fg_unselected"];
        _is2=NO;
    }else{
        _isRemer.image=[UIImage imageNamed:@"fg_selted"];
    }
    _is1=!_is1;
}

-(void) isAutoTar{
    if(_is2){
        _isAuto.image=[UIImage imageNamed:@"fg_unselected"];
    }else{
        _isAuto.image=[UIImage imageNamed:@"fg_selted"];
        _isRemer.image=[UIImage imageNamed:@"fg_selted"];
        _is1=YES;
    }
    _is2=!_is2;
}

-(void)DengLuTar{
    

    [UIView animateWithDuration:0.5 animations:^{
        [self.view endEditing:YES];
    }];
    if([_zhanghaoField.text isEqualToString:@""]){
        [self addToast:@"请输入账号"];
        return;
    }
    if([_mimaField.text isEqualToString:@""]){
        [self addToast:@"请输入密码"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES withTit:@"正在登录"];
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(DengLuTar1) userInfo:nil repeats:NO];
}

-(void)DengLuTar1{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSArray * patharray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path =  [patharray objectAtIndex:0];
    NSString * filepath= [path stringByAppendingPathComponent:@"nameList.plist"];
    NSArray * arr = [[NSArray arrayWithContentsOfFile:filepath] mutableCopy] ;
    NSMutableArray * array = [[NSMutableArray alloc]initWithArray:arr];
    if(array.count==0){
        [self addToast:@"用户不存在，请重新输入"];
    }
    BOOL isHaveName=NO;
    for(int i=0;i<array.count;i++){
        NSString *name=[[array[i] objectForKey:@"Name"] objectForKey:@"name"];
        if([name isEqualToString:_zhanghaoField.text]){
            
            NSString *mima=[[array[i] objectForKey:@"Name"] objectForKey:@"mima"];
            if([mima isEqualToString:_mimaField.text]){
                //登录成功
                [self addToast:@"登录成功"];
                
                NSArray * patharray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString * path =  [patharray objectAtIndex:0];
                NSString * filepath= [path stringByAppendingPathComponent:[NSString stringWithFormat:@"isJiZhuDengLu.plist"]];
                NSArray * arr = [[NSArray arrayWithContentsOfFile:filepath] mutableCopy] ;
                NSMutableArray * array = [[NSMutableArray alloc]initWithArray:arr];
                [array removeAllObjects];
                NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",_is1 ? @"1":@"0"] ,@"is1",[NSString stringWithFormat:@"%@",_is2 ? @"1":@"0"],@"is2",_zhanghaoField.text,@"name",_mimaField.text,@"mima", nil] ;
                NSDictionary *Dic=[NSDictionary dictionaryWithObjectsAndKeys:dic,@"is", nil];
                [array addObject:Dic];
                [array writeToFile:filepath atomically:YES];
                NSLog(@"%@",array);
                
                
                isHaveName=YES;
                tableViewController *vc=[[tableViewController alloc] init];
                vc.name=name;
                vc.delegate=self;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [self addToast:@"密码错误"];
                return;
            }
            
        }
    }
    if(isHaveName==NO){
        [self addToast:@"用户不存在，请重新输入"];
    }
}


-(void)Zhucetar{
    NSLog(@"注册");
    _zhanghaoField.text=@"";
    _mimaField.text=@"";
    RegisterViewController *vc=[[RegisterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}






#pragma mark-textFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [UIView animateWithDuration:0.5 animations:^{
        _logBack.contentOffset=CGPointMake(0,240);

    }];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.5 animations:^{
        _logBack.contentOffset=CGPointMake(0,0);
        
    }];
    return YES;
}

#pragma mark-  keyboard
- (void)keyboardWillShow:(NSNotification *)aNotification{
}

//退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{

    [UIView animateWithDuration:0.5 animations:^{
        _logBack.contentOffset=CGPointMake(0,0);
        
    }];
}

-(void) zhuce{
    _mimaField.text=@"";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSString *)description{
    NSString * string = [NSString stringWithFormat:@"<Person:内存地址:%p name = %@ age = %ld>",self,@"name",@"age"];
    return string;
}


@end
