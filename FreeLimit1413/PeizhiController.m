//
//  PeizhiController.m
//  FreeLimit1413
//
//  Created by qf on 15-3-16.
//  Copyright (c) 2015年 qf. All rights reserved.
//

#import "PeizhiController.h"
#import "MySouCangViewController.h"
@interface PeizhiController ()

@end

@implementation PeizhiController

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
    self.navigationItem.title = @"我的配置";
    NSArray *btnname = [NSArray arrayWithObjects:@"我的设置",@"我的关注",@"我的账户",@"我的收藏",@"我的下载",@"我的评论",@"我的帮助",@"蚕豆应用", nil];
    NSArray *btnimage = [NSArray arrayWithObjects:@"account_setting.png",@"account_favorite.png",@"account_user.png",@"account_collect.png",@"account_download.png",@"account_comment.png",@"account_help.png",@"account_candou.png", nil];
    for(int i=0;i<btnname.count;i++){
        UIButton *p = [UIButton buttonWithType:UIButtonTypeCustom];
        p.tag = i+10;
        p.titleLabel.font = [UIFont systemFontOfSize:15];
        [p setTitle:btnname[i] forState:UIControlStateNormal];
        [p setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [p setTitleEdgeInsets:UIEdgeInsetsMake(80, -57, 0, 0)];
        [p setImage:[UIImage imageNamed:btnimage[i]] forState:UIControlStateNormal];
        p.frame = CGRectMake(35+85*(i%3), 35+105*(i/3), 60, 60);
        [p addTarget:self action:@selector(peizhiAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:p];
    }
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:self.navigationItem.title style:UIBarButtonItemStyleDone target:self action:@selector(backButtonClick)];
    [backItem setBackgroundImage:[UIImage imageNamed:@"buttonbar_back.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.navigationItem.backBarButtonItem = backItem;
}
-(void)backButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)peizhiAction:(UIButton *)b{
    if(b.tag-10 == 3){
        MySouCangViewController *svc = [[MySouCangViewController alloc] init];
        [self.navigationController pushViewController:svc animated:YES];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
