//
//  MapsViewController.m
//  RLandApp
//
//  Created by Vikhyath on 12/16/15.
//  Copyright © 2015 Self. All rights reserved.
//

#import "MapsViewController.h"
@import GoogleMaps;
#import "GoogleMapDirectionService.h"


@interface MapsViewController ()
{
    NSMutableArray *jsonListOfPlacesArr;
    
    GMSMapView *mapView_;
    GMSCameraPosition *camera;
    GMSMarker *marker1, *marker2;
    GMSPolyline *polyline; //To use in addDirections: selector
    GoogleMapDirectionService *mds;
    
    NSMutableArray *LocationArray;
    NSMutableArray *LongitudeArray, *LatitudeArray;
    NSMutableArray *waypoints_,*waypointStrings_;
    
    SEL selector;
    int counter;
    
    
}

@end

@implementation MapsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //JSON Parsing from the file
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"IITRLocationsInfo" ofType:@"json"];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:filePath];
    NSError *error;
    jsonListOfPlacesArr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    //directions API
    waypoints_ = [[NSMutableArray alloc]init];
    waypointStrings_ = [[NSMutableArray alloc]init];
    
    
    //Initializing the arrays and adding objects correspondingly
    LocationArray = [[NSMutableArray alloc]init];
    LongitudeArray = [[NSMutableArray alloc]init];
    LatitudeArray = [[NSMutableArray alloc]init];
    
    for(int i=0; i<[jsonListOfPlacesArr count]; ++i)
    {
        [LocationArray addObject:[jsonListOfPlacesArr[i] valueForKey:@"Location"]];
        [LongitudeArray addObject:(NSString *)[jsonListOfPlacesArr[i] valueForKey:@"Longitude"]];
        [LatitudeArray addObject:(NSString *)[jsonListOfPlacesArr[i] valueForKey:@"Latitude"]];
    }
    
    //to configure and add all the markers to the map
    [self configuringTheMap:mapView_];
    
    //initialising counter with 0
    counter=0;
    
    //setting to nil is prob a way of initialising them
    marker1.map=nil;
    marker2.map=nil;
    
    //Adding the directions between two places feature
    mds=[[GoogleMapDirectionService alloc] init];
    selector = @selector(addDirections:);
    
    
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
    //[self performSegueWithIdentifier:@"containerViewSegue" sender:nil];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    //Use of this: Rotate the screen in map tab->Switch to any other tab->Rotate back
    //to portrait->Switch back to maps tab! the table is NOT hidden.
    //the deviceorientation delgate method is called only when orientation changes occur within the map tab
    if([[UIDevice currentDevice] orientation]==UIDeviceOrientationPortrait) {
        _listOfPlacesTableView.hidden = YES;
    }
    
    
}

#pragma mark - methods related to map
// custom method to configure and add all the markers to the map
-(void) configuringTheMap:(GMSMapView *)mapview
{
    camera = [GMSCameraPosition cameraWithLatitude:29.8644 longitude:77.8964 zoom:15.8];
    mapView_ = [GMSMapView mapWithFrame:[[UIScreen mainScreen]bounds] camera:camera];
    mapView_.myLocationEnabled = YES; //This property may not be immediately available - for example, if the user is prompted by "iOS" to allow access to this data. It will be nil in this case.
    mapView_.mapType = kGMSTypeNormal;
    [mapView_ animateToViewingAngle:22];
    mapView_.delegate = self; //added in directions API
    [self.view addSubview:mapView_];
    
    
    // Creates a marker in the center of the mapview.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(29.8644, 77.8964);
    marker.title = @"Main Building";
    marker.snippet = @"IIT Roorkee";
    marker.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
    marker.map = mapView_;
    
    //creates a set of markers on the mapview which were collected from the json array
    for(int i=0; i<[jsonListOfPlacesArr count]; ++i)
    {
        
        GMSMarker *sampleMarker = [[GMSMarker alloc]init];
        sampleMarker.position = CLLocationCoordinate2DMake([LatitudeArray[i] doubleValue], [LongitudeArray[i] doubleValue]);
        sampleMarker.title = LocationArray[i];
        sampleMarker.snippet = @"IIT Roorkee" ;
        sampleMarker.map = mapView_;
        
        if( i>=0&& i<18)
            sampleMarker.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
        if(i>=18 && i<28)
            sampleMarker.icon = [GMSMarker markerImageWithColor:[UIColor brownColor]];
        if(i>=28)
            sampleMarker.icon = [GMSMarker markerImageWithColor:[UIColor cyanColor]];
        sampleMarker.icon = [self image:sampleMarker.icon scaledToSize:CGSizeMake(20.0f, 20.0f)];
    }
    
}

