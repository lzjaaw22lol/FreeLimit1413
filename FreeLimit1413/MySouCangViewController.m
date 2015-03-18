//
//  MySouCangViewController.m
//  FreeLimit1413
//
//  Created by qf on 15-3-17.
//  Copyright (c) 2015年 qf. All rights reserved.
//

#import "MySouCangViewController.h"
#import "UIImageView+WebCache.h"
#import "ZJCreateDb.h"
#import "LimitDetail.h"
#define viewW [[UIScreen mainScreen] bounds].size.width
#define viewH [[UIScreen mainScreen] bounds].size.height
@interface MySouCangViewController ()
{
    NSArray *arr;
    int isreload;
    UIScrollView *scl;
}
@end

@implementation MySouCangViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"我的收藏";
    self.view.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSArray *tem = self.view.subviews;
    for(id addr in tem){
        [addr removeFromSuperview];
    }
    ZJCreateDb *zdb = [ZJCreateDb defaultManager];
    arr = [zdb selectAllMsg];
    scl = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewW, viewH-64-49)];
    scl.contentSize = CGSizeMake(viewW, arr.count/3*105+120);
    [self.view addSubview:scl];
    NSLog(@"ad:%d",arr.count);
    for(int i=0;i<arr.count;i++){
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(peizhiAction:)];
        
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(35+85*(i%3), 35+105*(i/3), 80, 80)];
        UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        [pic setImageWithURL:[NSURL URLWithString:[arr[i] objectForKey:@"iconUrl"]]];
        [bg addSubview:pic];
        UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(0, 62, 60, 18)];
        la.textColor = [UIColor blackColor];
        la.font = [UIFont systemFontOfSize:12];
        la.text = [arr[i] objectForKey:@"name"];
        [bg addSubview:la];
        pic.layer.cornerRadius = 5;
        pic.clipsToBounds = YES;
        bg.tag = i+10;
        [bg addGestureRecognizer:tap];
        [scl addSubview:bg];
    }
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:self.navigationItem.title style:UIBarButtonItemStyleDone target:self action:@selector(backButtonClick)];
    [backItem setBackgroundImage:[UIImage imageNamed:@"buttonbar_back.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.navigationItem.backBarButtonItem = backItem;

}
-(void)backButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)peizhiAction:(UITapGestureRecognizer *)b{
    NSDictionary *dict = arr[b.view.tag-10];
    LimitDetail *ld = [[LimitDetail alloc] init];
    ld.softId = [dict[@"applicationId"] intValue];
    [self.navigationController pushViewController:ld animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
