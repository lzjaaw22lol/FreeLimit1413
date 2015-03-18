//
//  XMtabbar.m
//  FreeLimit1413
//
//  Created by qf on 15-3-16.
//  Copyright (c) 2015年 qf. All rights reserved.
//

#import "XMtabbar.h"
#import "LimitViewController.h"
#import "SaleViewController.h"
#import "FreeViewController.h"
#import "TopicViewController.h"
#import "HotViewController.h"
@interface XMtabbar ()

@end

@implementation XMtabbar

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
    LimitViewController *mpage = [[LimitViewController alloc] init];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:mpage];
    nav1.tabBarItem.title = @"限免";
    nav1.tabBarItem.image = [UIImage imageNamed:@"tabbar_limitfree.png"];
    [nav1.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar.png"] forBarMetrics:UIBarMetricsDefault];
    
    SaleViewController *orderpage = [[SaleViewController alloc] init];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:orderpage];
    nav2.tabBarItem.title = @"降价";
    nav2.tabBarItem.image = [UIImage imageNamed:@"tabbar_reduceprice.png"];
    [nav2.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar.png"] forBarMetrics:UIBarMetricsDefault];
    
    FreeViewController *userpage = [[FreeViewController alloc] init];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:userpage];
    nav3.tabBarItem.title = @"免费";
    nav3.tabBarItem.image = [UIImage imageNamed:@"tabbar_appfree.png"];
    [nav3.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar.png"] forBarMetrics:UIBarMetricsDefault];

    TopicViewController *login = [[TopicViewController alloc] init];
    UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:login];
    nav4.tabBarItem.title = @"专题";
    nav4.tabBarItem.image = [UIImage imageNamed:@"tabbar_subject.png"];
    [nav4.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar.png"] forBarMetrics:UIBarMetricsDefault];

    HotViewController *login1 = [[HotViewController alloc] init];
    UINavigationController *nav5 = [[UINavigationController alloc] initWithRootViewController:login1];
    nav5.tabBarItem.title = @"热榜";
    nav5.tabBarItem.image = [UIImage imageNamed:@"tabbar_rank.png"];
    [nav5.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar.png"] forBarMetrics:UIBarMetricsDefault];

    self.viewControllers = [NSArray arrayWithObjects:nav1,nav2,nav3,nav4,nav5, nil];
    self.tabBar.hidden = NO;
    self.selectedIndex = 0;

    // Do any additional setup after loading the view.
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
