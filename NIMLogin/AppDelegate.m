//
//  AppDelegate.m
//  NIMLogin
//
//  Created by Nick Deng on 2017/4/17.
//  Copyright © 2017年 Nick Deng. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTab.h"
#import "loginViewController.h"
#import <NIMSDK/NIMSDK.h>

@interface AppDelegate ()<NIMLoginManagerDelegate>
@property (strong, nonatomic) MainTab *mainTabVC;
@property (strong, nonatomic) loginViewController *loginVC;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSString *appKey = @"aeb8d0942936b131da8dae3b86f9535d";
    NSString *cerName = nil;
    
    [[NIMSDK sharedSDK] registerWithAppID:appKey cerName:cerName];
    
    [self commonInitListenEvents];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor grayColor];
    [self.window makeKeyAndVisible];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self setupMainViewController];
    
    return YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[[NIMSDK sharedSDK] loginManager] removeDelegate:self];
}

- (void)setupMainViewController
{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    NSString *account = [user objectForKey:@"account"];
    NSString *token = [user objectForKey:@"token"];
    
    //如果有缓存用户名密码推荐使用自动登录
    if ([account length] && [token length])
    {
        //直接进入界面
        [[[NIMSDK sharedSDK] loginManager] autoLogin:account token:token];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        self.mainTabVC = [storyboard instantiateViewControllerWithIdentifier:@"mainTab"];
        
        self.window.rootViewController = self.mainTabVC;
        [self.window makeKeyAndVisible];
    }
    else
    {
        [self setupLoginViewController];
    }
}


- (void)commonInitListenEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logout:)
                                                 name:@"DYNotificationLogout"
                                               object:nil];
    
    [[[NIMSDK sharedSDK] loginManager] addDelegate:self];
}


-(void)setupLoginViewController{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    self.loginVC = [storyboard instantiateViewControllerWithIdentifier:@"login"];
    
    self.window.rootViewController = self.loginVC;
    [self.window makeKeyAndVisible];
}

-(void)logout:(NSNotification*)note
{
    [self doLogout];
}

- (void)doLogout
{
    [[[NIMSDK sharedSDK] loginManager] logout:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"Logout sucesss!");
        } else {
        NSLog(@"error code is %@",error);
        }
    }];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:@"token"];
    [user removeObjectForKey:@"account"];
    [user synchronize];
    [self setupLoginViewController];
}

- (void)onLogin:(NIMLoginStep)step{
    if (step == NIMLoginStepLoginOK) {
        NSLog(@"登陆成功");
    }
}


@end
