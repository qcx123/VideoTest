//
//  DKTabBarViewController.m
//  VideoTest
//
//  Created by 乔春晓 on 2018/7/16.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import "DKTabBarViewController.h"
#import "DKVideoViewController.h"
#import "DKViewController.h"
#import "DKDouYinViewController.h"
#import "DKWelfareViewController.h"
#import "DKMineViewController.h"
#import "DKNavigationController.h"

@interface DKTabBarViewController ()

@end

@implementation DKTabBarViewController

//很多一次性设置的东西完全可以放在initialize中
+(void)initialize {
    //根据appreance设置所有字体大小和颜色
    NSMutableDictionary *normalDict = [[NSMutableDictionary alloc] init];
    normalDict[NSFontAttributeName] = [UIFont systemFontOfSize:10.0f];
    
    normalDict[NSForegroundColorAttributeName] = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];;
    
    NSMutableDictionary *selectedDict = [[NSMutableDictionary alloc] init];
    selectedDict[NSFontAttributeName] = [UIFont systemFontOfSize:10.0f];
    selectedDict[NSForegroundColorAttributeName] = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    
    UITabBarItem *tabBarItem = [UITabBarItem appearance];
    [tabBarItem setTitleTextAttributes:normalDict forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:selectedDict forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加子控制器
    [self setupChildViewController:[[DKVideoViewController alloc] init] Title:@"看游戏" Image:[UIImage imageNamed:@"btn_kyx_n"] andSelectedImg:[UIImage imageNamed:@"btn_kyx_h"]];
    [self setupChildViewController:[[DKWelfareViewController alloc] init] Title:@"福利" Image:[UIImage imageNamed:@"btn_fl_n"] andSelectedImg:[UIImage imageNamed:@"btn_fl_h"]];
    [self setupChildViewController:[[DKMineViewController alloc] init] Title:@"我的" Image:[UIImage imageNamed:@"btn_wd_n"] andSelectedImg:[UIImage imageNamed:@"btn_wd_h"]];
    
    
    //更换tabBar
    //    [self setValue:[[CCTabBar alloc] init] forKeyPath:@"tabBar"];
}

//设置子控制器的基本属性
-(void)setupChildViewController:(UIViewController *)vc Title:(NSString *)title Image:(UIImage *)img andSelectedImg:(UIImage *)selectedImg {
    
    //设置文字和图片
    //    vc.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(100)/100.0 green:arc4random_uniform(100)/100.0 blue:arc4random_uniform(100)/100.0 alpha:1.0f];//这行代码其实有很大问题,因为如果这么写的话 就会把四个控制器全都一次性创建,造成内存问题以及请求问题.虽然很方便但是最好别这么写
    vc.tabBarItem.title = title;
    UIImage *settingImg = img;
    //设置图片默认渲染为不渲染
    settingImg = [settingImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.image = settingImg;
    selectedImg = [selectedImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = selectedImg;
    [self addChildViewController:vc];
    //包装一个导航控制器,让它成为UITabBarController的子控制器
    DKNavigationController *nav = [[DKNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
