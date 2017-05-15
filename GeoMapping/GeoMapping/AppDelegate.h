//
//  AppDelegate.h
//  GeoMapping
//
//  Created by Pedro Ferreira de Matos on 13/05/17.
//  Copyright © 2017 Pedro Ferreira de Matos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, GIDSignInDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

