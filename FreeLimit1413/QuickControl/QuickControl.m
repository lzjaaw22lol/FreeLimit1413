//
//  QuickControl.m
//  FreeLimit1413
//
//  Created by mac on 14-6-25.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "QuickControl.h"

@implementation UILabel (QuickControl)
//添加快速创建的方法
+(id)labelWithFrame:(CGRect)frame text:(NSString *)text
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    return label;
}

@end

@implementation UIButton (QuickControl)

//快速创建按钮的方法
+(id)buttonWithFrame:(CGRect)frame
               title:(NSString *)title
               image:(NSString *)image
              target:(id)target
              action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end

@implementation UIImageView (QuickControl)
//快速创建imageView
+(id)imageViewWithFrame:(CGRect)frame
                  image:(NSString *)image
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [UIImage imageNamed:image];
    return imageView;
}
@end

@implementation UIView (QuickControl)
//可以为任何view设置圆角
-(void)setCornerRadius:(float)radius
{
    self.layer.cornerRadius = radius;
    self.clipsToBounds = YES;
}
@end

@implementation QuickControl
//判断系统版本
+(int)osVersion
{
    //使用UIDevice设别类获取版本, 名字.....
    return [[[UIDevice currentDevice] systemVersion] intValue];
}
//获取屏幕高度
+(float)screenHeight
{
    //使用 UIScreen类获取
    return [[UIScreen mainScreen] bounds].size.height;
}
//获取屏幕宽度
+(float)screenWidth
{
    return [[UIScreen mainScreen] bounds].size.width;
}
@end
