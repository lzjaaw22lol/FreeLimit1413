//
//  ZJViewController.h
//  FreeLimit1413
//
//  Created by qf on 15-3-16.
//  Copyright (c) 2015年 qf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
@interface ZJViewController : UIViewController<ASIHTTPRequestDelegate>
-(void)addHud;
-(void)removeHud;
@end
