//
//  CategoryViewController.m
//  FreeLimit1413
//
//  Created by qf on 15-3-16.
//  Copyright (c) 2015年 qf. All rights reserved.
//

#import "CategoryViewController.h"
#import "UIImageView+WebCache.h"
#import "ASIHTTPRequest.h"
#import "CategoryCell.h"
#import "SearchViewController.h"
#define viewW [[UIScreen mainScreen] bounds].size.width
#define viewH [[UIScreen mainScreen] bounds].size.height
#define CATE_URL @"http://open.candou.com/app/count"
#define LIMIT_URL @"http://iappfree.candou.com:8080/free/applications/limited?currency=rmb&page=%d&category_id=%@"
#define SALE_URL @"http://iappfree.candou.com:8080/free/applications/sales?currency=rmb&page=%d&category_id=%@"
#define FREE_URL @"http://iappfree.candou.com:8080/free/applications/free?currency=rmb&page=%d&category_id=%@"
#define HOT_URL @"http://open.candou.com/mobile/hot/page/%d&category_id=%@"
@interface CategoryViewController ()<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate>
{
    NSMutableArray *muArr;
    NSArray *catArr;
}
@end

@implementation CategoryViewController

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
    self.tbv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewW, viewH-49-64)];
    muArr = [[NSMutableArray alloc] init];
    catArr = [NSArray arrayWithObjects:@"Ability",@"All",@"Book",@"Business",@"Catalogs",@"Education",@"Finance",@"FoodDrink",@"Game",@"Gps",@"Health",@"Life",@"Medical",@"Music",@"News",@"Pastime",@"Photography",@"Refer",@"Social",@"Sports",@"Tool",@"Travel",@"Weather", nil];
    [self getData];
    
    self.tbv.delegate = self;
    self.tbv.dataSource = self;
    [self.tbv registerNib:[UINib nibWithNibName:@"CategoryCell" bundle:nil] forCellReuseIdentifier:@"catCell"];
    [self.view addSubview:self.tbv];
    self.tbv.tableFooterView = [[UIView alloc] init];
    
}
-(void)getData{
    [self addHud];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:CATE_URL]];
    request.tag = 10;
    request.delegate = self;
    [request startAsynchronous];
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
    if(request.tag == 10){
        NSArray *dict = [NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
        [muArr addObjectsFromArray:dict];
        [self removeHud];
        [self.tbv reloadData];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"catCell";
    CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if(!cell){
        cell = [[CategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    NSDictionary *dict = muArr[indexPath.row];
    NSString *picname = [NSString stringWithFormat:@"category_%@.jpg",dict[@"category_name"]];
    [cell.leftpic setImage:[UIImage imageNamed:picname]];
    cell.leftpic.layer.cornerRadius = 5;
    cell.leftpic.clipsToBounds = YES;
    cell.softname.text = dict[@"category_name"];
    NSString *str = [NSString stringWithFormat:@"共有%@款应用,其中限免%@款",dict[@"category_count"],dict[@"limited"]];
    cell.softdetail.text = str;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return muArr.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *vcs = self.navigationController.viewControllers;
    UIViewController *vc = (UIViewController *)vcs[0];
    NSString *str;
    if([vc.navigationItem.title isEqualToString:@"限免"]){
        str = LIMIT_URL;
    }
    else if ([vc.navigationItem.title isEqualToString:@"降价"]){
        str = SALE_URL;
    }
    else if ([vc.navigationItem.title isEqualToString:@"免费"]){
        str = FREE_URL;
    }
    else if ([vc.navigationItem.title isEqualToString:@"热榜"]){
        str = HOT_URL;
    }
    SearchViewController *searchC = [[SearchViewController alloc] init];
    searchC.url = str;
    NSDictionary *dict = muArr[indexPath.row];
    searchC.whichCat = dict[@"category_id"];
    if(indexPath.row == 0){
        searchC.whichCat = @"1";
    }
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:vc.navigationItem.title style:UIBarButtonItemStyleDone target:self action:@selector(backButtonClick)];
    [backItem setBackgroundImage:[UIImage imageNamed:@"buttonbar_back.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:searchC animated:YES];
}
-(void)backButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
