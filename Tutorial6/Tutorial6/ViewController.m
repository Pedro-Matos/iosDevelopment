//
//  ViewController.m
//  Tutorial6
//
//  Created by Pedro Ferreira de Matos on 08/04/17.
//  Copyright © 2017 Pedro Ferreira de Matos. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)convertTemp:(id)sender {
    double fahrenheit = [_text_field.text doubleValue];
    double celsius = (fahrenheit - 32) / 1.8;
    
    NSString *resultString = [[NSString alloc] initWithFormat:@"Celsius %2.3f", celsius];
    _label_result.text = resultString;

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([_text_field isFirstResponder] && [touch view] != _text_field) {
        [_text_field resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}


@end
