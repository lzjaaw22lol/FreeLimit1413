//
//  SearchViewController.m
//  FreeLimit1413
//
//  Created by qf on 15-3-16.
//  Copyright (c) 2015年 qf. All rights reserved.
//

#import "SearchViewController.h"
#import "QuickControl.h"
#import "XMtablecell.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "ASIHTTPRequest.h"
#import "UIImageView+WebCache.h"
#import "LimitDetail.h"
#import "CategoryViewController.h"
#import "PeizhiController.h"
#import "ZJCreateDb.h"
#define viewW self.view.frame.size.width
#define viewH self.view.frame.size.height
#define SEARCH_URL @"http://open.candou.com/search/app/word/%@/app/iphone/rank/0/start/1/limit/40"
@interface SearchViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate,UISearchBarDelegate,ASIHTTPRequestDelegate>
{
    UITableView *tbv;
    NSMutableArray *muArr;
    MJRefreshFooterView *footer;
    MJRefreshHeaderView *header;
    NSArray *fullMsg;
    NSMutableArray * _searchArray;
    int pagecount;
}
@end


@implementation SearchViewController

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
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
    navTitle.textColor = [UIColor blueColor];
    navTitle.font = [UIFont boldSystemFontOfSize:20];
    navTitle.text = @"搜索结果";
    self.automaticallyAdjustsScrollViewInsets = NO;
    muArr = [[NSMutableArray alloc] init];
    pagecount = 1;

    [self addTable];
    [self getHeader];
    [self getFooter];
//    搜索页面
    if([self.isSearch isEqualToString:@"3"]){
        [self getData:3];
    }
//    我的收藏
//    else if([self.isSearch isEqualToString:@"4"]){
//        navTitle.text = @"我的收藏";
//        [self getDataFromDb];
//    }
//    分类
    else
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
        if([self.whichCat isEqualToString:@"1"])
            self.whichCat = @"";
        NSString *urlstr = [NSString stringWithFormat:self.url,1,self.whichCat];
        NSURL *url = [NSURL URLWithString:urlstr];
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
        request.delegate = self;
        request.tag = 1;
        [request startAsynchronous];
    }
    else if(n == 2){
        pagecount++;
        NSString *urlstr = [NSString stringWithFormat:self.url,pagecount,self.whichCat];
        NSURL *url = [NSURL URLWithString:urlstr];
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
        request.delegate = self;
        request.tag = 2;
        [request startAsynchronous];        
    }
    else if (n == 3){
        pagecount = 1;
        NSString *urlstr = [NSString stringWithFormat:SEARCH_URL,self.key];
        NSURL *url = [NSURL URLWithString:urlstr];
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
        request.delegate = self;
        request.tag = 3;
        [request startAsynchronous];
    }
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
    if(request.tag == 1){
        [muArr removeAllObjects];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
        if([dict objectForKey:@"applications"]){
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
    else if(request.tag == 3){
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
        [muArr addObjectsFromArray:[dict objectForKey:@"applications"]];
        fullMsg = [NSArray arrayWithArray:muArr];
        [footer endRefreshing];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [tbv reloadData];
}
-(void)addTable{
    tbv = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, viewW, viewH-49-64-40) style:UITableViewStylePlain];
    tbv.delegate = self;
    tbv.dataSource = self;
    [self.view addSubview:tbv];
    tbv.tableFooterView = [[UIView alloc] init];
    [tbv registerNib:[UINib nibWithNibName:@"XMtablecell" bundle:nil] forCellReuseIdentifier:@"cellid11"];
    //    tbv.tableFooterView = [[UIView alloc] init];
    
    UISearchBar * searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, viewW, 40)];
    searchBar.delegate = self;
    searchBar.placeholder = @"60万应用搜搜看";
    [self.view addSubview:searchBar];
//    tbv.tableHeaderView = searchBar;
    
//    _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
//    _searchDisplayController.searchResultsDataSource = self;
//    _searchDisplayController.searchResultsDelegate = self;
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
    static NSString *cellid = @"cellid11";
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
