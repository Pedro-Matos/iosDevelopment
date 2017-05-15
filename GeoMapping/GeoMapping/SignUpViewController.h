//
//  SignUpViewController.h
//  GeoMapping
//
//  Created by Pedro Ferreira de Matos on 15/05/17.
//  Copyright © 2017 Pedro Ferreira de Matos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *passwd_1;
@property (strong, nonatomic) IBOutlet UITextField *passwd_2;
- (IBAction)signup_btn:(id)sender;

@end
