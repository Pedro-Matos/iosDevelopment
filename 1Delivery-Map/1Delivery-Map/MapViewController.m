//
//  MapViewController.m
//  1Delivery-Map
//
//  Created by Pedro Ferreira de Matos on 04/05/17.
//  Copyright © 2017 Pedro Ferreira de Matos. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([_street_text isFirstResponder] && [touch view] != _street_text) {
        [_street_text resignFirstResponder];
    }
    if ([_city_text isFirstResponder] && [touch view] != _city_text) {
        [_city_text resignFirstResponder];
    }
    if ([_state_text isFirstResponder] && [touch view] != _state_text) {
        [_state_text resignFirstResponder];
    }
    if ([_zip_text isFirstResponder] && [touch view] != _zip_text) {
        [_zip_text resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

-(void)showMap
{
    NSDictionary *address = @{
                              (NSString *)kABPersonAddressStreetKey: _street_text.text,
                              (NSString *)kABPersonAddressCityKey: _city_text.text,
                              (NSString *)kABPersonAddressStateKey: _state_text.text,
                              (NSString *)kABPersonAddressZIPKey: _zip_text.text
                              };
    
    MKPlacemark *place = [[MKPlacemark alloc]
                          initWithCoordinate:_coords
                          addressDictionary:address];
    
    MKMapItem *mapItem =
    [[MKMapItem alloc]initWithPlacemark:place];
    
    NSDictionary *options = @{
                              MKLaunchOptionsDirectionsModeKey: 
                                  MKLaunchOptionsDirectionsModeDriving
                              };
    
    [mapItem openInMapsWithLaunchOptions:options];
}

- (IBAction)getDirections:(id)sender {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    NSString *addressString =
    [NSString stringWithFormat:
     @"%@ %@ %@ %@",
     _street_text.text,
     _city_text.text,
     _state_text.text,
     _zip_text.text];
    
    [geocoder
     geocodeAddressString:addressString
     completionHandler:^(NSArray *placemarks,
                         NSError *error) {
         
         if (error) {
             NSLog(@"Geocode failed with error: %@", error);
             return;
         }
         
         if (placemarks && placemarks.count > 0)
         {
             CLPlacemark *placemark = placemarks[0];
             
             CLLocation *location = placemark.location;
             _coords = location.coordinate;
             
             [self showMap];
         }
     }];
}
@end
