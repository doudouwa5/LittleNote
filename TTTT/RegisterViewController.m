//
//  RegisterViewController.m
//  TTTT
//
//  Created by 韩豆豆 on 17/1/19.
//  Copyright © 2017年 HD2. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate>

@property(nonatomic,strong) UIScrollView *mainScr;

@property(nonatomic,strong) UITextField *name;
@property(nonatomic,strong) UITextField *mima1;
@property(nonatomic,strong) UITextField *phone;
@property(nonatomic,strong) UITextField *mima2;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"注册";
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    _mainScr=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, MB_DEVICE_WIDTH, MB_DEVICE_VIEW_HEIGHT)];
    [self.view addSubview:_mainScr];
    
    [self setLaber];
    
}

-(void) setLaber{
    NSArray *arr1=@[@"用户名",@"密码",@"确认密码",@"手机号"];
    NSArray *arr2=@[@"请输入用户名",@"请输入密码",@"请再次密码",@"请输入您的手机号"];
    for(int i=0;i<4;i++){
        UILabel *la=[[UILabel alloc]initWithFrame:CGRectMake(30, i*40+10, 100, 40)];
        la.text=arr1[i];
        [_mainScr addSubview:la];
        
        UILabel *l=[[UILabel alloc] initWithFrame:CGRectMake(100, 12.5+i*40, MB_DEVICE_WIDTH-140, 35)];
        l.layer.borderColor= LINE_COLOR.CGColor;
        l.layer.cornerRadius =5.0;
        l.layer.borderWidth= 1.0f;
        [_mainScr addSubview: l];
    }
    _name=[[UITextField alloc] initWithFrame:CGRectMake(110, 10,  MB_DEVICE_WIDTH-160, 40)];
    _name.returnKeyType=UIReturnKeyDone;
    _name.placeholder = arr2[0];
    [_name setTextColor:[UIColor grayColor]];
    _name.delegate=self;
    [_mainScr addSubview:_name];
    
    _mima1=[[UITextField alloc] initWithFrame:CGRectMake(110, 10+40,  MB_DEVICE_WIDTH-160, 40)];
    _mima1.returnKeyType=UIReturnKeyDone;
    _mima1.placeholder = arr2[1];
    _mima1.secureTextEntry = YES;
    [_mima1 setTextColor:[UIColor grayColor]];
    _mima1.delegate=self;
    [_mainScr addSubview:_mima1];
    
    _mima2=[[UITextField alloc] initWithFrame:CGRectMake(110, 10+80,  MB_DEVICE_WIDTH-160, 40)];
    _mima2.returnKeyType=UIReturnKeyDone;
    _mima2.placeholder = arr2[2];
    _mima2.secureTextEntry = YES;
    [_mima2 setTextColor:[UIColor grayColor]];
    _mima2.delegate=self;
    [_mainScr addSubview:_mima2];
    
    _phone=[[UITextField alloc] initWithFrame:CGRectMake(110, 10+120,  MB_DEVICE_WIDTH-160, 40)];
    _phone.keyboardType = UIKeyboardTypeNumberPad;
    _phone.returnKeyType=UIReturnKeyDone;
    _phone.placeholder = arr2[3];
    [_phone setTextColor:[UIColor grayColor]];
    _phone.delegate=self;
    [_mainScr addSubview:_phone];
    
    
    UIButton *log=[[UIButton alloc] initWithFrame:CGRectMake(40, 10+180, MB_DEVICE_WIDTH-80, 40)];
    log.backgroundColor=[UIColor colorWithRed:65.0/255.0 green:105.0/255.0 blue:225.0/255.0 alpha:1.0];
    log.layer.cornerRadius =5.0;
    [log addTarget:self action:@selector(Zhucetar) forControlEvents:UIControlEventTouchUpInside];
    [log setTitle:@"注   册" forState:UIControlStateNormal];
    [_mainScr addSubview:log];
}

-(void) Zhucetar{
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view endEditing:YES];
    }];
    if([_name.text isEqualToString:@""]){
        [self addToast:@"请输入用户名"];
        return;
    }
    if([_mima1.text isEqualToString:@""]){
        [self addToast:@"请输入密码"];
        return;
    }
    if([_mima2.text isEqualToString:@""]){
        [self addToast:@"请再次输入用密码"];
        return;
    }
    if([_phone.text isEqualToString:@""] ||[_phone.text length]!=11 ||![[_phone.text substringToIndex:1] isEqualToString:@"1"]){
        [self addToast:@"请输入正确的手机号"];
        return;
    }
    if(![_mima2.text isEqualToString:_mima1.text]){
        [self addToast:@"两次密码不一致，请重新输入"];
        _mima1.text=@"";
        _mima2.text=@"";
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(Zhucetar1) userInfo:nil repeats:NO];
    
}
-(void) Zhucetar1{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSArray * patharray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path =  [patharray objectAtIndex:0];
    NSString * filepath= [path stringByAppendingPathComponent:@"nameList.plist"];
    NSArray * arr = [[NSArray arrayWithContentsOfFile:filepath] mutableCopy] ;
    NSMutableArray * array = [[NSMutableArray alloc]initWithArray:arr];
    
    for(int i=0;i<array.count;i++){
        NSString *str=[[array[i] objectForKey:@"Name"] objectForKey:@"name"];
        if([str isEqualToString:_name.text]){
            [self addToast:@"该用户已存在，请重新输入"];
            _name.text=@"";
            return;
        }
    }
    
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:_name.text,@"name",_phone.text,@"phone", _mima1.text, @"mima", nil] ;
    NSDictionary *D=[NSDictionary dictionaryWithObjectsAndKeys:dic, @"Name",nil];
    
    [array addObject:D];
    NSLog(@"%@",array);
    [self addToast:@"注册成功"];
    [array writeToFile:filepath atomically:YES];
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark-  keyboard
- (void)keyboardWillShow:(NSNotification *)aNotification{

}

//退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    
   
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

@end
