//
//  Z3TabBarViewController.m
//  Z3Login_Example
//
//  Created by 童万华 on 2019/6/14.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3TabBarViewController.h"
#import <Z3LoginComponent.h>
#import "Z3Theme.h"

#define HEXCOLOR(hexValue)              [UIColor colorWithRed : ((CGFloat)((hexValue & 0xFF0000) >> 16)) / 255.0 green : ((CGFloat)((hexValue & 0xFF00) >> 8)) / 255.0 blue : ((CGFloat)(hexValue & 0xFF)) / 255.0 alpha : 1.0]
@interface Z3TabBarViewController ()

@end

@implementation Z3TabBarViewController
#pragma mark - init
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    
    return self;
}
#pragma mark - view
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)addChildViewControllerWithMenu:(Z3AppMenu *)menu {
    UIViewController *controller = [[NSClassFromString(menu.className) alloc] init];
    UIImage *normalImage = [UIImage imageNamed:menu.iconName];
    UIImage *selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_hl",menu.iconName]];
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:menu.name image:normalImage selectedImage:selectedImage];
    NSDictionary *selectedAttributes = @{
                                        NSForegroundColorAttributeName:HEXCOLOR(themeColorHexValue)
                                         };
    [item setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
    controller.tabBarItem = item;
    controller.navigationItem.title = menu.title;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [self addChildViewController:nav];
    
}

@end
