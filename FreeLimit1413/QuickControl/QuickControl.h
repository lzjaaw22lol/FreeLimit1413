//
//  QuickControl.h
//  FreeLimit1413
//
//  Created by mac on 14-6-25.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

//目的为了快速创建控件
//  label,button,imageView
@interface UILabel (QuickControl)
//快速创建label的方法
+(id)labelWithFrame:(CGRect)frame
               text:(NSString *)text;
@end

@interface UIButton (QuickControl)
//快速创建按钮的方法
+(id)buttonWithFrame:(CGRect)frame
               title:(NSString *)title
               image:(NSString *)image
              target:(id)target
              action:(SEL)action;
@end

@interface UIImageView (QuickControl)
//快速创建imageView
+(id)imageViewWithFrame:(CGRect)frame
                  image:(NSString *)image;
@end


@interface UIView (QuickControl)
//可以为任何view设置圆角
-(void)setCornerRadius:(float)radius;
@end


@interface QuickControl : NSObject

//判断系统版本
+(int)osVersion;

//获取屏幕高度
+(float)screenHeight;
//获取屏幕宽度
+(float)screenWidth;
@end
