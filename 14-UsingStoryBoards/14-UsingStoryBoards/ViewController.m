//
//  ViewController.m
//  14-UsingStoryBoards
//
//  Created by Pedro Ferreira de Matos on 10/04/17.
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ViewController2 *destination =
    [segue destinationViewController];
    
    destination.labelText = @"Arrived from Scene 1";
}

-(IBAction)returned:(UIStoryboardSegue *)segue {
    _scene1Label.text = @"Returned from Scene 2";
}


@end
