//
//  XMtablecell.h
//  FreeLimit1413
//
//  Created by qf on 15-3-16.
//  Copyright (c) 2015年 qf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMtablecell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *cellbg;
@property (strong, nonatomic) IBOutlet UIImageView *leftpic;
@property (strong, nonatomic) IBOutlet UILabel *sharetime;
@property (strong, nonatomic) IBOutlet UILabel *typetitle;
@property (strong, nonatomic) IBOutlet UIView *star;
@property (strong, nonatomic) IBOutlet UILabel *shoucang;
@property (strong, nonatomic) IBOutlet UILabel *oldprice;
@property (strong, nonatomic) IBOutlet UILabel *type;
@property (strong, nonatomic) IBOutlet UILabel *downtime;

@end
