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
    var Professors = [ProfContactCell]()
    var filterdepartments = [DepartmentCell]()
    var filterProfessors = [ProfContactCell]()
    var resdoffstdcode = "0133228 " // std code for roorkee and starting landline
    let std_code_bsnl = "01332"  //std code for roorkee
    var LandlineorMobiledata = ""
    var bsnlPhone = ""
    var bsnltocall = ""
    
    
    @IBOutlet var Switch : UISegmentedControl!
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
        
        
        if (searchController.active && searchController.searchBar.text != ""){
            self.navigationController?.navigationBar.hidden = false
            searchController.searchBar.hidden = false
        }
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.backgroundColor = UIColor(red:92.0/255.0 , green: 59.0/255.0, blue: 181.0/255.0, alpha: 1)
        searchController.searchBar.tintColor = UIColor(red:255.0/255.0 , green: 255.0/255.0, blue: 255.0/255.0, alpha: 1)
        searchController.searchBar.barTintColor = UIColor(red:92.0/255.0 , green: 59.0/255.0, blue: 181.0/255.0, alpha: 1)
        searchController.searchBar.inputView?.tintColor =  UIColor(red:255.0/255.0 , green: 255.0/255.0, blue: 255.0/255.0, alpha: 1)
        searchController.searchBar.inputView?.backgroundColor =  UIColor(red:92.0/255.0 , green: 59.0/255.0, blue: 181.0/255.0, alpha: 1)
        
        
        
        
        
        searchController.dimsBackgroundDuringPresentation = false
        
        definesPresentationContext = true
        
        tableView.tableHeaderView = searchController.searchBar
        
        jsonParsingFromFile()
        
        
        for i in 0 ..< DepartmentsArray.count
        {
            let departmentname = DepartmentsArray[i].valueForKey("name") as! String
            let photourl = DepartmentsArray[i].valueForKey("photo") as! String
            var departmentContacts = DepartmentsArray[i].valueForKey("contacts") as! [NSMutableDictionary]
            Departments.append(DepartmentCell(Departmentname:departmentname , DepartmentPhotourl: photourl, Departmentcontacts: departmentContacts))
            
            for j in 0..<departmentContacts.count
            {
                
                let profname = departmentContacts[j].valueForKey("name") as! String?
                let profdesignation = departmentContacts[j].valueForKey("designation") as! String?
                let profoffice = departmentContacts[j].valueForKey("iitr_o") as! String?
                let profresidence = departmentContacts[j].valueForKey("iitr_r") as! String?
                let profphoneBSNL = departmentContacts[j].valueForKey("phoneBSNL") as! String?
                let profemail = departmentContacts[j].valueForKey("email") as! String?
                let profprofilePic = departmentContacts[j].valueForKey("profilePic") as! String?
                
                Professors.append(ProfContactCell(namedata: profname, designationdata: profdesignation, officedata: profoffice, residencedata: profresidence, phoneBSNLdata: profphoneBSNL, emaildata: profemail, profilePicdata: profprofilePic, department: departmentname))
                
                
            }
            
            
        }
        
        
        
        Departments.sortInPlace{$0.DepartmentNAME < $1.DepartmentNAME}
        
        Professors.sortInPlace{$0.name < $1.name}
        
        
        self.tableView.reloadData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.resignFirstResponder()
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        
        
        filterProfessors = Professors.filter {
            Professor in
            return Professor.name!.lowercaseString.containsString(searchText.lowercaseString) || Professor.profdepartment!.lowercaseString.containsString(searchText.lowercaseString)
        }
        self.tableView.reloadData()
        
        
    }
    
    //   func loadImageFromUrl(url: String, view: UIImageView){
    //
    //        // Create Url from string
    //        let url = NSURL(string: url)!
    //
    //        // Download task:
    //        // - sharedSession = global NSURLCache, NSHTTPCookieStorage and NSURLCredentialStorage objects.
    //        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (responseData, responseUrl, error) -> Void in
    //            // if responseData is not null...
    //            if let data = responseData{
    //
    //                // execute in UI thread
    //                dispatch_async(dispatch_get_main_queue(), { () -> Void in
    //                    view.image = UIImage(data: data)
    //                })
    //            }
    //        }
    //
    //        // Run task
    //        task.resume()
    //    }
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
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        if (searchController.active && searchController.searchBar.text != "")
        {
            return filterProfessors.count
        }
        else
        {
            switch Switch.selectedSegmentIndex
            {
            case 0:
                return Departments.count
                
            case 1:
                return Professors.count
            default:
                return 0
                
            }
        }
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("DepartmentCell", forIndexPath: indexPath) as! DepartmentTableViewCell
        let Department : DepartmentCell
        var Professor : ProfContactCell
        if (searchController.active && searchController.searchBar.text != "")
        {
            Professor = filterProfessors[indexPath.row]
            cell.Subtitle.hidden = false
            cell.Title.text = Professor.name
            cell.Subtitle.text = Professor.profdepartment
            cell.DepartmentIamegView.image = UIImage(named: "person.png")
        }
        else
        {
            switch Switch.selectedSegmentIndex
            {
            case 0:
                cell.Subtitle.hidden = true
                Department = Departments[indexPath.row]
                cell.Title.text = Department.DepartmentNAME
                cell.DepartmentIamegView.image = UIImage(named: "department.png")
                
            case 1:
                cell.Subtitle.hidden = false
                Professor = Professors[indexPath.row]
                
                cell.Title.text = Professor.name
                cell.Subtitle.text = Professor.profdepartment
                cell.DepartmentIamegView.image = UIImage(named: "person.png")
                
            default:
                cell.Title.text = ""
            }
        }
        
        
        // Check if internet is available before proceeding further
        //        if Reachability.isConnectedToNetwork() {
        //        let url = "http://www.iitr.ac.in/departments/" + Department.DepartmentPhotoUrl + "/assets/images/top1.jpg"
        //        cell.DepartmentPic.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
        //
        //            cell.DepartmentPic.scalesPageToFit = true
        //            cell.DepartmentPic.contentMode = .ScaleAspectFit
        //            cell.DepartmentPic.hidden = false
        //            cell.DepartmentIamegView.hidden = true
        //
        //
        //        }
        //        else
        //        {
        
        cell.DepartmentIamegView.hidden = false
        
        
        
        return cell
    }
    
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
    }
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        
        if ((identifier == "ShowDepartmentContacts" && Switch.selectedSegmentIndex == 1 ))
        {   performSegueWithIdentifier("ShowAZProf", sender: UITableViewCell.self)
            return false
        }
        else if ((identifier == "ShowDepartmentContacts" && searchController.active && searchController.searchBar.text != ""))
        {   performSegueWithIdentifier("ShowAZProf", sender: UITableViewCell.self)
            return false
        }
        else{
            return true
        }
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
        if(segue.identifier == "ShowAZProf")
        {
            
            let ContactView = segue.destinationViewController as! ContactInfoTableViewController
            if let indexPath = self.tableView.indexPathForSelectedRow
                
            {
                let contact : ProfContactCell
                if (searchController.active && searchController.searchBar.text != "")
                {
                    contact = filterProfessors[indexPath.row]
                }
                else
                {
                    contact = Professors[indexPath.row]
                    
                }
                
                let url = "http://people.iitr.ernet.in/facultyphoto/" + contact.profilePic!
                
                
                
                ContactView.namedata = contact.name!
                ContactView.LandlineorMobiledata = "\(contact.phoneBSNL!)"
                ContactView.officemobiledata = "\(contact.office!)"
                ContactView.residancemobiledata = "\(contact.residence!)"
                ContactView.designationData = contact.designation!
                ContactView.emaildata = contact.email!
                ContactView.imagrurldata = url
                ContactView.departmentname = contact.profdepartment!
                
                
                
            }
        }
        
    }
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        var contact : ProfContactCell
        if (searchController.active && searchController.searchBar.text != "")
        {
            contact = filterProfessors[indexPath.row]
        }
        else
        {
            contact = Professors[indexPath.row]
            
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
        call.backgroundColor = UIColor(red: 0.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        
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
                contact = self.filterProfessors[indexPath.row]
            }
            else
            {
                contact = self.Professors[indexPath.row]
                
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
        
        message.backgroundColor = UIColor(red:92.0/255.0 , green: 59.0/255.0, blue: 181.0/255.0, alpha: 1)
        
        
        
        let mail = UITableViewRowAction(style: .Normal, title: "Mail") { action, index in
            var recipents = [String]()
            
            let mailViewController = MFMailComposeViewController()
            
            if (self.searchController.active && self.searchController.searchBar.text != "")
            {
                contact = self.filterProfessors[indexPath.row]
            }
            else
            {
                contact = self.Professors[indexPath.row]
                
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
        mail.backgroundColor = UIColor(red: 0.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        
        return [mail,message,call]
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if (searchController.active && searchController.searchBar.text != "")
        {
            return true
        }
        else
            
        {
            switch Switch.selectedSegmentIndex
            {
            case 0:
                return false
            case 1:
                return true
            default:
                return false
                
            }
        }
        
        
        
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
    
    
    @IBAction func SwitchChanged(sender: AnyObject) {
        
        self.tableView.reloadData()
    }
    
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
