//
//  MapController.h
//  GeoMapping
//
//  Created by Pedro Ferreira de Matos on 13/05/17.
//  Copyright © 2017 Pedro Ferreira de Matos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface MapController : UIViewController

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet UILabel *labelLatitude;
@property (strong, nonatomic) IBOutlet UILabel *labelLongitude;
@property (strong, nonatomic) IBOutlet UILabel *labelAltitude;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)logOut:(UIButton *)sender;

@end
