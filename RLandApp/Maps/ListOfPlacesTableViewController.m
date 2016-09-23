//
//  ListOfPlacesTableViewController.m
//  RLandApp
//
//  Created by Vikhyath on 1/30/16.
//  Copyright © 2016 Self. All rights reserved.


#import "ListOfPlacesTableViewController.h"
@import GoogleMaps;

@interface ListOfPlacesTableViewController ()
{
    
    NSMutableArray *searchResultsArray;
    
    NSMutableDictionary *LocationDictionary;
    
    NSArray *sortedArray;
}
@end

/* To-Do:
 2. https://www.youtube.com/watch?v=lXTTgBQuw8M
 3. Wrong Places: DOMS,Govind Bhawan, Convocation Hall
 */

@implementation ListOfPlacesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"IITRLocationsInfo" ofType:@"json"];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:filePath];
    NSError *error;
    NSMutableArray *outsideArr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
   
    
    LocationDictionary = [[NSMutableDictionary alloc]init];
    for(int i=0; i<[outsideArr count]; ++i)
        [LocationDictionary setObject:@{
                                        @"Location" : [outsideArr[i] valueForKey:@"Location"],
                                        @"type"     : [outsideArr[i] valueForKey:@"type"]
                                        }
                               forKey:[outsideArr[i] valueForKey:@"Location"]];

    sortedArray = [[LocationDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

    searchResultsArray = [[NSMutableArray alloc]init];

  //  self.searchDisplayController.searchBar.
  //  self.searchDisplayController.displaysSearchBarInNavigationBar = YES;
}

#pragma mark - tableView protocol methods
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.searchDisplayController.searchResultsTableView)
     return [searchResultsArray count];
    
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
    cell.textLabel.text= [searchResultsArray objectAtIndex:indexPath.row][@"Location"];
//  cell.imageView.image = [GMSMarker markerImageWithColor:[UIColor blueColor]];
        
        if([searchResultsArray[indexPath.row][@"type"] isEqualToString:@"general"])
        {cell.textLabel.textColor = [UIColor redColor];
            cell.imageView.image = [GMSMarker markerImageWithColor:[UIColor redColor]];
        }
        
        if([searchResultsArray[indexPath.row][@"type"] isEqualToString:@"bhawan"]) {
            cell.textLabel.textColor = [UIColor brownColor];
            cell.imageView.image = [GMSMarker markerImageWithColor:[UIColor brownColor]];
        }
        
        if([searchResultsArray[indexPath.row][@"type"] isEqualToString:@"department"]){
            cell.textLabel.textColor = [UIColor colorWithRed:52.0/255.0 green:130.0/255.0 blue:230.0/255.0 alpha:1.0];
            cell.imageView.image = [GMSMarker markerImageWithColor:[UIColor cyanColor]];
        }

    }
    
    else{
        cell.textLabel.text = [LocationDictionary valueForKey:sortedArray[indexPath.row]][@"Location"];
        //cell.imageView.image = [GMSMarker markerImageWithColor:[UIColor yellowColor]];
    
    
    if([[LocationDictionary valueForKey:sortedArray[indexPath.row]][@"type"] isEqualToString:@"general"])
    {cell.textLabel.textColor = [UIColor redColor];
    cell.imageView.image = [GMSMarker markerImageWithColor:[UIColor redColor]];
    }
    
    if([[LocationDictionary valueForKey:sortedArray[indexPath.row]][@"type"] isEqualToString:@"bhawan"]) {
        cell.textLabel.textColor = [UIColor brownColor];
    cell.imageView.image = [GMSMarker markerImageWithColor:[UIColor brownColor]];
    }
    
    if([[LocationDictionary valueForKey:sortedArray[indexPath.row]][@"type"] isEqualToString:@"department"]){
        cell.textLabel.textColor = [UIColor colorWithRed:52.0/255.0 green:130.0/255.0 blue:230.0/255.0 alpha:1.0];
        cell.imageView.image = [GMSMarker markerImageWithColor:[UIColor cyanColor]];
    }
    }
    return cell;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(_searchFeatureSwitch.on)
        return @"Select any two places to get the route";
    else
        return @"Select a place to locate it";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{//TO-DO: [Modify] can reduce the code
    //One Place Selection Switch
    if(!_searchFeatureSwitch.on) {
    if (tableView == self.searchDisplayController.searchResultsTableView){
        
        //selection in searchtableview
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        //selection also in normaltableview
        NSInteger rowSelectedInNormalTableView = [sortedArray indexOfObject:searchResultsArray[indexPath.row][@"Location"]];
        [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowSelectedInNormalTableView inSection:0]].accessoryType = UITableViewCellAccessoryCheckmark;
        
        // [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow].row also returns the row but this isn't needed here. The method is already providing in form of `indexPath`

        [self.delegate addItemViewController:self didFinishEnteringItem:[sortedArray indexOfObject:searchResultsArray[indexPath.row][@"Location"]] withIsTrackEnabled:NO];
     
//                self.searchDisplayController.searchBar.text=@"";
//                [self.searchDisplayController.searchBar resignFirstResponder];
                [self.searchDisplayController setActive:NO]; //works like charm! replaces above two lines
    }

    else {
        [self.delegate addItemViewController:self didFinishEnteringItem:indexPath.row withIsTrackEnabled:_searchFeatureSwitch.on];
    }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    //Two Places Selection Switch
    else if(_searchFeatureSwitch.on) {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;

        if (tableView == self.searchDisplayController.searchResultsTableView){
            
            // [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow].row also returns the row but this isn't needed here. The method is already providing in form of `indexPath`
            
            [self.delegate addItemViewController:self didFinishEnteringItem:[sortedArray indexOfObject:searchResultsArray[indexPath.row][@"Location"]] withIsTrackEnabled:YES];
            
            //                self.searchDisplayController.searchBar.text=@"";
            //                [self.searchDisplayController.searchBar resignFirstResponder];
            [self.searchDisplayController setActive:NO]; //works like charm! replaces above two lines
        }
        
        else {
            [self.delegate addItemViewController:self didFinishEnteringItem:indexPath.row withIsTrackEnabled:_searchFeatureSwitch.on];
        }
        
        if([[tableView indexPathsForSelectedRows] count] ==2 )
        [self.navigationController popViewControllerAnimated:YES];
    
    }
    
    
    
    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;

}


#pragma mark - methods for search feature
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{   /* Custom method */
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"self contains[c] %@", searchText];
    
//    NSArray *locations = [LocationArray valueForKey:@"Location"]; //a neat trick to get all values for a particular key in an array of dictionaries
    NSArray *locations = [LocationDictionary allKeys];
   NSArray *searchResultNames = [locations filteredArrayUsingPredicate:resultPredicate];
    
    [searchResultsArray removeAllObjects]; //cleaning again
    for(int i=0; i<searchResultNames.count; ++i)
        [searchResultsArray addObject:@{
                                        @"Location" : searchResultNames[i],
                                        @"type"     : LocationDictionary[searchResultNames[i]][@"type"]
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

- (IBAction)searchFeatureSwitchAction:(id)sender {
    //reloads the section-0; since this has only one section, no difference with [tv reloadData]
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];

    
}
@end
