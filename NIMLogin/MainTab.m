//
//  MainTab.m
//  NIMLogin
//
//  Created by Nick Deng on 2017/4/18.
//  Copyright © 2017年 Nick Deng. All rights reserved.
//

#import "MainTab.h"
#import <NIMSDK/NIMSDK.h>

@interface MainTab ()
@property (weak, nonatomic) IBOutlet UITextView *LoginResult;

@end

@implementation MainTab

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *accid = [[NIMSDK sharedSDK].loginManager currentAccount];
    
    self.LoginResult.text = [NSString stringWithFormat:@"Hello, %@",accid];
    self.LoginResult.backgroundColor = [UIColor clearColor];
    
    
    
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
