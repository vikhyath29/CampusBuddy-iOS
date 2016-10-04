//
//  ContactInfoTableViewController.swift
//  cBuddy
//
//  Created by Kush Taneja on 28/08/16.
//  Copyright © 2016 Kush Taneja. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import MessageUI

class ContactInfoTableViewController: UITableViewController,CNContactViewControllerDelegate, MFMailComposeViewControllerDelegate , MFMessageComposeViewControllerDelegate,UIAlertViewDelegate{
    let contact = CNMutableContact()
    var namedata = String()
    var designationData = String()
    var officemobiledata = String()
    var residancemobiledata = String()
    var LandlineorMobiledata = String()
    var emaildata = String()
    var resdoffstdcode = "0133228 " // std code for roorkee and starting landline
    let std_code_bsnl = "01332"  //std code for roorkee
    var bsnlPhone = ""
    var bsnltocall = ""
    var imagdata = UIImage?()
    var imagrurldata = ""
    var departmentname = ""
    var cells = [String]()


    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.navigationController?.navigationBarHidden = false
        
       
        self.navigationItem.title = "Contact Info"
        
        
        cells.append("Name")
        
        
        if(officemobiledata != "")
        {
            cells.append((resdoffstdcode + officemobiledata).removeWhitespace())
        }
        if(residancemobiledata  != "")
        {
            cells.append((resdoffstdcode + residancemobiledata).removeWhitespace())
        }
        
        if ( LandlineorMobiledata != "" )
           {
            if (String(LandlineorMobiledata[LandlineorMobiledata.startIndex]) == "9" ||  String(LandlineorMobiledata[LandlineorMobiledata.startIndex]) == "8") {
                bsnlPhone = "Mobile: " + LandlineorMobiledata
                bsnltocall = LandlineorMobiledata
                
            }
            else
            {
                bsnlPhone = "BSNL: " + std_code_bsnl + LandlineorMobiledata
                bsnltocall = std_code_bsnl + LandlineorMobiledata
            }
            
            cells.append((bsnltocall).removeWhitespace())
            
        }
        cells.append("Send Message")
        cells.append("Save to Contacts")
        cells.append("Mail ")
        
        func contactViewController(viewController: CNContactViewController, didCompleteWithContact contact: CNContact?) {
            defer{navigationController?.popViewControllerAnimated(true)}
            guard let contact = contact else{
                print("The contact creation was cancelled")
                return
            }
            
            print("Contact was created successfully \(contact)")
        }


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
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
        return cells.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell = UITableViewCell()
        var cello = ContactInfoTableViewCell()
        
        if (indexPath.row == 0)
        {
           cello = tableView.dequeueReusableCellWithIdentifier("ProfCell", forIndexPath: indexPath) as! ContactInfoTableViewCell
            cello.ProfDesignatonLabel.text = designationData
            cello.ProfNameLabel.text = namedata
            cello.ProfNameLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
            cello.ProfDepartmentLabel.text = departmentname
            
            // Check if internet is available before proceeding further
//            if Reachability.isConnectedToNetwork() {
//                
//                
//                cello.WebView.loadRequest(NSURLRequest(URL: NSURL(string: imagrurldata)!))
//                cello.WebView.scalesPageToFit = true
//                cello.WebView.contentMode = .ScaleAspectFit
//                cello.WebView.hidden = false
//                cello.ImageView.hidden = true
//                
//                
//            }
//            else
//            {
            
                
                cello.ImageView.hidden = false
                cello.ImageView.image = UIImage(named: "person.png")
                
            

            return cello
            
        }

        
        
        if ((cells.count == 5 && (indexPath.row == 1)) || (cells.count == 6 && (indexPath.row == 1 || indexPath.row == 2)) || (cells.count == 7 && (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3)))
        {
            cell = tableView.dequeueReusableCellWithIdentifier("CallCell", forIndexPath: indexPath)
            
        }
        else
        
        { cell = tableView.dequeueReusableCellWithIdentifier("SaveCell", forIndexPath: indexPath) }
        
      
        
