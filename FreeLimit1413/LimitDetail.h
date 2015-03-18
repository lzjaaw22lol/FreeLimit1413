//
//  LimitDetail.h
//  FreeLimit1413
//
//  Created by qf on 15-3-16.
//  Copyright (c) 2015年 qf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJViewController.h"
@interface LimitDetail : ZJViewController
@property (strong, nonatomic) IBOutlet UIScrollView *scl;
@property (strong, nonatomic) IBOutlet UIImageView *leftpic;
@property (strong, nonatomic) IBOutlet UILabel *softname;
@property (strong, nonatomic) IBOutlet UILabel *softprice;
@property (strong, nonatomic) IBOutlet UILabel *softcat;
@property (strong, nonatomic) IBOutlet UILabel *softsize;
@property (strong, nonatomic) IBOutlet UILabel *softgrade;
- (IBAction)shareAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *shoucangAction;
@property (strong, nonatomic) IBOutlet UIButton *downAction;
@property (strong, nonatomic) IBOutlet UIView *softpic;
@property (strong, nonatomic) IBOutlet UILabel *softdetail;
@property (strong, nonatomic) IBOutlet UIButton *scBtn;
@property (strong, nonatomic) NSDictionary *softMsg;
@property (strong, nonatomic) IBOutlet UIView *arroundSoft;
- (IBAction)shareAction1:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *shoucangAction1;
@property (strong, nonatomic) IBOutlet UIButton *downAction1;
- (IBAction)scAction:(id)sender;
- (IBAction)dnAction:(id)sender;
@property (nonatomic) int softId;
@end
