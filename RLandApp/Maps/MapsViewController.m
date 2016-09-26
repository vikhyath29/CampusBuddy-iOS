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
    
    
    GMSMapView *mapView_;
    GMSCameraPosition *camera;
    GMSMarker *marker1, *marker2;
    GMSPolyline *polyline; //To use in addDirections: selector
    GoogleMapDirectionService *mds;
    
    NSMutableArray *locationNameArray;
    NSMutableArray *LongitudeArray, *LatitudeArray;
    NSMutableArray *waypoints_,*waypointStrings_;
    
    SEL selector;
    int counter;
    
    NSArray *sortedArray;
    NSMutableDictionary *sortedDictionaryFinal;
    BOOL isTrackEnabled; //made global as it's req also in `didTapAtCoordinate` method TODO[Modfify]
    
    
    //Search Part
    NSMutableArray *searchedLocationsDetailsArray;
    NSMutableArray *selectedLocationNames;

    
    
//    NSArray *sortedArray;
}

@end

/* ToDo:
    1. Handle Deselection
    2. Remove Longitude, Latitude and few other unnecessary arrays
    3. Remove isTrackEnabled IBOutlet and update the argument in our delegate method addItemVC..
    
*/
//,{"Location":"Dept. of Management Studies","Latitude":77.894766,"Longitude":77.894766,"type":"department"}