        if (cells.count == 5)
        {
            
        
            if (indexPath.row == 1)
                
            {
                
                switch cells[1]
                {
                case (resdoffstdcode + officemobiledata).removeWhitespace():
                    cell.textLabel?.text = "Office"
                case (resdoffstdcode + residancemobiledata).removeWhitespace():
                    cell.textLabel?.text = "Residance"
                case (bsnltocall).removeWhitespace():
                    cell.textLabel?.text = "Phone"
                default :
                    cell.textLabel?.text = "Office"
                    
                break
                }
                
                cell.detailTextLabel?.text = cells[1]
              
            }
            else if (indexPath.row == 2)
                
            {
                
                
                if ( officemobiledata != "" || bsnltocall != "" || residancemobiledata != "")
                {
                    cell.textLabel?.text = "Send Message"
                }
                else
                {
                    cell.textLabel?.text = "No Number to Send Message"
                    cell.textLabel?.textColor = UIColor.init(red: CGFloat(128.0/255.0), green:CGFloat(128.0/255.0), blue:CGFloat(128.0/255.0), alpha: CGFloat(1.0))
                    cell.userInteractionEnabled = false
                    
                }
                
             

                
            }
            else if (indexPath.row == 3)
            {
                
                
                
                if ( officemobiledata != "" || bsnltocall != "" || residancemobiledata != "")
                {
                    cell.textLabel?.text = "Save to Contacts"
                }
                else
                {
                    cell.textLabel?.text = "No Contact found"
                    cell.textLabel?.textColor = UIColor.init(red: CGFloat(128.0/255.0), green:CGFloat(128.0/255.0), blue:CGFloat(128.0/255.0), alpha: CGFloat(1.0))
                    cell.userInteractionEnabled = false
                    
                }
                
               
            }
                
            else if (indexPath.row == 4)
            {
                if ( emaildata != "")
                {
                    cell.textLabel?.text = "Mail " + emaildata + "@iitr.ac.in"
                }
                else {
                    
                    cell.textLabel?.text = "No Email found"
                    cell.textLabel?.textColor = UIColor.init(red: CGFloat(128.0/255.0), green:CGFloat(128.0/255.0), blue:CGFloat(128.0/255.0), alpha: CGFloat(1.0))
                    cell.userInteractionEnabled = false
                    
                }
                
          
                
            }
           
            
  
                
                return cell
            
        }
        else if (cells.count == 6)
        {
           
            
            if (indexPath.row == 1)
                
            {
                
                switch cells[1]
                {
                case (resdoffstdcode + officemobiledata).removeWhitespace():
                    cell.textLabel?.text = "Office"
                case (resdoffstdcode + residancemobiledata).removeWhitespace():
                    cell.textLabel?.text = "Residance"
                case (bsnltocall).removeWhitespace():
                    cell.textLabel?.text = "Phone"
                default :
                    cell.textLabel?.text = "Office"
                    
                    break
                }
                
                cell.detailTextLabel?.text = cells[1]
                
                return cell
            }
            else if (indexPath.row == 2)
                
            {
                
                switch cells[2]
                {
                case (resdoffstdcode + officemobiledata).removeWhitespace():
                    cell.textLabel?.text = "Office"
                case (resdoffstdcode + residancemobiledata).removeWhitespace():
                    cell.textLabel?.text = "Residance"
                case (bsnltocall).removeWhitespace():
                    cell.textLabel?.text = "Phone"
                default :
                    cell.textLabel?.text = "Office"
                    
                    break
                }
                
                cell.detailTextLabel?.text = cells[2]
                
                return cell
                
            }
            else if (indexPath.row == 3)
            {
                if ( officemobiledata != "" || bsnltocall != "" || residancemobiledata != "")
                {
                    cell.textLabel?.text = "Send Message"
                }
                else
                {
                    cell.textLabel?.text = "No Number to Send Message"
                    cell.textLabel?.textColor = UIColor.init(red: CGFloat(128.0/255.0), green:CGFloat(128.0/255.0), blue:CGFloat(128.0/255.0), alpha: CGFloat(1.0))
                    cell.userInteractionEnabled = false
                    
                }
                
                return cell
                

                
               
            }
                
            else if (indexPath.row == 4)
            {
                
                if ( officemobiledata != "" || bsnltocall != "" || residancemobiledata != "")
                {
                    cell.textLabel?.text = "Save to Contacts"
                }
                else
                {
                    cell.textLabel?.text = "No Contact found"
                    cell.textLabel?.textColor = UIColor.init(red: CGFloat(128.0/255.0), green:CGFloat(128.0/255.0), blue:CGFloat(128.0/255.0), alpha: CGFloat(1.0))
                    cell.userInteractionEnabled = false
                    
                }
                
                return cell
                
            }
            
            else if (indexPath.row == 5)
            {
            
                if ( emaildata != "")
                {
                    cell.textLabel?.text = "Mail " + emaildata + "@iitr.ac.in"
                }
                else {
                    
                    cell.textLabel?.text = "No Email found"
                    cell.textLabel?.textColor = UIColor.init(red: CGFloat(128.0/255.0), green:CGFloat(128.0/255.0), blue:CGFloat(128.0/255.0), alpha: CGFloat(1.0))
                    cell.userInteractionEnabled = false
                    
                }
                
                return cell

            
            }
            
            
            
            else {
                
                return cell
            }
            
        }
        else if (cells.count == 7)
        {
            if (indexPath.row == 1)
                
            {
                            switch cells[1]
                {
                case (resdoffstdcode + officemobiledata).removeWhitespace():
                    cell.textLabel?.text = "Office"
                case (resdoffstdcode + residancemobiledata).removeWhitespace():
                    cell.textLabel?.text = "Residance"
                case (bsnltocall).removeWhitespace():
                    cell.textLabel?.text = "Phone"
                default :
                    cell.textLabel?.text = "Office"
                    
                    break
                }
                
                cell.detailTextLabel?.text = cells[1]
                
                return cell
            }
            else if (indexPath.row == 2)
                
            {
                
                switch cells[2]
                {
                case (resdoffstdcode + officemobiledata).removeWhitespace():
                    cell.textLabel?.text = "Office"
                case (resdoffstdcode + residancemobiledata).removeWhitespace():
                    cell.textLabel?.text = "Residance"
                case (bsnltocall).removeWhitespace():
                    cell.textLabel?.text = "Phone"
                default :
                    cell.textLabel?.text = "Office"
                    
                    break
                }
                
                cell.detailTextLabel?.text = cells[2]
                
                return cell
                
            }
            else if ( indexPath.row == 3)
                
            {
                
                switch cells[3]
                {
                case (resdoffstdcode + officemobiledata).removeWhitespace():
                    cell.textLabel?.text = "Office"
                case (resdoffstdcode + residancemobiledata).removeWhitespace():
                    cell.textLabel?.text = "Residance"
                case (bsnltocall).removeWhitespace():
                    cell.textLabel?.text = "Phone"
                default :
                    cell.textLabel?.text = "Office"
                    
                    break
                }
                
                cell.detailTextLabel?.text = cells[3]
                
                return cell
            
            }
            else if (indexPath.row == 4)
            {
                if ( officemobiledata != "" || bsnltocall != "" || residancemobiledata != "")
                {
                    cell.textLabel?.text = "Send Message"
                }
                else
                {
                    cell.textLabel?.text = "No Number to Send Message"
                    cell.textLabel?.textColor = UIColor.init(red: CGFloat(128.0/255.0), green:CGFloat(128.0/255.0), blue:CGFloat(128.0/255.0), alpha: CGFloat(1.0))
                    cell.userInteractionEnabled = false
                    
                }
                
                return cell
                
                
                
                
            }
                
            else if (indexPath.row == 5)
            {
                
                if ( officemobiledata != "" || bsnltocall != "" || residancemobiledata != "")
                {
                    cell.textLabel?.text = "Save to Contacts"
                }
                else
                {
                    cell.textLabel?.text = "No Contact found"
                    cell.textLabel?.textColor = UIColor.init(red: CGFloat(128.0/255.0), green:CGFloat(128.0/255.0), blue:CGFloat(128.0/255.0), alpha: CGFloat(1.0))
                    cell.userInteractionEnabled = false
                    
                }
                
                return cell
                
            }
                
            else if (indexPath.row == 6)
            {
                
                if ( emaildata != "")
                {
                    cell.textLabel?.text = "Mail " + emaildata + "@iitr.ac.in"
                }
                else {
                    
                    cell.textLabel?.text = "No Email found"
                    cell.textLabel?.textColor = UIColor.init(red: CGFloat(128.0/255.0), green:CGFloat(128.0/255.0), blue:CGFloat(128.0/255.0), alpha: CGFloat(1.0))
                    cell.userInteractionEnabled = false
                    
                }
                
                return cell
                
            }
        
        else {
            
            return cell
        }

        }
        else {
            
            return cell
        }
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (cells.count == 5)
        {
            if ( indexPath.row == 0)
            {
                
            }
            if ( indexPath.row == 1)
            {
                self.callProf(cells[1])

            
            }
            if ( indexPath.row == 2)
            {
                let MessageAlertView = UIAlertController( title: "Send Message", message: "Choose any number to text", preferredStyle: .ActionSheet)
                let number = resdoffstdcode + officemobiledata
                
                let offcieaction = UIAlertAction(title: "Office: " + resdoffstdcode + officemobiledata, style: .Default, handler: { (alert: UIAlertAction!) -> Void in
                    self.messageProf(number)
                })
                let residenceaction = UIAlertAction(title: "Residence: " + resdoffstdcode + residancemobiledata , style: .Default, handler: { (alert: UIAlertAction!) -> Void in
                    self.messageProf(self.resdoffstdcode + self.residancemobiledata)
                    
                })
                
                let mobileaction = UIAlertAction(title: bsnlPhone, style: .Default, handler: { (alert: UIAlertAction!) -> Void in
                    self.messageProf(self.bsnltocall)
                })
                let cancelaction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (alert: UIAlertAction!) -> Void in
                })
                
