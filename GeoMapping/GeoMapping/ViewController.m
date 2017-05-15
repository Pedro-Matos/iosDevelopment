//
//  ViewController.m
//  GeoMapping
//
//  Created by Pedro Ferreira de Matos on 13/05/17.
//  Copyright © 2017 Pedro Ferreira de Matos. All rights reserved.
//

#import "ViewController.h"
#import "Constants.h"
#import "MeasurementHelper.h"
@import Firebase;

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *passwd;
- (IBAction)signUp:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signUp:(id)sender {
    
    [[FIRAuth auth] signInWithEmail:_username.text password:_passwd.text completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error in FIRAuth := %@",error.localizedDescription);
            }
            else{
                [self performSegueWithIdentifier:SeguesSignInToMap sender:nil];
            }
    }
    ];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([_username isFirstResponder] && [touch view] != _username) {
        [_username resignFirstResponder];
    }if ([_passwd isFirstResponder] && [touch view] != _passwd) {
        [_passwd resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

@end
