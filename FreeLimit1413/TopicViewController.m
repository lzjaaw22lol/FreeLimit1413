//
//  TopicViewController.m
//  FreeLimit1413
//
//  Created by qf on 15-3-16.
//  Copyright (c) 2015年 qf. All rights reserved.
//

#import "TopicViewController.h"
#import "TopicCell.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#define TOPIC_URL @"http://iappfree.candou.com:8080/free/special?page=%d&limit=5"
#define viewW [[UIScreen mainScreen] bounds].size.width
#define viewH [[UIScreen mainScreen] bounds].size.height
@interface TopicViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    NSMutableArray *muArr;
    MJRefreshFooterView *footer;
    MJRefreshHeaderView *header;
    int pagecount;
}
@end

@implementation TopicViewController

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
    self.navigationItem.title = @"专题";
    pagecount = 1;
    muArr = [[NSMutableArray alloc] init];
    [self getData:1];
    self.tbv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewW, viewH-49-64)];
    self.tbv.delegate = self;
    self.tbv.dataSource = self;
    [self.tbv registerNib:[UINib nibWithNibName:@"TopicCell" bundle:nil] forCellReuseIdentifier:@"Topcell"];
    [self.view addSubview:self.tbv];
    self.tbv.tableFooterView = [[UIView alloc] init];
    [self getHeader];
    [self getFooter];
}
-(void)getData:(int)n{
    [self addHud];
    if(n == 1){
        //        hud.b = [UIColor blackColor];
        //        CGContextSetFillColorWithColor(hud., <#CGColorRef color#>)
        pagecount = 1;
        NSString *urlstr = [NSString stringWithFormat:TOPIC_URL,1];
        NSURL *url = [NSURL URLWithString:urlstr];
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
        request.delegate = self;
        request.tag = 1;
        [request startAsynchronous];
    }
    else{
        pagecount++;
        NSString *urlstr = [NSString stringWithFormat:TOPIC_URL,pagecount];
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
        NSArray *dict = [NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
        [muArr addObjectsFromArray:dict];
        [header endRefreshing];
    }
    else{
        NSArray *dict = [NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
        [muArr addObjectsFromArray:dict];
        [footer endRefreshing];
    }
    [self removeHud];
    [self.tbv reloadData];

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 308;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return muArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"Topcell";
    TopicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if(!cell){
        cell = [[TopicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    if(muArr.count > indexPath.row){
        NSDictionary *dict = muArr[indexPath.row];
        cell.toptitle.text = dict[@"title"];
        [cell.leftpic setImageWithURL:[NSURL URLWithString:dict[@"img"]]];
        [cell.bottompic setImageWithURL:[NSURL URLWithString:dict[@"desc_img"]]];
        cell.softdetail.text = dict[@"desc"];
        NSArray *tem = dict[@"applications"];
        cell.softname.text = [tem[0] objectForKey:@"name"];
        [cell.pic1 setImageWithURL:[NSURL URLWithString:[tem[0] objectForKey:@"iconUrl"]]];
        [self getStar:[tem[0] objectForKey:@"starOverall"] and:cell.starView1];
        NSString *strp = [NSString stringWithFormat:@"%d",[[tem[0] objectForKey:@"comment"] intValue]];
        cell.comnum1.text = strp;
        cell.downtime1.text = [tem[0] objectForKey:@"downloads"];
        
        cell.softname2.text = [tem[1] objectForKey:@"name"];
        [cell.pic2 setImageWithURL:[NSURL URLWithString:[tem[1] objectForKey:@"iconUrl"]]];
        [self getStar:[tem[1] objectForKey:@"starOverall"] and:cell.starView2];
        strp = [NSString stringWithFormat:@"%d",[[tem[1] objectForKey:@"comment"] intValue]];
        cell.comnum1.text = strp;
        cell.downtime2.text = [tem[1] objectForKey:@"downloads"];

        cell.softname3.text = [tem[2] objectForKey:@"name"];
        [cell.pic3 setImageWithURL:[NSURL URLWithString:[tem[2] objectForKey:@"iconUrl"]]];
        [self getStar:[tem[2] objectForKey:@"starOverall"] and:cell.starView3];
        strp = [NSString stringWithFormat:@"%d",[[tem[2] objectForKey:@"comment"] intValue]];
        cell.comnum1.text = strp;
        cell.downtime3.text = [tem[2] objectForKey:@"downloads"];

        cell.softname4.text = [tem[3] objectForKey:@"name"];
        [cell.pic4 setImageWithURL:[NSURL URLWithString:[tem[3] objectForKey:@"iconUrl"]]];
        [self getStar:[tem[3] objectForKey:@"starOverall"] and:cell.starView4];
        strp = [NSString stringWithFormat:@"%d",[[tem[3] objectForKey:@"comment"] intValue]];
        cell.comnum1.text = strp;
        cell.downtime4.text = [tem[3] objectForKey:@"downloads"];
       
    }
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
        UIImageView *p = [[UIImageView alloc] initWithFrame:CGRectMake(15*i, 1, 15, 15)];
        p.image = [UIImage imageNamed:@"1.主页_14.png"];
        [vi addSubview:p];
    }
    if(smallStar == 1){
        UIImageView *p = [[UIImageView alloc] initWithFrame:CGRectMake(15*i, 1, 15, 15)];
        p.image = [UIImage imageNamed:@"5.专题_15.png"];
        [vi addSubview:p];
    }
}

-(void)getHeader{
    header = [[MJRefreshHeaderView alloc] initWithScrollView:self.tbv];
    header.delegate = self;
}
-(void)getFooter{
    footer = [[MJRefreshFooterView alloc] initWithScrollView:self.tbv];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