                if(officemobiledata != "")
                {
                    MessageAlertView.addAction(offcieaction)
                }
                if(residancemobiledata  != "")
                {
                    MessageAlertView.addAction(residenceaction)
                }
                if(LandlineorMobiledata != "")
                {
                    MessageAlertView.addAction(mobileaction)
                }
                MessageAlertView.addAction(cancelaction)
                
                self.presentViewController(MessageAlertView, animated: true, completion: nil)
            
            }
            if ( indexPath.row == 3)
            {
            
                contact.givenName = namedata
                let workemail = CNLabeledValue(label: CNLabelWork, value: emaildata + "@iitr.ac.in")
                contact.emailAddresses = [workemail]
                
                var phonenumbers = [CNLabeledValue]()
                
                let OfficeNumber = CNLabeledValue(
                    label:CNLabelWork,
                    value:CNPhoneNumber(stringValue:resdoffstdcode + officemobiledata))
                
                if (officemobiledata != ""){
                    phonenumbers.append(OfficeNumber)
                }
                let HomeNumber = CNLabeledValue(
                    label:CNLabelHome,
                    value:CNPhoneNumber(stringValue:resdoffstdcode + residancemobiledata))
                
                if (residancemobiledata != ""){
                    phonenumbers.append(HomeNumber)
                }
                phonenumbers.append(CNLabeledValue(
                    label:CNLabelPhoneNumberMain,
                    value:CNPhoneNumber(stringValue:bsnltocall)))
                
                contact.phoneNumbers = phonenumbers
                let store = CNContactStore()
                
                
                
                let controller = CNContactViewController(forContact: contact)
                
                controller.contactStore = store
                
                
                controller.delegate = self.self
                
                
                navigationController?.pushViewController(controller, animated: true)
                

            
            }
            if ( indexPath.row == 4)
            {
                let mailViewController = MFMailComposeViewController()
                let recipent = [emaildata+"@iitr.ac.in"]
                mailViewController.mailComposeDelegate = self
                mailViewController.setToRecipients(recipent)
                self.presentViewController(mailViewController, animated: true, completion: nil)
            }
            
        
        }
        if (cells.count == 6)
        {
        
            if ( indexPath.row == 0)
            {
                
            }
            if ( indexPath.row == 1)
            {
                self.callProf(cells[1])

            }
            if ( indexPath.row == 2)
            {
                self.callProf(cells[2])
                
                
            }
            if ( indexPath.row == 3)
            {
                let MessageAlertView = UIAlertController( title: "Send Message", message: "Choose any number to text", preferredStyle: .ActionSheet)
                let number = resdoffstdcode + officemobiledata
                
                let offcieaction = UIAlertAction(title: "Office: " + resdoffstdcode + officemobiledata, style: .Default, handler: { (alert: UIAlertAction!) -> Void in
                    self.messageProf(number)
                })
                let residenceaction = UIAlertAction(title: "Residence: " + resdoffstdcode + residancemobiledata , style: .Default, handler: { (alert: UIAlertAction!) -> Void in
                    self.messageProf(self.resdoffstdcode + self.residancemobiledata)
                    
                })
                
                let mobileaction = UIAlertAction(title: bsnlPhone, style: .Default, handler: { (alert: UIAlertAction!) -> Void in
                    self.messageProf(self.bsnltocall)
                })
                let cancelaction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (alert: UIAlertAction!) -> Void in
                })
                
                if(officemobiledata != "")
                {
                    MessageAlertView.addAction(offcieaction)
                }
                if(residancemobiledata  != "")
                {
                    MessageAlertView.addAction(residenceaction)
                }
                if(LandlineorMobiledata != "")
                {
                    MessageAlertView.addAction(mobileaction)
                }
                MessageAlertView.addAction(cancelaction)
                
                self.presentViewController(MessageAlertView, animated: true, completion: nil)
                
            }
            if ( indexPath.row == 4)
            {
                
                contact.givenName = namedata
                let workemail = CNLabeledValue(label: CNLabelWork, value: emaildata + "@iitr.ac.in")
                contact.emailAddresses = [workemail]
                
                var phonenumbers = [CNLabeledValue]()
                
                let OfficeNumber = CNLabeledValue(
                    label:CNLabelWork,
                    value:CNPhoneNumber(stringValue:resdoffstdcode + officemobiledata))
                
                if (officemobiledata != ""){
                    phonenumbers.append(OfficeNumber)
                }
                let HomeNumber = CNLabeledValue(
                    label:CNLabelHome,
                    value:CNPhoneNumber(stringValue:resdoffstdcode + residancemobiledata))
                
                if (residancemobiledata != ""){
                    phonenumbers.append(HomeNumber)
                }
                phonenumbers.append(CNLabeledValue(
                    label:CNLabelPhoneNumberMain,
                    value:CNPhoneNumber(stringValue:bsnltocall)))
                
                contact.phoneNumbers = phonenumbers
                let store = CNContactStore()
                
                
                
                let controller = CNContactViewController(forContact: contact)
                
                controller.contactStore = store
                
                
                controller.delegate = self
                
                
                navigationController?.pushViewController(controller, animated: true)
                
                
                
            }
            if ( indexPath.row == 5)
            {
                let mailViewController = MFMailComposeViewController()
                let recipent = [emaildata+"@iitr.ac.in"]
                mailViewController.mailComposeDelegate = self
                mailViewController.setToRecipients(recipent)
                self.presentViewController(mailViewController, animated: true, completion: nil)
            }

        
        
        
        
        
        
        
        
        }
        if (cells.count == 7)
        {
            
            if ( indexPath.row == 0)
            {
                
            }
            if ( indexPath.row == 1)
            {
                self.callProf(cells[1])
                
            }
            if ( indexPath.row == 2)
            {
                self.callProf(cells[2])
                
                
            }
            if ( indexPath.row == 3)
            {
                self.callProf(cells[3])
                
                
            }
            if ( indexPath.row == 4)
            {
                let MessageAlertView = UIAlertController( title: "Send Message", message: "Choose any number to text", preferredStyle: .ActionSheet)
                let number = resdoffstdcode + officemobiledata
                
                let offcieaction = UIAlertAction(title: "Office: " + resdoffstdcode + officemobiledata, style: .Default, handler: { (alert: UIAlertAction!) -> Void in
                    self.messageProf(number)
                })
                let residenceaction = UIAlertAction(title: "Residence: " + resdoffstdcode + residancemobiledata , style: .Default, handler: { (alert: UIAlertAction!) -> Void in
                    self.messageProf(self.resdoffstdcode + self.residancemobiledata)
                    
                })
                
                let mobileaction = UIAlertAction(title: bsnlPhone, style: .Default, handler: { (alert: UIAlertAction!) -> Void in
                    self.messageProf(self.bsnltocall)
                })
                let cancelaction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (alert: UIAlertAction!) -> Void in
                })
                
                if(officemobiledata != "")
                {
                    MessageAlertView.addAction(offcieaction)
                }
                if(residancemobiledata  != "")
                {
                    MessageAlertView.addAction(residenceaction)
                }
                if(LandlineorMobiledata != "")
                {
                    MessageAlertView.addAction(mobileaction)
                }
                MessageAlertView.addAction(cancelaction)
                
                self.presentViewController(MessageAlertView, animated: true, completion: nil)
                
            }
            if ( indexPath.row == 5)
            {
                
                contact.givenName = namedata
                let workemail = CNLabeledValue(label: CNLabelWork, value: emaildata + "@iitr.ac.in")
                contact.emailAddresses = [workemail]
                
                var phonenumbers = [CNLabeledValue]()
                
                let OfficeNumber = CNLabeledValue(
                    label:CNLabelWork,
                    value:CNPhoneNumber(stringValue:resdoffstdcode + officemobiledata))
                
                if (officemobiledata != ""){
                    phonenumbers.append(OfficeNumber)
                }
                let HomeNumber = CNLabeledValue(
                    label:CNLabelHome,
                    value:CNPhoneNumber(stringValue:resdoffstdcode + residancemobiledata))
                
                if (residancemobiledata != ""){
                    phonenumbers.append(HomeNumber)
                }
                phonenumbers.append(CNLabeledValue(
                    label:CNLabelPhoneNumberMain,
                    value:CNPhoneNumber(stringValue:bsnltocall)))
                
                contact.phoneNumbers = phonenumbers
                let store = CNContactStore()
                
                
                
                let controller = CNContactViewController(forContact: contact)
                
                controller.contactStore = store
                
                
                controller.delegate = self
                
                
                navigationController?.pushViewController(controller, animated: true)
                
                
                
            }
            if ( indexPath.row == 6)
            {
                let mailViewController = MFMailComposeViewController()
                let recipent = [emaildata+"@iitr.ac.in"]
                mailViewController.mailComposeDelegate = self
                mailViewController.setToRecipients(recipent)
                self.presentViewController(mailViewController, animated: true, completion: nil)
            }
            
            
            
            
        }
        
        
    }
    
    //Choose your custom row height
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if(indexPath.row == 0) {
            return 100
        }
        else if ((cells.count == 5 && (indexPath.row == 1)) || (cells.count == 6 && (indexPath.row == 1 || indexPath.row == 2)) || (cells.count == 7 && (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3)))
        {
            
        return 54.0;
            
        }
       
        else {
         return 44.0;
        
        }
        
    }
    


    // Call Function
    
    func callProf(number: String)
    {
        UIApplication.sharedApplication().openURL(NSURL(string: "tel://" + number)!)
    }
    //Message Function
    func messageProf(number: String){
        let messageViewontroller = MFMessageComposeViewController()
        let recipents = [number]
        messageViewontroller.recipients = recipents
        messageViewontroller.messageComposeDelegate = self
        self.presentViewController(messageViewontroller, animated: true, completion: nil)
        
        
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
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