@implementation MapsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //JSON Parsing from the file
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"IITRLocationsInfo" ofType:@"json"];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:filePath];
    NSError *error;
    NSArray *jsonListOfPlacesArr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    //directions API
    waypoints_ = [[NSMutableArray alloc]init];
    waypointStrings_ = [[NSMutableArray alloc]init];
    
    
 
    
    NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc]init];
    for(int i=0; i<[jsonListOfPlacesArr count]; ++i) {
        [tempDictionary setObject:@{
                            @"Location":[jsonListOfPlacesArr[i] valueForKey:@"Location"],
                            @"Longitude" :[jsonListOfPlacesArr[i] valueForKey:@"Longitude"],
                            @"Latitude" : [jsonListOfPlacesArr[i] valueForKey:@"Latitude"],
                             @"type"     : [jsonListOfPlacesArr[i] valueForKey:@"type"],
                            @"isSelectionChecked" : @NO
                            }
              forKey:jsonListOfPlacesArr[i][@"Location"]];
        
//        [tempDictionary setObject:[NSMutableDictionary dictionaryWithDictionary:@{
//                                                                                  @"Location":[jsonListOfPlacesArr[i] valueForKey:@"Location"],
//                                                                                  @"Longitude" :[jsonListOfPlacesArr[i] valueForKey:@"Longitude"],
//                                                                                  @"Latitude" : [jsonListOfPlacesArr[i] valueForKey:@"Latitude"],
//                                                                                  @"type"     : [jsonListOfPlacesArr[i] valueForKey:@"type"],
//                                                                                  @"isSelectionChecked" : @NO
//                                                                                  }
//                                   ] forKey:jsonListOfPlacesArr[i][@"Location"]];

    }
    
    
    
    sortedArray = [[tempDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    sortedDictionaryFinal = [[NSMutableDictionary alloc]init];
    for(int i=0; i<sortedArray.count; ++i) {
        [sortedDictionaryFinal setObject:tempDictionary[sortedArray[i]] forKey:sortedArray[i]];
    }
    
    
    NSMutableArray *allDetailsArray = [[NSMutableArray alloc]init];
    for(int i=0; i<sortedArray.count; ++i) {
        [allDetailsArray addObject:[tempDictionary valueForKey:sortedArray[i]]];
    }
    //Initializing the arrays and adding objects correspondingly
    locationNameArray = [[NSMutableArray alloc]init];
    LongitudeArray = [[NSMutableArray alloc]init];
    LatitudeArray = [[NSMutableArray alloc]init];
    for(int i=0; i<[allDetailsArray count]; ++i)
    {
        [locationNameArray addObject:[allDetailsArray[i] valueForKey:@"Location"]];
        [LongitudeArray addObject:(NSString *)[allDetailsArray[i] valueForKey:@"Longitude"]];
        [LatitudeArray addObject:(NSString *)[allDetailsArray[i] valueForKey:@"Latitude"]];
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
    

    /*Search Part */
    searchedLocationsDetailsArray = [[NSMutableArray alloc]init];
    selectedLocationNames = [[NSMutableArray alloc]init];
    _placesTableView.frame = CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, self.view.frame.size.height/2);
}



#pragma mark - methods related to map
// custom method to configure and add all the markers to the map
-(void) configuringTheMap:(GMSMapView *)mapview
{
    camera = [GMSCameraPosition cameraWithLatitude:29.8644 longitude:77.8964 zoom:16.2];
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




#pragma mark - custom map features I've added


- (IBAction)featuresAction:(UIButton *)sender {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"More Feautres" message:@"Choose by selecting one" preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertController* alertpopup = [UIAlertController alertControllerWithTitle:@"Yo!" message:@"You've already enabled Directions" preferredStyle:UIAlertControllerStyleAlert ];
    

    
    UIAlertAction* GoToMainBuilding = [UIAlertAction actionWithTitle:@"Restore the view to Main Building" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        mapView_.camera=[GMSCameraPosition cameraWithLatitude:29.8644 longitude:77.8964 zoom:16.1];
        [mapView_ animateToViewingAngle:22];
    }];
    [alert addAction:GoToMainBuilding];
 
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





- (void)addItemViewControllerdidFinishEnteringItem:(NSInteger)item withIsTrackEnabled:(BOOL)_isTrackEnabled
{
isTrackEnabled = _isTrackEnabled;
//following if statement is the commented `trackEnableAction` method
if(!_isTrackEnabled){
    [waypoints_ removeAllObjects];
    [waypointStrings_ removeAllObjects];
    marker1.map=nil;
    marker2.map=nil;
    polyline.map=nil;
    
}
CLLocationCoordinate2D position = CLLocationCoordinate2DMake([LatitudeArray[(int)item] doubleValue],
                                                             [LongitudeArray[(int)item] doubleValue]); //Note that these are methods of CoreLocation
NSString *positionString = [[NSString alloc] initWithFormat:@"%f,%f",
                            [LatitudeArray[(int)item] doubleValue],[LongitudeArray[(int)item] doubleValue]];

if(_isTrackEnabled)
{
    if(counter==0) {
        marker1.map=nil;
    }
    
    
    [self AddMarkerAtPosition:position withPositionString:positionString];
    
    if(item==1)marker1.title = locationNameArray[(int)item];
    else if(item==2)marker2.title = locationNameArray[(int)item];
    
    //TODO: Check if you can use animateToCameraPostion and animateToLocation methods
    camera = [GMSCameraPosition cameraWithLatitude:[LatitudeArray[(int)item]doubleValue] longitude:[LongitudeArray[(int)item] doubleValue] zoom:16.1];
    mapView_.camera=camera;
    [mapView_ animateToViewingAngle:22]; //be careful; check what happens if you put this above mapView_.camera = camera; there would be no effect taking place !
}
else {
    
    counter=0;
    
    marker1.map=nil;
    marker1 = [GMSMarker markerWithPosition:position];
    marker1.title = locationNameArray[(int)item];
    marker1.icon = [GMSMarker markerImageWithColor:[UIColor orangeColor]];
    marker1.map = mapView_;
    
    camera = [GMSCameraPosition cameraWithLatitude:[LatitudeArray[(int)item]doubleValue] longitude:[LongitudeArray[(int)item] doubleValue] zoom:16.1];
    mapView_.camera=camera;
    [mapView_ animateToViewingAngle:22];
    
}
}


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




/* Search Part for Maps */
#pragma mark - tableView protocol methods
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.searchDisplayController.searchResultsTableView)
        return [searchedLocationsDetailsArray count];
    
    else
        return [sortedArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EachPlaceCell"];
    if(!cell)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@"EachPlaceCell"];
    
    
    
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        cell.textLabel.text= [searchedLocationsDetailsArray objectAtIndex:indexPath.row][@"Location"];
        //  cell.imageView.image = [GMSMarker markerImageWithColor:[UIColor blueColor]];
        
        if([searchedLocationsDetailsArray[indexPath.row][@"type"] isEqualToString:@"general"])
        {cell.textLabel.textColor = [UIColor redColor];
            cell.imageView.image = [GMSMarker markerImageWithColor:[UIColor redColor]];
        }
        
        if([searchedLocationsDetailsArray[indexPath.row][@"type"] isEqualToString:@"bhawan"]) {
            cell.textLabel.textColor = [UIColor brownColor];
            cell.imageView.image = [GMSMarker markerImageWithColor:[UIColor brownColor]];
        }
        
        if([searchedLocationsDetailsArray[indexPath.row][@"type"] isEqualToString:@"department"]){
            cell.textLabel.textColor = [UIColor colorWithRed:52.0/255.0 green:130.0/255.0 blue:230.0/255.0 alpha:1.0];
            cell.imageView.image = [GMSMarker markerImageWithColor:[UIColor cyanColor]];
        }
        
        NSString *key = searchedLocationsDetailsArray[indexPath.row][@"Location"];
        if([sortedDictionaryFinal[key][@"isSelectionChecked"]  isEqual: @NO]) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
}   
    
    else{ //if tableview is in normal mode
//        cell.textLabel.text = [LocationDictionary valueForKey:sortedArray[indexPath.row]][@"Location"];
//        //cell.imageView.image = [GMSMarker markerImageWithColor:[UIColor yellowColor]];
//        
//        
//        if([[LocationDictionary valueForKey:sortedArray[indexPath.row]][@"type"] isEqualToString:@"general"])
//        {cell.textLabel.textColor = [UIColor redColor];
//            cell.imageView.image = [GMSMarker markerImageWithColor:[UIColor redColor]];
//        }
//        
//        if([[LocationDictionary valueForKey:sortedArray[indexPath.row]][@"type"] isEqualToString:@"bhawan"]) {
//            cell.textLabel.textColor = [UIColor brownColor];
//            cell.imageView.image = [GMSMarker markerImageWithColor:[UIColor brownColor]];
//        }
//        
//        if([[LocationDictionary valueForKey:sortedArray[indexPath.row]][@"type"] isEqualToString:@"department"]){
//            cell.textLabel.textColor = [UIColor colorWithRed:52.0/255.0 green:130.0/255.0 blue:230.0/255.0 alpha:1.0];
//            cell.imageView.image = [GMSMarker markerImageWithColor:[UIColor cyanColor]];
//        }
    }
    return cell;
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{//TO-DO: [Modify] can reduce the code
    
    //One Place Selection Switch
    if(!_searchFeatureSwitch.on) {
        if (tableView == self.searchDisplayController.searchResultsTableView){
            
            [self addItemViewControllerdidFinishEnteringItem:[sortedArray indexOfObject:searchedLocationsDetailsArray[indexPath.row][@"Location"]] withIsTrackEnabled:NO];
            [self.searchDisplayController setActive:NO];
        }
        
     //   else
     //       [self addItemViewControllerdidFinishEnteringItem:indexPath.row withIsTrackEnabled:_searchFeatureSwitch.on];
        
        
    }
    
    //Two Places Selection Switch
    else if(_searchFeatureSwitch.on) {
        
        if (tableView == self.searchDisplayController.searchResultsTableView){
            
            NSString *selectedLocationName = [searchedLocationsDetailsArray objectAtIndex:indexPath.row][@"Location"];
            
            NSLog(@"You just pressed %@", selectedLocationName);
            
            [selectedLocationNames addObject:selectedLocationName];
            [sortedDictionaryFinal valueForKey:selectedLocationName][@"isSelectionChecked"] = @YES;
            
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;

            // [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow].row also returns the row but this isn't needed here. The method is already providing in form of `indexPath`
            
            [self addItemViewControllerdidFinishEnteringItem:[sortedArray indexOfObject:searchedLocationsDetailsArray[indexPath.row][@"Location"]] withIsTrackEnabled:YES];
           // NSLog(@"Number of selected rows are %i",[[tableView indexPathsForSelectedRows] count] );
            
 
            if(selectedLocationNames.count==2 ) {
//                NSLog(@"List of all selected names are");
//                for(int i=0; i<selectedLocationNames.count; ++i)
//                    NSLog(@"%@", [sortedDictionaryFinal valueForKey:selectedLocationNames[i]]);
                
                
                [sortedDictionaryFinal valueForKey:selectedLocationNames[0]][@"isSelectionChecked"] = @NO;
                [sortedDictionaryFinal valueForKey:selectedLocationNames[1]][@"isSelectionChecked"] = @NO;
                [selectedLocationNames removeAllObjects];
                
            [self.searchDisplayController setActive:NO];
                
            }
        }
    }
}