//One of the delegate(GMSMApViewDelegate) method
- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    
    if(_isTrackEnabled.on) {
        if(counter==0){
            marker1.map=nil;
        }
        
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
        NSString *positionString = [[NSString alloc] initWithFormat:@"%f,%f",
                                    coordinate.latitude,coordinate.longitude];
        [self AddMarkerAtPosition:position withPositionString:positionString];
    }
    
}

//adding directions feature between two places
- (void)addDirections:(NSDictionary *)json {
    
    NSDictionary *routes = [json objectForKey:@"routes"][0];
    NSDictionary *route = [routes objectForKey:@"overview_polyline"];
    NSString *overview_route = [route objectForKey:@"points"];
    GMSPath *path = [GMSPath pathFromEncodedPath:overview_route];
    polyline = [GMSPolyline polylineWithPath:path];
    polyline.strokeColor = [UIColor orangeColor];
    polyline.strokeWidth = 6.f;
    polyline.map = mapView_;
}

// scaling down the markers size
- (UIImage *)image:(UIImage*)originalImage scaledToSize:(CGSize)size
{
    //avoid redundant drawing
    if (CGSizeEqualToSize(originalImage.size, size))
    {
        return originalImage;
    }
    
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    //draw
    [originalImage drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    
    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}




#pragma mark - custom map features I've added








- (IBAction)trackEnableAction:(UISwitch *)sender {
    
    if(!_isTrackEnabled.on){
        [waypoints_ removeAllObjects];
        [waypointStrings_ removeAllObjects];
        marker1.map=nil;
        marker2.map=nil;
        polyline.map=nil;
        
    }
}

- (IBAction)toggleMapViewAction:(UISegmentedControl *)sender {
    if(sender.selectedSegmentIndex==1)
        mapView_.mapType = kGMSTypeHybrid;
    
    else if(sender.selectedSegmentIndex==0)
        mapView_.mapType=kGMSTypeNormal;
    // [self.view addSubview:mapView_]; this line is not needed
    
    
}

- (IBAction)featuresAction:(UIButton *)sender {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"More Feautres" message:@"Choose by selecting one" preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertController* alertpopup = [UIAlertController alertControllerWithTitle:@"Yo!" message:@"You've already enabled Directions" preferredStyle:UIAlertControllerStyleAlert ];
    
    
    //    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    //    if(orientation==UIDeviceOrientationPortrait) {
    //    UIAlertAction* ListOfPlaces = [UIAlertAction actionWithTitle:@"List of Common Places in IITR" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    //        [self performSegueWithIdentifier:@"SegueToListOfPlaces" sender:nil];
    //    }];
    //      [alert addAction:ListOfPlaces];
    //      //  _listOfPlacesTableView.hidden=YES; //making sure it's hid in portrait mode. sometimes it;s malfunctionin
    //    }
    //
    //    UIAlertAction* RotateDevice = [UIAlertAction actionWithTitle:@"List of Common Places" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    //
    //        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
    //        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    //            }];
    //    [alert addAction:RotateDevice];
    //
    
    UIAlertAction* ListOfPlaces = [UIAlertAction actionWithTitle:@"List of Common Places in IITR" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self performSegueWithIdentifier:@"SegueToListOfPlaces" sender:nil];
    }];
    [alert addAction:ListOfPlaces];
    
    
    
    UIAlertAction* GoToMainBuilding = [UIAlertAction actionWithTitle:@"Restore the view to Main Building" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        mapView_.camera=[GMSCameraPosition cameraWithLatitude:29.8644 longitude:77.8964 zoom:16.1];
        [mapView_ animateToViewingAngle:22];
    }];
    [alert addAction:GoToMainBuilding];
    
    UIAlertAction* switchDetail = [UIAlertAction actionWithTitle:@"Toggle the switch on top to enable Directions" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        if(!_isTrackEnabled.on)[_isTrackEnabled setOn:YES animated:YES];
        else
        {
            [self presentViewController:alertpopup animated:YES completion:nil];
            [self performSelector:@selector(myDismissViewController) withObject:self afterDelay:1];
            
        }
    }];
    [alert addAction:switchDetail];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
    }];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    alert.view.tintColor = [UIColor redColor]; //don't add this line before presenting the viewController
}

-(void) myDismissViewController {
    //used to dismiss the alert view. Defined in method because timer SHOULD need a selector
    [self dismissViewControllerAnimated:YES completion:nil];
}




#pragma mark - Segue: To and Fro with passing data back

