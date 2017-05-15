//
//  SignUpViewController.m
//  GeoMapping
//
//  Created by Pedro Ferreira de Matos on 15/05/17.
//  Copyright © 2017 Pedro Ferreira de Matos. All rights reserved.
//

#import "SignUpViewController.h"
@import Firebase;

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([_email isFirstResponder] && [touch view] != _email) {
        [_email resignFirstResponder];
    }if ([_passwd_1 isFirstResponder] && [touch view] != _passwd_1) {
        [_passwd_1 resignFirstResponder];
    }
    if ([_passwd_2 isFirstResponder] && [touch view] != _passwd_2) {
        [_passwd_2 resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)validation{
    NSString *strEmailID = [_email.text stringByTrimmingCharactersInSet:
                            [NSCharacterSet whitespaceCharacterSet]];
    NSString *strPassword = [_passwd_1.text stringByTrimmingCharactersInSet:
                             [NSCharacterSet whitespaceCharacterSet]];
    NSString *strConfirmPassword = [_passwd_2.text stringByTrimmingCharactersInSet:
                                    [NSCharacterSet whitespaceCharacterSet]];
    if (strEmailID.length <= 0){
        printf("Error in email length");
        return NO;
    }
    else if ([self validateEmailAddress:strEmailID] == NO){
        printf("Error. Email not valid.");
        return NO;
    }
    else if (strPassword.length <= 6){
        printf("Error in password length");
        return NO;
    }
    else if (strConfirmPassword.length <= 6){
        printf("Error in password length");
        return NO;
    }
    else if (![strPassword isEqualToString:strConfirmPassword]){
        printf("Error. Passwords do not match.");
        return NO;
    }
    
    return YES;
}

-(BOOL)validateEmailAddress:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (IBAction)signup_btn:(id)sender {
    if ([self validation]){
        [[FIRAuth auth] createUserWithEmail:_email.text password:_passwd_1.text completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error in FIRAuth := %@",error.localizedDescription);
            }
            else{
                NSLog(@"user Id : %@", user.uid);
                [self.navigationController popViewControllerAnimated:true];
            }
        }];
    }
}
@end
