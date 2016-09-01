//
//  ListOfPlacesViewController.m
//  RLandApp
//
//  Created by Vikhyath on 1/30/16.
//  Copyright © 2016 Self. All rights reserved.


#import "ListOfPlacesViewController.h"
@import GoogleMaps;

@interface ListOfPlacesViewController ()
{
    NSMutableArray *LocationArray;
    NSArray *searchResults;
    
}
@end

@implementation ListOfPlacesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"IITRLocationsInfo" ofType:@"json"];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:filePath];
    NSError *error;
    NSMutableArray *outsideArr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
   
    LocationArray = [[NSMutableArray alloc]init];
    for(int i=0; i<[outsideArr count]; ++i)
    [LocationArray addObject:[outsideArr[i] valueForKey:@"Location"]];
    
    
  //  self.searchDisplayController.searchBar.
  //  self.searchDisplayController.displaysSearchBarInNavigationBar = YES;
}

#pragma mark - tableView protocol methods
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.searchDisplayController.searchResultsTableView)
     return [searchResults count];
    
    else
    return [LocationArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EachPlaceCell"];
    if(!cell)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@"EachPlaceCell"];
    
    
    
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
    cell.textLabel.text= [searchResults objectAtIndex:indexPath.row];
//        cell.imageView.image = [GMSMarker markerImageWithColor:[UIColor blueColor]];
    }
    
    
    
    else{
        cell.textLabel.text = [LocationArray objectAtIndex:indexPath.row];
        //cell.imageView.image = [GMSMarker markerImageWithColor:[UIColor yellowColor]];
    }
    
    if( indexPath.row>=0&& indexPath.row<18)
    {cell.textLabel.textColor = [UIColor redColor];
        cell.imageView.image = [GMSMarker markerImageWithColor:[UIColor redColor]];
        
    }
    
    if(indexPath.row>=18 && indexPath.row<28) {
        cell.textLabel.textColor = [UIColor brownColor];
    cell.imageView.image = [GMSMarker markerImageWithColor:[UIColor brownColor]];
    }
    if(indexPath.row>=28){
        cell.textLabel.textColor = [UIColor colorWithRed:52.0/255.0 green:130.0/255.0 blue:230.0/255.0 alpha:1.0];
        cell.imageView.image = [GMSMarker markerImageWithColor:[UIColor cyanColor]];
    }
    return cell;
    
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Select any two places to get the route";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView){
        
        for(int i=0; i<[LocationArray count]; ++i)
            if(LocationArray[i]==[searchResults objectAtIndex:[self.searchDisplayController.searchResultsTableView indexPathForSelectedRow].row])
            {
                [self.delegate addItemViewController:self didFinishEnteringItem:i];
//                self.searchDisplayController.searchBar.text=@"";
//                [self.searchDisplayController.searchBar resignFirstResponder];
                [self.searchDisplayController setActive:NO]; //works like charm! replaces above two lines   
                               break;
            }
        
    }
    else
        [self.delegate addItemViewController:self didFinishEnteringItem:indexPath.row];
    //above line takes back to MapsViewController with the selected item
    
    
}

#pragma mark - methods for search feature
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"self contains[c] %@", searchText];
    searchResults = [LocationArray filteredArrayUsingPredicate:resultPredicate];
 
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








//- (IBAction)backAction:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
@end
