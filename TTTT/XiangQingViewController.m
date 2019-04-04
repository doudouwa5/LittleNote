//
//  XiangQingViewController.m
//  TTTT
//
//  Created by 韩豆豆 on 17/1/22.
//  Copyright © 2017年 HD2. All rights reserved.
//

#import "XiangQingViewController.h"

@interface XiangQingViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) UITextField *tit;
@property (nonatomic,strong) UITextView *text;
@property (nonatomic,strong) NSString *time;
@property (nonatomic,assign) int height;
@property (nonatomic,strong) UILabel *frame1;


@property (nonatomic,strong) UIBarButtonItem *releaseButtonItem1;
@property (nonatomic,strong) UIBarButtonItem *releaseButtonItem2;


@end

@implementation XiangQingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"日志详情";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    UIButton *releaseButton1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [releaseButton1 setTitle:@"编辑" forState:normal];
    [releaseButton1 addTarget:self action:@selector(edit) forControlEvents:UIControlEventTouchUpInside];
    releaseButton1.frame = CGRectMake(0, 0, 40.0f, 30.0f);
    _releaseButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:releaseButton1];
    self.navigationItem.rightBarButtonItem = _releaseButtonItem1;
    
    
    UIButton *releaseButton2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [releaseButton2 setTitle:@"完成" forState:normal];
    [releaseButton2 addTarget:self action:@selector(achieve) forControlEvents:UIControlEventTouchUpInside];
    releaseButton2.frame = CGRectMake(0, 0, 40.0f, 30.0f);
    _releaseButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:releaseButton2];
//    self.navigationItem.rightBarButtonItem = _releaseButtonItem2;
    
    
    [self add];
    // Do any additional setup after loading the view.
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
    
    UILabel *rightTime=[[UILabel alloc] initWithFrame:CGRectMake(MB_DEVICE_WIDTH-170, 104, 150, 30)];
    rightTime.text=_time1;
    rightTime.font=T3_TEXT_FONT;
    rightTime.textAlignment=NSTextAlignmentRight;
    [rightTime setTextColor:INPUT_TEXT_COLOR];
    [self.view addSubview:rightTime];
    
    
    _tit=[[UITextField alloc] initWithFrame:CGRectMake(55, 64+10, MB_DEVICE_WIDTH-90, 30)];
    _tit.font=T4_TEXT_FONT;
    _tit.text=_tit1;
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
    _text.text=_text1;
    _text.backgroundColor=[UIColor clearColor];
    [self.view addSubview: _text];
    
    if(!_isCanChange){
        _tit.enabled=NO;
        _text.editable=NO;
    }
    if(_isCanChange){
        [_tit becomeFirstResponder];
        self.navigationItem.rightBarButtonItem = _releaseButtonItem2;
    }
}

-(void) edit{
    
    _tit.enabled=YES;
    _text.editable=YES;
    [_tit becomeFirstResponder];
    self.navigationItem.rightBarButtonItem = _releaseButtonItem2;

}

-(void) achieve{

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
    
    [array removeObjectAtIndex:_index];
    
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:_tit.text,@"tittle",_text.text,@"longStr",_time1,@"time", nil] ;
    NSDictionary *Dic=[NSDictionary dictionaryWithObjectsAndKeys:dic,@"Dic", nil];
    [array insertObject:Dic atIndex:_index];
    
    [array writeToFile:filepath atomically:YES];
    
    NSLog(@"%@",array);
    
    [UIView animateWithDuration:0.5 animations:^{

        [self.view endEditing:YES];
        _text.frame=CGRectMake(10, 64+10+35+30, MB_DEVICE_WIDTH-20, MB_DEVICE_VIEW_HEIGHT-10-30-30-20);
        _frame1.frame=CGRectMake(10, 64+10+35+30, MB_DEVICE_WIDTH-20, MB_DEVICE_VIEW_HEIGHT-10-30-30-20);
    }];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.8f target:self selector:@selector(pop) userInfo:nil repeats:NO];
    
}
-(void) pop{
    [self addToast:@"修改成功"];
    [self.navigationController popViewControllerAnimated:YES];
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
    
    //手势
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

@end
