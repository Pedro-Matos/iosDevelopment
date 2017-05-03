//
//  MapViewController.h
//  1Delivery-Map
//
//  Created by Pedro Ferreira de Matos on 04/05/17.
//  Copyright © 2017 Pedro Ferreira de Matos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <AddressBook/AddressBook.h>

@interface MapViewController : UIViewController
@property CLLocationCoordinate2D coords;
@property (strong, nonatomic) IBOutlet UITextField *street_text;
@property (strong, nonatomic) IBOutlet UITextField *city_text;
@property (strong, nonatomic) IBOutlet UITextField *state_text;
@property (strong, nonatomic) IBOutlet UITextField *zip_text;
- (IBAction)getDirections:(id)sender;

@end
