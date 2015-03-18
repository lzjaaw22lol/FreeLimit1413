//
//  LimitViewController.m
//  FreeLimit1413
//
//  Created by qf on 15-3-16.
//  Copyright (c) 2015年 qf. All rights reserved.
//

#import "HotViewController.h"
#import "QuickControl.h"
#import "XMtablecell.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "ASIHTTPRequest.h"
#import "UIImageView+WebCache.h"
#import "LimitDetail.h"
#import "CategoryViewController.h"
#import "PeizhiController.h"
#import "SearchViewController.h"
#define viewW [[UIScreen mainScreen] bounds].size.width
#define viewH [[UIScreen mainScreen] bounds].size.height
#define HOT_URL @"http://open.candou.com/mobile/hot/page/%d&category_id=%@"

@interface HotViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate,UISearchBarDelegate,ASIHTTPRequestDelegate>
{
    UITableView *tbv;
    NSMutableArray *muArr;
    NSArray *fullMsg;
    MJRefreshFooterView *footer;
    MJRefreshHeaderView *header;
    NSMutableArray * _searchArray;
    int pagecount;
}
@end

@implementation HotViewController

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
    self.navigationItem.title = @"热榜";
    self.navigationController.navigationBar.translucent = NO;
    muArr = [[NSMutableArray alloc] init];
    pagecount = 1;
    [self addNavBtn];
    
    [self addTable];
    [self getHeader];
    [self getFooter];
    [self getData:1];
}
-(void)getData:(int)n{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    CGAffineTransform old = hud.transform;
    hud.transform = CGAffineTransformScale(old, 0.7, 0.7);
    hud.labelText = @"正在加载...";
    hud.detailsLabelText = @"请稍后";
    if(n == 1){
        pagecount = 1;
        NSString *urlstr = [NSString stringWithFormat:HOT_URL,1,@"6014"];
        NSURL *url = [NSURL URLWithString:urlstr];
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
        request.delegate = self;
        request.tag = 1;
        [request startAsynchronous];
    }
    else if(n == 2){
        CGAffineTransform old = hud.transform;
        hud.transform = CGAffineTransformScale(old, 0.7, 0.7);
        hud.labelText = @"正在加载...";
        hud.detailsLabelText = @"请稍后";
        
        pagecount++;
        NSLog(@"%d",pagecount);
        NSString *urlstr = [NSString stringWithFormat:HOT_URL,pagecount,@"6014"];
        NSURL *url = [NSURL URLWithString:urlstr];
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
        request.delegate = self;
        request.tag = 2;
        [request startAsynchronous];
        
    }
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
    
    if(request.tag == 1){
        [muArr removeAllObjects];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
        if([dict objectForKey:@"applications"]){
             NSLog(@"dd:%d",[[dict objectForKey:@"applications"] count]);
            [muArr addObjectsFromArray:[dict objectForKey:@"applications"]];
            fullMsg = [NSArray arrayWithArray:muArr];
            [header endRefreshing];
        }
        else
        {
            [self getData:1];
        }
    }
    else if(request.tag == 2){
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
        if([dict objectForKey:@"applications"]){
            [muArr addObjectsFromArray:[dict objectForKey:@"applications"]];
            fullMsg = [NSArray arrayWithArray:muArr];
            [footer endRefreshing];
        }
        else
        {
            pagecount--;
            [self getData:2];
        }
    }

    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [tbv reloadData];
}
-(void)addNavBtn{
    UIButton *left = [UIButton buttonWithFrame:CGRectMake(0, 0, 44, 30) title:@"分类" image:nil target:self action:@selector(leftAction)];
    [left setBackgroundImage:[UIImage imageNamed:@"buttonbar_action.png"] forState:UIControlStateNormal];
    UIBarButtonItem *leftbtn = [[UIBarButtonItem alloc] initWithCustomView:left];
    self.navigationItem.leftBarButtonItem = leftbtn;
    
    UIButton *right = [UIButton buttonWithFrame:CGRectMake(0, 0, 44, 30) title:@"配置" image:nil target:self action:@selector(rightAction)];
    [right setBackgroundImage:[UIImage imageNamed:@"buttonbar_action.png"] forState:UIControlStateNormal];
    
    UIBarButtonItem *rightbtn = [[UIBarButtonItem alloc] initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = rightbtn;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:self.navigationItem.title style:UIBarButtonItemStyleDone target:self action:@selector(backButtonClick:)];
    self.navigationItem.backBarButtonItem = backItem;
    
}
-(void)leftAction{
    CategoryViewController *cvc = [[CategoryViewController alloc] init];
    [self.navigationController pushViewController:cvc animated:YES];
}
-(void)rightAction{
    PeizhiController *pc = [[PeizhiController alloc] init];
    [self.navigationController pushViewController:pc animated:YES];
}
-(void)backButtonClick:(id)n{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)addTable{
    tbv = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, viewW, viewH-49-64+5) style:UITableViewStylePlain];
    tbv.delegate = self;
    tbv.dataSource = self;
    [self.view addSubview:tbv];
    [tbv registerNib:[UINib nibWithNibName:@"XMtablecell" bundle:nil] forCellReuseIdentifier:@"cellid"];
    tbv.tableFooterView = [[UIView alloc] init];
    //    tbv.tableFooterView = [[UIView alloc] init];
    
    UISearchBar * searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, viewW, 40)];
    searchBar.delegate = self;
    searchBar.placeholder = @"60万应用搜搜看";
    [self.view addSubview:searchBar];
    _searchArray = [[NSMutableArray alloc] init];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tbv) {
        return [muArr count];
    }else{
        return _searchArray.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    XMtablecell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if(!cell){
        cell = [[XMtablecell alloc] init];
    }
    if(tableView == tbv){
        NSDictionary *dict = muArr[indexPath.row];
        if(muArr.count > indexPath.row){
            if(indexPath.row%2 == 0){
                cell.cellbg.image = [UIImage imageNamed:@"cate_list_bg1.png"];
            }
            else{
                cell.cellbg.image = [UIImage imageNamed:@"cate_list_bg2.png"];
            }
            [cell.leftpic setImageWithURL:[NSURL URLWithString:dict[@"iconUrl"]]];
            cell.typetitle.text = dict[@"name"];
            cell.type.text = dict[@"categoryName"];
            cell.sharetime.text = dict[@"shares"];
            cell.shoucang.text = dict[@"favorites"];
            cell.downtime.text = dict[@"downloads"];
            cell.oldprice.text = dict[@"lastPrice"];
            [self getStar:dict[@"starCurrent"] and:cell.star];
        }
    }
    else{
        NSLog(@"r:%@",_searchArray);
        [_searchArray objectAtIndex:indexPath.row];
        NSDictionary *dict = _searchArray[indexPath.row];
        if(indexPath.row%2 == 0){
            cell.cellbg.image = [UIImage imageNamed:@"cate_list_bg1.png"];
        }
        else{
            cell.cellbg.image = [UIImage imageNamed:@"cate_list_bg2.png"];
        }
        [cell.leftpic setImageWithURL:[NSURL URLWithString:dict[@"iconUrl"]]];
        cell.leftpic.layer.cornerRadius = 5;
        cell.leftpic.clipsToBounds = YES;
        cell.typetitle.text = dict[@"name"];
        cell.type.text = dict[@"categoryName"];
        cell.sharetime.text = dict[@"shares"];
        cell.shoucang.text = dict[@"favorites"];
        cell.downtime.text = dict[@"downloads"];
        cell.oldprice.text = dict[@"lastPrice"];
        [self getStar:dict[@"starCurrent"] and:cell.star];
    }
    cell.layer.cornerRadius = 5;
    return cell;
}
-(void)getStar:(NSString *)st and:(UIView *)vi{
    NSArray *arr = [vi subviews];
    for(id tem in arr){
        [tem removeFromSuperview];
    }
    float haveStar = [st floatValue];
    int bigStar = (int)haveStar;
    int smallStar;
    if(haveStar > (float)bigStar){
        smallStar = 1;
    }
    else{
        smallStar = 0;
    }
    int i;
    for(i=0;i<bigStar;i++){
        UIImageView *p = [[UIImageView alloc] initWithFrame:CGRectMake(5+15*i, 3, 15, 15)];
        p.image = [UIImage imageNamed:@"1.主页_14.png"];
        [vi addSubview:p];
    }
    if(smallStar == 1){
        UIImageView *p = [[UIImageView alloc] initWithFrame:CGRectMake(5+15*i, 3, 15, 15)];
        p.image = [UIImage imageNamed:@"5.专题_15.png"];
        [vi addSubview:p];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LimitDetail *detail = [[LimitDetail alloc] init];
    detail.softId = [[muArr[indexPath.row] objectForKey:@"applicationId"] intValue];
    [self.navigationController pushViewController:detail animated:YES];
}
-(void)getHeader{
    header = [[MJRefreshHeaderView alloc] initWithScrollView:tbv];
    header.delegate = self;
}
-(void)getFooter{
    footer = [[MJRefreshFooterView alloc] initWithScrollView:tbv];
    footer.delegate = self;
}
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if(header == refreshView){
        [self getData:1];
    }
    else if (footer == refreshView){
        [self getData:2];
    }
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(searchText.length == 0){
        [muArr removeAllObjects];
        [muArr addObjectsFromArray:fullMsg];
    }
    else{
        [muArr removeAllObjects];
        for (NSDictionary * dict in fullMsg) {
            NSString *str = dict[@"name"];
            NSLog(@"ss%@(%@)",str,searchText);
            NSRange rang = [str rangeOfString:searchText];
            if (rang.location != NSNotFound) {
                [muArr addObject:dict];
            }
        }
    }
    [tbv reloadData];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"sfffsstt");
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
