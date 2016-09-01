//
//  DepartmentsTableViewController.swift
//  cBuddy
//
//  Created by Kush Taneja on 27/08/16.
//  Copyright © 2016 Kush Taneja. All rights reserved.
//


import UIKit
import LocalAuthentication
import MessageUI
extension DepartmentsTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

class DepartmentsTableViewController: UITableViewController , UIAlertViewDelegate,MFMailComposeViewControllerDelegate , MFMessageComposeViewControllerDelegate {
    var DepartmentsArray :NSMutableArray = []
    let searchController = UISearchController(searchResultsController: nil)
    var Departments = [DepartmentCell]()
    var filterdepartments = [DepartmentCell]()
    
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if (searchController.active && searchController.searchBar.text != ""){
            self.navigationController?.navigationBar.hidden = false
            searchController.searchBar.hidden = false
        }
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.backgroundColor = UIColor(red:92.0/255.0 , green: 69.0/255.0, blue: 48.0/255.0, alpha: 1)
        searchController.searchBar.tintColor = UIColor(red:248.0/255.0 , green: 150.0/255.0, blue: 34.0/255.0, alpha: 1)
        searchController.searchBar.barTintColor = UIColor(red:92.0/255.0 , green: 69.0/255.0, blue: 48.0/255.0, alpha: 1)
        searchController.searchBar.inputView?.tintColor =  UIColor(red:248.0/255.0 , green: 150.0/255.0, blue: 34.0/255.0, alpha: 1)
        searchController.searchBar.inputView?.backgroundColor =  UIColor(red:92.0/255.0 , green: 69.0/255.0, blue: 48.0/255.0, alpha: 1)
        
        
        
        
        
        
        searchController.dimsBackgroundDuringPresentation = false
        
        definesPresentationContext = true
        
        tableView.tableHeaderView = searchController.searchBar
        
        jsonParsingFromFile()
        
        for i in 0 ..< DepartmentsArray.count
        {
            let departmentname = DepartmentsArray[i].valueForKey("name") as! String
            let photourl = DepartmentsArray[i].valueForKey("photo") as! String
            let departmentContacts = DepartmentsArray[i].valueForKey("contacts") as! [NSDictionary]
            Departments.append(DepartmentCell(Departmentname:departmentname , DepartmentPhotourl: photourl, Departmentcontacts: departmentContacts))
            
            
        }
        
        Departments.sortInPlace{$0.DepartmentNAME < $1.DepartmentNAME}
        
        self.tableView.reloadData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.resignFirstResponder()
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        
        filterdepartments = Departments.filter {
            DepartmentCell in
            return DepartmentCell.DepartmentNAME.lowercaseString.containsString(searchText.lowercaseString)
        }
        self.tableView.reloadData()
      
        
    }
   func loadImageFromUrl(url: String, view: UIImageView){
        
        // Create Url from string
        let url = NSURL(string: url)!
        
        // Download task:
        // - sharedSession = global NSURLCache, NSHTTPCookieStorage and NSURLCredentialStorage objects.
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (responseData, responseUrl, error) -> Void in
            // if responseData is not null...
            if let data = responseData{
                
                // execute in UI thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    view.image = UIImage(data: data)
                })
            }
        }
        
        // Run task
        task.resume()
    }
    func jsonParsingFromFile()
    {
        
        let path: NSString = NSBundle.mainBundle().pathForResource("ProfessorContactatIItR", ofType: ".json")!
        let Departmentdata : NSData = try! NSData(contentsOfFile: path as String, options: NSDataReadingOptions.DataReadingMapped)
        
        let jsonarray: NSArray!=(try! NSJSONSerialization.JSONObjectWithData(Departmentdata, options: NSJSONReadingOptions.MutableContainers)) as! NSArray
        DepartmentsArray = jsonarray as! NSMutableArray
        
        
    }
    
    
    
    
    
    
    
    override  func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (searchController.active && searchController.searchBar.text != "")
        {
            return filterdepartments.count
        }
        else
        {
            
            return Departments.count
        }
        
        
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("DepartmentCell", forIndexPath: indexPath) as! DepartmentTableViewCell
        let Department : DepartmentCell
        if (searchController.active && searchController.searchBar.text != "")
        {
            Department = filterdepartments[indexPath.row]
        }
        else
        {
            Department = Departments[indexPath.row]
            
        }
        cell.DepartmentName.text = Department.DepartmentNAME
        // Check if internet is available before proceeding further
        if Reachability.isConnectedToNetwork() {
        let url = "http://www.iitr.ac.in/departments/" + Department.DepartmentPhotoUrl + "/assets/images/top1.jpg"
        cell.DepartmentPic.loadRequest(NSURLRequest(URL: NSURL(string: url)!))

            cell.DepartmentPic.scalesPageToFit = true
            cell.DepartmentPic.contentMode = .ScaleAspectFit
            cell.DepartmentPic.hidden = false
            cell.DepartmentIamegView.hidden = true
            
            
        }
        else
        {
            
            cell.DepartmentPic.hidden = true
            cell.DepartmentIamegView.hidden = false
            cell.DepartmentIamegView.image = UIImage(named: "ContactInfoThumbnail.png")
            
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return true
    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        
        if (segue.identifier == "ShowDepartmentContacts")
        { let ProfListView = segue.destinationViewController as! DepartmentProfTableViewController
            if let indexPath = self.tableView.indexPathForSelectedRow
                
            {
                let Department : DepartmentCell
                if (searchController.active && searchController.searchBar.text != "")
                {
                    Department = filterdepartments[indexPath.row]
                }
                else {
                    Department = Departments[indexPath.row]
                    
                }
                ProfListView.DepartmentProfcontacts = Department.DepartmentContacts
                ProfListView.DepartmentName = Department.DepartmentNAME
                
            }
            
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        switch result.rawValue {
        case MFMailComposeResultSent.rawValue:
            print("sent")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MFMailComposeResultSaved.rawValue:
            print("saved")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MFMailComposeResultFailed.rawValue:
            print("failed")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MFMailComposeResultCancelled.rawValue:
            print("cancelled")
            self.dismissViewControllerAnimated(true, completion: nil)
        default:break
            
        }
    }
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        
        switch result.rawValue {
        case MFMailComposeResultSent.rawValue:
            print("sent")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MFMailComposeResultSaved.rawValue:
            print("saved")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MFMailComposeResultFailed.rawValue:
            print("failed")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MFMailComposeResultCancelled.rawValue:
            print("cancelled")
            self.dismissViewControllerAnimated(true, completion: nil)
        default:break
        }
    }
    
    
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
