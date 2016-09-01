//
//  DepartmentProfTableViewControllerTableViewController.swift
//  cBuddy
//
//  Created by Kush Taneja on 27/08/16.
//  Copyright © 2016 Kush Taneja. All rights reserved.
//

import UIKit
import LocalAuthentication
import MessageUI
import SystemConfiguration
extension String {
    func replace(string:String, replacement:String) -> String {
        return self.stringByReplacingOccurrencesOfString(string, withString: replacement, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(" ", replacement: "")
    }
}


public class Reachability {
    /**
     * Check if internet connection is available
     */
    class func isConnectedToNetwork() -> Bool {
        var status:Bool = false
        
        let url = NSURL(string: "http://google.com")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "HEAD"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        var response:NSURLResponse?
        do {
            let _ = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response) as NSData?
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        
        if let httpResponse = response as? NSHTTPURLResponse {
            if httpResponse.statusCode == 200 {
                status = true
            }
        }
        return status
    }
}
extension DepartmentProfTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

class DepartmentProfTableViewController: UITableViewController , UIAlertViewDelegate,MFMailComposeViewControllerDelegate , MFMessageComposeViewControllerDelegate {
    let searchController = UISearchController(searchResultsController: nil)
    var ProfContacts = [ProfContactCell]()
    var filterdcontacts = [ProfContactCell]()
    var DepartmentProfcontacts = [NSDictionary]()
    var DepartmentProfs = [String]()
    var DepartmentName = String()
    var resdoffstdcode = "0133228 " // std code for roorkee and starting landline
    let std_code_bsnl = "01332"  //std code for roorkee
    var bsnlPhone = ""
    var LandlineorMobiledata = ""
    var bsnltocall = ""
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
        
        
        
        self.navigationItem.title = DepartmentName
        
       
        
        searchController.dimsBackgroundDuringPresentation = false
        
        definesPresentationContext = true
        
        tableView.tableHeaderView = searchController.searchBar
        
        for i in 0 ..< DepartmentProfcontacts.count
        {
            let profname = DepartmentProfcontacts[i].valueForKey("name") as! String?
            let profdesignation = DepartmentProfcontacts[i].valueForKey("designation") as! String?
            let profoffice = DepartmentProfcontacts[i].valueForKey("iitr_o") as! String?
            let profresidence = DepartmentProfcontacts[i].valueForKey("iitr_r") as! String?
            let profphoneBSNL = DepartmentProfcontacts[i].valueForKey("phoneBSNL") as! String?
            let profemail = DepartmentProfcontacts[i].valueForKey("email") as! String?
            let profprofilePic = DepartmentProfcontacts[i].valueForKey("profilePic") as! String?
            
            
            
            ProfContacts.append(ProfContactCell(namedata: profname, designationdata: profdesignation, officedata: profoffice, residencedata: profresidence, phoneBSNLdata: profphoneBSNL, emaildata: profemail, profilePicdata: profprofilePic))
            
            
        }
        
