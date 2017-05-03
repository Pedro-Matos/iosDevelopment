//
//  ViewController.h
//  Tutorial6
//
//  Created by Pedro Ferreira de Matos on 08/04/17.
//  Copyright © 2017 Pedro Ferreira de Matos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *text_field;
@property (strong, nonatomic) IBOutlet UILabel *label_result;
- (IBAction)convertTemp:(id)sender;

@end

