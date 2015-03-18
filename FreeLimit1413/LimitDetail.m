//
//  LimitDetail.m
//  FreeLimit1413
//
//  Created by qf on 15-3-16.
//  Copyright (c) 2015年 qf. All rights reserved.
//

#import "LimitDetail.h"
#import "UIImageView+WebCache.h"
#import "ZJCreateDb.h"
#define viewW [[UIScreen mainScreen] bounds].size.width
#define viewH [[UIScreen mainScreen] bounds].size.height
#define DETAIL_URL @"http://iappfree.candou.com:8080/free/applications/%d?currency=rmb"
#define NEARBY_APP_URL @"http://iappfree.candou.com:8080/free/applications/recommend?longitude=116.344539&latitude=40.034346"
@interface LimitDetail ()<UIActionSheetDelegate>
{
    NSDictionary *resDict;
    NSArray *arroundArr;
}
@end

@implementation LimitDetail

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.scl.frame = CGRectMake(0, 10, viewW, viewH-59);
    self.scl.contentSize = CGSizeMake(viewW, 410);

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"应用详细";
    self.navigationController.navigationBar.translucent = NO;
    [self getData];
    
}
-(void)getData{
    [self addHud];
    NSString *str = [NSString stringWithFormat:DETAIL_URL,self.softId];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:str]];
    request.delegate = self;
    request.tag = 1;
    [request startAsynchronous];
    
    NSString *str1 = NEARBY_APP_URL;
    ASIHTTPRequest *request1 = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:str1]];
    request1.delegate = self;
    request1.tag = 2;
    [request1 startAsynchronous];

}
-(void)requestFinished:(ASIHTTPRequest *)request
{
//    获取主要内容
    if(request.tag == 1){
        resDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
        [self.leftpic setImageWithURL:[NSURL URLWithString:[resDict objectForKey:@"iconUrl"]]];
        self.leftpic.layer.cornerRadius = 5;
        self.leftpic.clipsToBounds = YES;
        self.softname.text = resDict[@"name"];
        self.softprice.text = resDict[@"currentPrice"];
        self.softgrade.text = resDict[@"starCurrent"];
        self.softcat.text = resDict[@"categoryName"];
        self.softsize.text = [NSString stringWithFormat:@"%@M",resDict[@"fileSize"]];
        self.softdetail.text = resDict[@"description_long"];
        
        int i=0;
        for(NSDictionary *tem in resDict[@"photos"]){
            NSString *temstr = tem[@"smallUrl"];
            UIImageView *p = [[UIImageView alloc] initWithFrame:CGRectMake(60*i, 0, 58, 90)];
            [p setImageWithURL:[NSURL URLWithString:temstr]];
            [self.softpic addSubview:p];
            i++;
        }
        ZJCreateDb *zdb = [ZJCreateDb defaultManager];
        if([zdb isShouCang:resDict[@"applicationId"]]){
            self.scBtn.selected = YES;
        }
        NSLog(@"all:%@",[zdb selectAllMsg]);
        NSLog(@"y:%hhd",[zdb isShouCang:resDict[@"applicationId"]]);

    }
//    获取周边应用
    else{
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
        arroundArr = dict[@"applications"];
        NSArray *temarr = dict[@"applications"];
        int i=0;
        for(NSDictionary *tem in temarr){
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tuijianAction:)];
            
            UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(10+57*i, 2, 50, 70)];
            UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
            [pic setImageWithURL:[NSURL URLWithString:tem[@"iconUrl"]]];
            [bg addSubview:pic];
            UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(0, 52, 50, 20)];
            la.textColor = [UIColor blackColor];
            la.font = [UIFont systemFontOfSize:12];
            la.text = tem[@"name"];
            [bg addSubview:la];
            pic.layer.cornerRadius = 5;
            pic.clipsToBounds = YES;
            bg.tag = i+10;
            [bg addGestureRecognizer:tap];
            [self.arroundSoft addSubview:bg];

            
//            
//            UIImageView *p = [[UIImageView alloc] initWithFrame:CGRectMake(10+57*i, 2, 50, 50)];
//            [p setImageWithURL:[NSURL URLWithString:tem[@"iconUrl"]]];
//            p.layer.cornerRadius = 5;
//            p.clipsToBounds = YES;
//            p.tag = 10+i;
//            [self.arroundSoft addSubview:p];
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tuijianAction:)];
//            tap.numberOfTapsRequired = 1;
//            tap.numberOfTouchesRequired = 1;
//            [p addGestureRecognizer:tap];
//            UILabel *p1 = [[UILabel alloc] initWithFrame:CGRectMake(10+57*i, 54, 50, 20)];
//            p1.textColor = [UIColor blackColor];
//            p1.font = [UIFont systemFontOfSize:10];
//            p1.text = tem[@"name"];
//            [self.arroundSoft addSubview:p1];
            i++;
        }
    }
    [self removeHud];
}
-(void)tuijianAction:(UITapGestureRecognizer *)tap{
    NSDictionary *dict = arroundArr[tap.view.tag-10];
    LimitDetail *ld = [[LimitDetail alloc] init];
    ld.softId = [dict[@"applicationId"] intValue];
    [self.navigationController pushViewController:ld animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareAction:(id)sender {
}
- (IBAction)shareAction1:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"标题" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"新浪微博",@"微信好友",@"微信圈子",@"邮件",@"短信", nil];
    [actionSheet showInView:self.navigationController.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"index = %d",buttonIndex);
}
- (IBAction)scAction:(UIButton *)sender {
//    NSDictionary *temdict = fullMsg[0];
//    NSDictionary *passDb = [NSDictionary dictionaryWithObjectsAndKeys:
//                            temdict[@"applicationId"],@"applicationId",
//                            self.navigationItem.title,@"recordType",
//                            temdict[@"name"],@"name",
//                            temdict[@"iconUrl"],@"icon",
//                            temdict[@"categoryName"],@"type",
//                            temdict[@"lastPrice"],@"lastPrice",
//                            temdict[@"currentPrice"],@"currentPrice",
//                            nil];
    ZJCreateDb *zdb = [ZJCreateDb defaultManager];
    if(sender.selected == NO){
        NSArray *arr = self.navigationController.viewControllers;
        UIViewController *vc = (UIViewController *)arr[0];
        NSString *str = vc.navigationItem.title;
        NSMutableDictionary *passDb = [[NSMutableDictionary alloc] init];
        [passDb setObject:str forKey:@"recordType"];
        [passDb setObject:resDict[@"name"] forKey:@"name"];
        [passDb setObject:resDict[@"applicationId"] forKey:@"applicationId"];
        [passDb setObject:resDict[@"iconUrl"] forKey:@"iconUrl"];
        [passDb setObject:resDict[@"lastPrice"] forKey:@"lastPrice"];
        [passDb setObject:resDict[@"currentPrice"] forKey:@"currentPrice"];
        [passDb setObject:resDict[@"categoryName"] forKey:@"type"];
        if([zdb addMsg:passDb]){
            sender.selected = YES;
            UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:@"收藏成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alt show];
        }
        else{
            UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:@"收藏失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alt show];
        }
    }
    else{
        if([zdb removeMsg:resDict[@"applicationId"]]){
            sender.selected = NO;
            UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alt show];
        }
        else{
            UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alt show];
        }

    }
}

- (IBAction)dnAction:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:resDict[@"itunesUrl"]]];
}
@end