        ProfContacts.sortInPlace{$0.name < $1.name}
        self.tableView.reloadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
    func loadImageFromUrl(url: String) -> UIImage{
        // Create Url from string
        let url = NSURL(string: url)!
        var image = UIImage()
        // Download task:
        // - sharedSession = global NSURLCache, NSHTTPCookieStorage and NSURLCredentialStorage objects.
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (responseData, responseUrl, error) -> Void in
            // if responseData is not null...
            if let data = responseData{
                
                // execute in UI thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                   image = UIImage(data: data)!
                })
            }
        }
        
        // Run task
        task.resume()
        return image
    
    
    }
    override func viewDidAppear(animated: Bool) {
         searchController.searchBar.tintColor = UIColor(red:248.0/255.0 , green: 150.0/255.0, blue: 34.0/255.0, alpha: 1)
        searchController.searchBar.barTintColor = UIColor(red:92.0/255.0 , green: 69.0/255.0, blue: 48.0/255.0, alpha: 1)
    }

    
    override func viewWillAppear(animated: Bool) {
        searchController.searchBar.tintColor = UIColor(red:248.0/255.0 , green: 150.0/255.0, blue: 34.0/255.0, alpha: 1)
        searchController.searchBar.barTintColor = UIColor(red:92.0/255.0 , green: 69.0/255.0, blue: 48.0/255.0, alpha: 1)

      

    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.resignFirstResponder()
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        
        filterdcontacts = ProfContacts.filter { ProfContactCell in
            if (ProfContactCell.designation != nil){
                return ProfContactCell.name!.lowercaseString.containsString(searchText.lowercaseString) || ProfContactCell.designation!.lowercaseString.containsString(searchText.lowercaseString)
            }
            else {
                return ProfContactCell.name!.lowercaseString.containsString(searchText.lowercaseString)
            
            }
        }
        self.tableView.reloadData()
        
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
            return filterdcontacts.count
        }
        else
        {
            return ProfContacts.count
            
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ProfContactCell", forIndexPath: indexPath) as! ProfContactTableViewCell
        let contact : ProfContactCell
        if (searchController.active && searchController.searchBar.text != "")
        {
            contact = filterdcontacts[indexPath.row]
        }
        else
        {
            contact = ProfContacts[indexPath.row]
            
        }
        
        cell.ProfessorName.text = contact.name!
        
   
        
//        // Check if internet is available before proceeding further
        if Reachability.isConnectedToNetwork() {
            
            let url = "http://people.iitr.ernet.in/facultyphoto/" + contact.profilePic!
            
            cell.ProfPicWebView.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
            cell.ProfPicWebView.scalesPageToFit = true
            cell.ProfPicWebView.contentMode = .ScaleAspectFit
            cell.ProfPicWebView.hidden = false
            cell.ProfImageView.hidden = true
            
      
              }
        else{
            
            cell.ProfPicWebView.hidden = true
            cell.ProfImageView.hidden = false
         cell.ProfImageView.image = UIImage(named: "ContactInfoThumbnail.png")
            
        }
        if (contact.designation != nil)
        {
            cell.Profdesignation.text = contact.designation!
        }
        
        return cell
    }
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        var contact : ProfContactCell = self.ProfContacts[indexPath.row]
        
        if (self.searchController.active && self.searchController.searchBar.text != "")
        {
            contact = self.filterdcontacts[indexPath.row]
            
        }
        else
        {
        
            contact = self.ProfContacts[indexPath.row]
        
        
        }
        
        
        
        
        
        let call = UITableViewRowAction(style: .Default, title: "Call") { action, index in
            let CallAlertView = UIAlertController( title: "Call", message: "Choose any number to call", preferredStyle: .ActionSheet)
            
            self.LandlineorMobiledata =  contact.phoneBSNL!
            if ( self.LandlineorMobiledata != "" )
            {
                if (String(self.LandlineorMobiledata[self.LandlineorMobiledata.startIndex]) == "9" ||  String(self.LandlineorMobiledata[self.LandlineorMobiledata.startIndex]) == "8") {
                    self.bsnlPhone = "Mobile: " + self.LandlineorMobiledata
                    self.bsnltocall = self.LandlineorMobiledata
                }
                else {
                    self.bsnlPhone = "BSNL: " + self.std_code_bsnl + self.LandlineorMobiledata
                    self.bsnltocall = self.std_code_bsnl + self.LandlineorMobiledata
                }
            }
            

            
            
            
            
            let offcieaction = UIAlertAction(title: "Office: " + (self.resdoffstdcode + contact.office!).removeWhitespace(), style: .Default, handler: { (alert: UIAlertAction!) -> Void in
                self.callProf((self.resdoffstdcode + contact.office!).removeWhitespace())
            })
            let residenceaction = UIAlertAction(title: "Residence: " + (self.resdoffstdcode + contact.residence!).removeWhitespace() , style: .Default, handler: { (alert: UIAlertAction!) -> Void in
                self.callProf((self.resdoffstdcode + contact.residence!).removeWhitespace())
                
            })
            
            let mobileaction = UIAlertAction(title: self.bsnlPhone.removeWhitespace(), style: .Default, handler: { (alert: UIAlertAction!) -> Void in
                self.callProf(self.bsnltocall.removeWhitespace())
            })
            let cancelaction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (alert: UIAlertAction!) -> Void in
            })
            
            if(contact.office! != "")
            {
                CallAlertView.addAction(offcieaction)
            }
            if(contact.residence!  != "")
            {
                CallAlertView.addAction(residenceaction)
            }
            if(self.LandlineorMobiledata != "")
            {
                CallAlertView.addAction(mobileaction)
            }
            CallAlertView.addAction(cancelaction)
            
            self.presentViewController(CallAlertView, animated: true, completion: nil)