//custom delegate method to pass back data(i.e the row number of the selected place) from ListOfPlacesViewController to MapsViewController
//Note that, in the following we can safely omit the controller parameter. It's not useful anywhere!
- (void)addItemViewController:(ListOfPlacesTableViewController *)controller didFinishEnteringItem:(NSInteger)item
{
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake([LatitudeArray[(int)item] doubleValue],
                                                                 [LongitudeArray[(int)item] doubleValue]); //Note that these are methods of CoreLocation
    NSString *positionString = [[NSString alloc] initWithFormat:@"%f,%f",
                                [LatitudeArray[(int)item] doubleValue],[LongitudeArray[(int)item] doubleValue]];
    
    if(_isTrackEnabled.on)
    {
        if(counter==0) {
            marker1.map=nil;
        }
        
        
        [self AddMarkerAtPosition:position withPositionString:positionString];
        
        if(item==1)marker1.title = LocationArray[(int)item];
        else if(item==2)marker2.title = LocationArray[(int)item];
        
        //TODO: Check if you can use animateToCameraPostion and animateToLocation methods
        camera = [GMSCameraPosition cameraWithLatitude:[LatitudeArray[(int)item]doubleValue] longitude:[LongitudeArray[(int)item] doubleValue] zoom:16.1];
        mapView_.camera=camera;
        [mapView_ animateToViewingAngle:22]; //be careful; check what happens if you put this above mapView_.camera = camera; there would be no effect taking place !
    }
    else {
        
        counter=0;
        
        marker1.map=nil;
        marker1 = [GMSMarker markerWithPosition:position];
        marker1.title = LocationArray[(int)item];
        marker1.icon = [GMSMarker markerImageWithColor:[UIColor orangeColor]];
        marker1.map = mapView_;
        
        camera = [GMSCameraPosition cameraWithLatitude:[LatitudeArray[(int)item]doubleValue] longitude:[LongitudeArray[(int)item] doubleValue] zoom:16.1];
        mapView_.camera=camera;
        [mapView_ animateToViewingAngle:22];
        
    }
    
    
}



-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier]isEqualToString:@"SegueToListOfPlaces"]){
        ListOfPlacesTableViewController *lopc = [segue destinationViewController];
        lopc.delegate =self;
    }
    //    if([[segue identifier]isEqualToString:@"SegueToListOfPlacesqq"]){
    //        ListOfPlacesViewController *lopc2 = [segue destinationViewController];
    //        lopc2.delegate =self;
    //    }
    
}

#pragma mark- Device Rotation Handlers
////-(void)didRotateFromInterfaceOrientation(UIInterfaceOrientation)fromInterfaceOrientation
////above method was not handy as things are getting updated AFTER rotation is done
//- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
//    CGRect screenRect = [[UIScreen mainScreen] bounds];
//
//    if (toInterfaceOrientation == UIInterfaceOrientationPortrait)    {
//        _listOfPlacesTableView.hidden=YES;
//
//        [self.view endEditing:YES]; //else an opened keyboard in landscape doesn't disappear after toggling to portrait
////[self resignFirstResponder]; doesn't work
//    }
//    else
//    {   //   mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 0, screenRect.size.width/2, screenRect.size.height) camera:camera];
//        //Implement the above line and you are totally fucked ! Segment controls nor tapping map works. But don't know how mapview is exactly getting halved on rotation without this line! :o
//    _listOfPlacesTableView.frame=CGRectMake( screenRect.size.width/2,0, screenRect.size.width/2, screenRect.size.height);
//        _listOfPlacesTableView.hidden=NO;
//
//
//       }
//}




#pragma mark - IMP! Code to make markers
-(void)AddMarkerAtPosition:(CLLocationCoordinate2D )position withPositionString:(NSString *)positionString
{
    counter++;
    if(counter==3){
        [waypoints_ removeAllObjects];
        [waypointStrings_ removeAllObjects];
        
        marker1.map=nil;
        marker2.map=nil;
        polyline.map=nil;
        
        counter =1;
    }
    
    [waypointStrings_ addObject:positionString];
    
    if(counter==1 )
    {
        marker1 = [GMSMarker markerWithPosition:position];
        
        marker1.icon = [GMSMarker markerImageWithColor:[UIColor orangeColor]];
        marker1.map = mapView_;
        [waypoints_ addObject:marker1];
    }
    
    if(counter==2)
    {
        marker2 = [GMSMarker markerWithPosition:position] ;
        
        marker2.icon = [GMSMarker markerImageWithColor:[UIColor orangeColor]];
        marker2.map = mapView_;
        [waypoints_ addObject:marker2];
        
        NSString *sensor = @"false";
        NSArray *parameters = @[sensor, waypointStrings_];
        NSArray *keys = @[@"sensor", @"waypoints"];
        NSDictionary *query = [NSDictionary dictionaryWithObjects:parameters forKeys:keys];
        
        [mds setDirectionsQuery:query withSelector:selector withDelegate:self];
    }
    
    
    
    
}




@end