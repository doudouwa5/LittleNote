//
//  tableViewController.m
//  TTTT
//
//  Created by 韩豆豆 on 17/1/20.
//  Copyright © 2017年 HD2. All rights reserved.
//

#import "tableViewController.h"
#import "addViewController.h"
#import "XiangQingViewController.h"


@interface tableViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSMutableArray *AllArr;

@end

@implementation tableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的日志";
    
//    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
//    backItem.title=@"注销";
//    self.navigationItem.leftBarButtonItem = backItem;
    
    self.navigationItem.leftBarButtonItem = [self backButton];

    
    //拿当前用户的数据
    NSArray * patharray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path =  [patharray objectAtIndex:0];
    NSString * filepath= [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",_name]];
    NSArray * arr = [[NSArray arrayWithContentsOfFile:filepath] mutableCopy] ;
    _AllArr = [[NSMutableArray alloc]initWithArray:arr];
    
    
    _table=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, MB_DEVICE_WIDTH, MB_DEVICE_VIEW_HEIGHT)];
    _table.delegate=self;
    _table.dataSource=self;
    
    UIView * newFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, MB_DEVICE_WIDTH, 1)];
    _table.tableFooterView = newFooterView;
    [self.view addSubview:_table];
    
    UIButton *releaseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [releaseButton setTitle:@"添加" forState:normal];
    [releaseButton addTarget:self action:@selector(addThing) forControlEvents:UIControlEventTouchUpInside];
    releaseButton.frame = CGRectMake(0, 0, 40.0f, 30.0f);
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;
    
}
-(void)addThing{
    
    addViewController *vc=[[addViewController alloc]init];
    vc.name=_name;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _AllArr.count;
};

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier  =@"cell";
    
    UITableViewCell* cCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cCell == nil) {
        cCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }else{
        for(UIView *v in cCell.contentView.subviews){
            [v removeFromSuperview];
        }
    }
    UILabel *l1=[[UILabel alloc] initWithFrame:CGRectMake(20, 5, MB_DEVICE_WIDTH-40, 30)];
    l1.text=[[_AllArr[indexPath.row] objectForKey:@"Dic"] objectForKey:@"tittle"];
    [cCell.contentView addSubview:l1];
    
    UILabel *l2=[[UILabel alloc] initWithFrame:CGRectMake(20, 35, MB_DEVICE_WIDTH-40, 10)];
    l2.text=[[_AllArr[indexPath.row] objectForKey:@"Dic"] objectForKey:@"time"];
    l2.font=T3_TEXT_FONT;
    l2.textColor=[UIColor grayColor];
    [cCell.contentView addSubview:l2];
    
    UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake(MB_DEVICE_WIDTH-30, (50-13)/2, 10, 13)];
    image.image=[UIImage imageNamed:@"rightdlark"];
    [cCell.contentView addSubview:image];
    if(indexPath.row==_AllArr.count-1){
        UIView *line=[[UIView alloc] initWithFrame:CGRectMake(15, 50, MB_DEVICE_WIDTH-15, 0.5)];
        line.backgroundColor=[UIColor colorWithRed:98.0/255.0 green:98.0/255.0 blue:98.0/255.0 alpha:0.4];
        [cCell.contentView addSubview:line];
    }
    
    return cCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XiangQingViewController *vc=[[XiangQingViewController alloc] init];
    vc.isCanChange=NO;
    vc.name=_name;
    vc.index=indexPath.row;
    vc.tit1=[[_AllArr[indexPath.row] objectForKey:@"Dic"] objectForKey:@"tittle"];
    vc.time1=[[_AllArr[indexPath.row] objectForKey:@"Dic"] objectForKey:@"time"];
    vc.text1=[[_AllArr[indexPath.row] objectForKey:@"Dic"] objectForKey:@"longStr"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    editingStyle = UITableViewCellEditingStyleDelete;//此处的EditingStyle可等于任意UITableViewCellEditingStyle，该行代码只在iOS8.0以前版本有作用，也可以不实现。
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteRoWAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {//title可自已定义
        
        [_AllArr removeObjectAtIndex:indexPath.row];
        NSArray * patharray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * path =  [patharray objectAtIndex:0];
        NSString * filepath= [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",_name]];
        [_AllArr writeToFile:filepath atomically:YES];
        [_table reloadData];
        
    }];//此处是iOS8.0以后苹果最新推出的api，UITableViewRowAction，Style是划出的标签颜色等状态的定义，这里也可自行定义
    UITableViewRowAction *editRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"点击编辑");
        
        XiangQingViewController *vc=[[XiangQingViewController alloc] init];
        vc.isCanChange=YES;
        vc.name=_name;
        vc.index=indexPath.row;
        vc.tit1=[[_AllArr[indexPath.row] objectForKey:@"Dic"] objectForKey:@"tittle"];
        vc.time1=[[_AllArr[indexPath.row] objectForKey:@"Dic"] objectForKey:@"time"];
        vc.text1=[[_AllArr[indexPath.row] objectForKey:@"Dic"] objectForKey:@"longStr"];
        [self.navigationController pushViewController:vc animated:YES];


    }];
    editRowAction.backgroundColor = [UIColor colorWithRed:0 green:124/255.0 blue:223/255.0 alpha:1];//可以定义RowAction的颜色
    return @[deleteRoWAction, editRowAction];//最后返回这俩个RowAction 的数组
}




- (void)viewWillAppear:(BOOL)animated{
    [self viewDidLoad];
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
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
- (UIBarButtonItem *)backButton
{
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [button setTitle:@"注销" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    [button setTitleColor:[UIColor colorWithRed:30.0/255.0 green:144.0/255.0 blue:255.0/255.0 alpha:1]forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    return item;
}
-(void)backButtonPressed{
    NSLog(@"注销");
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(zhuxiao) userInfo:nil repeats:NO];
}
-(void) zhuxiao{
    [self addToast:@"注销成功"];
    
    NSArray * patharray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path =  [patharray objectAtIndex:0];
    NSString * filepath= [path stringByAppendingPathComponent:[NSString stringWithFormat:@"isJiZhuDengLu.plist"]];
    NSArray * arr = [[NSArray arrayWithContentsOfFile:filepath] mutableCopy] ;
    NSMutableArray * array = [[NSMutableArray alloc]initWithArray:arr];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"0" ,@"is1",@"0",@"is2",[[array[0] objectForKey:@"is"] objectForKey:@"name"],@"name",[[array[0] objectForKey:@"is"] objectForKey:@"mima"],@"mima", nil];
    NSDictionary *Dic=[NSDictionary dictionaryWithObjectsAndKeys:dic,@"is", nil];
    [array removeAllObjects];
    [array addObject:Dic];
    [array writeToFile:filepath atomically:YES];
    NSLog(@"%@",array);

    
    [_delegate zhuce];
    [self.navigationController popViewControllerAnimated:YES];
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