//-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
//if (tableView == self.searchDisplayController.searchResultsTableView){
//
//    NSString *selectedLocationName = searchedLocationsDetailsArray[indexPath.row][@"Location"];
//    [sortedDictionaryFinal valueForKey:selectedLocationName][@"isSelectionChecked"] = @NO;
//    NSLog(@"Deselected Row is %@", [searchedLocationsDetailsArray objectAtIndex:indexPath.row][@"Location"]);
//    
//    [selectedLocationNames removeObject:selectedLocationName];
//    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
//    
//    
//    }
//}


#pragma mark - methods for search feature
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{   /* Custom method */
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"self contains[c] %@", searchText];
    NSArray *searchedLocationNames = [locationNameArray filteredArrayUsingPredicate:resultPredicate];
    
    [searchedLocationsDetailsArray removeAllObjects]; //cleaning again
    
    for(int i=0; i<searchedLocationNames.count; ++i)
        [searchedLocationsDetailsArray addObject:@{
                                        @"Location" : searchedLocationNames[i],
                                        @"type"     : sortedDictionaryFinal[searchedLocationNames[i]][@"type"],
                                        @"isSelectionChecked" : sortedDictionaryFinal[searchedLocationNames[i]][@"isSelectionChecked"]
                                        }];


}




//Asks the delegate if the table view should be reloaded for a given search string.
//If you don’t implement this method, then the results table is reloaded as soon as the search string changes.
//You might implement this method if you want to perform an asynchronous search. You would initiate the search in this method, then return NO. You would reload the table when you have results.
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)seasrchBar {

    return YES;
}





@end