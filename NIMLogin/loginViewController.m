//
//  loginViewController.m
//  NIMLogin
//
//  Created by Nick Deng on 2017/4/18.
//  Copyright © 2017年 Nick Deng. All rights reserved.
//

#import "loginViewController.h"
#import "MainTab.h"
#import <NIMSDK/NIMSDK.h>

#define UIColorFromRGBA(rgbValue, alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]

@interface loginViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) MainTab *mainTabVC;

@end

@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.usernameTextField.tintColor = [UIColor whiteColor];
    [self.usernameTextField setValue:UIColorFromRGBA(0xffffff, .6f) forKeyPath:@"_placeholderLabel.textColor"];
    
    self.passwordTextField.tintColor = [UIColor whiteColor];
    [self.passwordTextField setValue:UIColorFromRGBA(0xffffff, .6f) forKeyPath:@"_placeholderLabel.textColor"];
    
    UIButton *pwdClearButton = [self.passwordTextField valueForKey:@"_clearButton"];
    [pwdClearButton setImage:[UIImage imageNamed:@"login_icon_clear"] forState:UIControlStateNormal];
    
    UIButton *userClearButton = [self.usernameTextField valueForKey:@"_clearButton"];
    [userClearButton setImage:[UIImage imageNamed:@"login_icon_clear"] forState:UIControlStateNormal];
    
    self.passwordTextField.delegate = self;
    //self.passwordTextField.returnKeyType = UIReturnKeyDone;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self configStatusBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doLogin{
    
    [_usernameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    
    NSString *account = [_usernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    //NSString *account = _usernameTextField.text;
    NSString *token = _passwordTextField.text;
    
    [[NIMSDK sharedSDK].loginManager login:account token:token completion:^(NSError * _Nullable error) {
        if (!error) {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            
            [user setObject:account forKey:@"account"];
            [user setObject:token forKey:@"token"];
            [user synchronize];
            
            //唤起主界面
            self.mainTabVC = [self.storyboard instantiateViewControllerWithIdentifier:@"mainTab"];
            
            [UIApplication sharedApplication].keyWindow.rootViewController = self.mainTabVC;
            
            
        } else {
            
            NSString *msg =  [NSString stringWithFormat:@"错误码：%@",error];
            
            UIAlertController *alerController = [UIAlertController alertControllerWithTitle:@"登陆失败！" message:msg preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"好吧。。" style:UIAlertActionStyleDefault handler:nil];
            
            [alerController addAction:action];
            
            [self presentViewController:alerController animated:YES completion:nil];
            NSLog(@"登陆失败:%@",error);
        }
    }];

}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [_usernameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}

- (void)configStatusBar{
    UIStatusBarStyle style = [self preferredStatusBarStyle];
    [[UIApplication sharedApplication] setStatusBarStyle:style
                                                animated:NO];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    
//    
//    if ([string isEqualToString:@"\n"]) {
//        [self doLogin];
//        return NO;
//    }
//    return YES;
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    BOOL flag = NO;
    if (textField == self.passwordTextField) {
        [self doLogin];
        [self.passwordTextField resignFirstResponder];
    } else {
        flag = YES;
    }
    return flag;
}



@end