//
//            if (self.searchController.active && self.searchController.searchBar.text != "")
//            {
//                
//                UIApplication.sharedApplication().openURL(NSURL(string: "tel://"+"\(self.filterdcontacts[indexPath.row].office!)")!)
//            }
//            else
//            {
//                
//                contact = self.ProfContacts[indexPath.row]
//                
//                UIApplication.sharedApplication().openURL(NSURL(string: "tel://"+"\(contact.office!)")!)
//                
//            }
            
            
        }
        call.backgroundColor = UIColor(red: 248.0/255.0, green: 150.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        
        let message = UITableViewRowAction(style: .Normal, title: "Message") { action, index in
            let messageViewontroller = MFMessageComposeViewController()
            var recipents = [String]()
            
            self.LandlineorMobiledata =  contact.phoneBSNL!
            if ( self.LandlineorMobiledata != "" )
            {
                if (String(self.LandlineorMobiledata[self.LandlineorMobiledata.startIndex]) == "9" ||  String(self.LandlineorMobiledata[self.LandlineorMobiledata.startIndex]) == "8") {
                    self.bsnlPhone = "Mobile: " + self.LandlineorMobiledata
                    self.bsnltocall = self.LandlineorMobiledata
                }
                else {
                    self.bsnlPhone = "BSNL: " + self.std_code_bsnl + self.LandlineorMobiledata
                    self.bsnltocall = self.std_code_bsnl + self.LandlineorMobiledata
                } }

            
            if (self.searchController.active && self.searchController.searchBar.text != "")
            {
                
                contact = self.filterdcontacts[indexPath.row]
            }
            else
            {
                
                contact = self.ProfContacts[indexPath.row]
                
            }
            
            let MessageAlertView = UIAlertController( title: "Send Message", message: "Choose any number to text", preferredStyle: .ActionSheet)
            let number = self.resdoffstdcode + contact.office!
            
            let offcieaction = UIAlertAction(title: "Office: " + self.resdoffstdcode + contact.office!, style: .Default, handler: { (alert: UIAlertAction!) -> Void in
                self.messageProf(number)
            })
            let residenceaction = UIAlertAction(title: "Residence: " + self.resdoffstdcode + contact.residence! , style: .Default, handler: { (alert: UIAlertAction!) -> Void in
                self.messageProf(self.resdoffstdcode + contact.residence!)
                
            })
            
            let mobileaction = UIAlertAction(title: self.bsnlPhone, style: .Default, handler: { (alert: UIAlertAction!) -> Void in
                self.messageProf(self.bsnltocall)
            })
            let cancelaction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (alert: UIAlertAction!) -> Void in
            })
            
            if(contact.office! != "")
            {
                MessageAlertView.addAction(offcieaction)
            }
            if(contact.residence!  != "")
            {
                MessageAlertView.addAction(residenceaction)
            }
            if(self.LandlineorMobiledata != "")
            {
                MessageAlertView.addAction(mobileaction)
            }
            MessageAlertView.addAction(cancelaction)
            
            self.presentViewController(MessageAlertView, animated: true, completion: nil)
            
//            recipents = ["\(contact.office!)"]
//            messageViewontroller.recipients = recipents
//            messageViewontroller.messageComposeDelegate = self
//            self.presentViewController(messageViewontroller, animated: true, completion: nil)
        }
        
        message.backgroundColor = UIColor(red: 92.0/255.0, green: 69.0/255.0, blue: 48.0/255.0, alpha: 1.0)
        
        
        
        let mail = UITableViewRowAction(style: .Normal, title: "Mail") { action, index in
            var recipents = [String]()
            
            let mailViewController = MFMailComposeViewController()
            
            if (self.searchController.active && self.searchController.searchBar.text != "")
            {
                
                contact = self.filterdcontacts[indexPath.row]
            }
            else{
                
                contact = self.ProfContacts[indexPath.row]
            }
            
            
                recipents = ["\(contact.email!)"]
                mailViewController.mailComposeDelegate = self
                mailViewController.setToRecipients(recipents)
                
        if (contact.email != "")
           {
            self.presentViewController(mailViewController, animated: true, completion: nil)
            }
        else {
            let  passwordAlert = UIAlertController(title: "No Email Found", message: "Sorry , Cannot Mail :(", preferredStyle: UIAlertControllerStyle.Alert)
            
            
            passwordAlert.addAction(UIAlertAction(title: "Ok", style: .Destructive, handler: { action in
            
            }))
            
            self.presentViewController(passwordAlert, animated: true, completion: nil)

            
            }
        
            
            
            
            
        }
        mail.backgroundColor = UIColor(red: 248.0/255.0, green: 150.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        
        return [mail,message,call]
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return true
    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
    }
    
    func callProf(number: String)
    {
        UIApplication.sharedApplication().openURL(NSURL(string: "tel://" + number)!)
    }
    
    func messageProf(number: String)
    {
        let messageViewontroller = MFMessageComposeViewController()
        let recipents = [number]
        messageViewontroller.recipients = recipents
        messageViewontroller.messageComposeDelegate = self
        self.presentViewController(messageViewontroller, animated: true, completion: nil)
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        
        if (segue.identifier == "ShowProfContact")
            
        {
            
            let ContactView = segue.destinationViewController as! ContactInfoTableViewController
            if let indexPath = self.tableView.indexPathForSelectedRow
                
            {
                let contact : ProfContactCell
                if (searchController.active && searchController.searchBar.text != "")
                {
                    contact = filterdcontacts[indexPath.row]
                }
                else {
                    
                    contact = ProfContacts[indexPath.row]
                    
                }
                
                let url = "http://people.iitr.ernet.in/facultyphoto/" + contact.profilePic!
            
                
           
                ContactView.namedata = contact.name!
                ContactView.LandlineorMobiledata = "\(contact.phoneBSNL!)"
                ContactView.officemobiledata = "\(contact.office!)"
                ContactView.residancemobiledata = "\(contact.residence!)"
                ContactView.designationData = contact.designation!
                ContactView.emaildata = contact.email!
                ContactView.imagrurldata = url
                
                
                
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

