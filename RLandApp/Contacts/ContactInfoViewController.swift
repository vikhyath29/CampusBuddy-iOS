//
//  ContactInfoViewController.swift
//  IITR Contacts
//
//  Created by Kush Taneja on 08/08/16.
//  Copyright © 2016 Kush Taneja. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import MessageUI

class ContactInfoViewController: UIViewController, CNContactViewControllerDelegate,UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate , MFMessageComposeViewControllerDelegate,UIAlertViewDelegate {
    
    @IBOutlet var ProfilePicVIew: UIImageView!
    @IBOutlet var NameLabel: UILabel!
    @IBOutlet var BranchLabel: UILabel!
    @IBOutlet var ViusalBlur: UIVisualEffectView!

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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor(red:248.0/255.0 , green: 150.0/255.0, blue: 34.0/255.0, alpha: 1)
        self.navigationController?.navigationBar.backgroundColor = UIColor(red:92.0/255.0 , green: 69.0/255.0, blue: 48.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Default

         self.navigationController?.navigationBarHidden = false
         self.navigationItem.title = namedata
        
        NameLabel.text = namedata
        BranchLabel.text = designationData
        if (imagdata != nil){
            ProfilePicVIew.image = imagdata }
        else{
        ProfilePicVIew.image = UIImage(named: "ContactInfoThumbnail.png")
        }
        ProfilePicVIew.reloadInputViews()
       if ( LandlineorMobiledata != "" )
        {
        if (String(LandlineorMobiledata[LandlineorMobiledata.startIndex]) == "9" ||  String(LandlineorMobiledata[LandlineorMobiledata.startIndex]) == "8") {
            bsnlPhone = "Mobile: " + LandlineorMobiledata
            bsnltocall = LandlineorMobiledata
        }
        else {
            bsnlPhone = "BSNL: " + std_code_bsnl + LandlineorMobiledata
            bsnltocall = std_code_bsnl + LandlineorMobiledata
        }

    
        }
       
        
        
                
        // Do any additional setup after loading the view.
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func contactViewController(viewController: CNContactViewController, didCompleteWithContact contact: CNContact?) {
        defer{navigationController?.popViewControllerAnimated(true)}
        guard let contact = contact else{
            print("The contact creation was cancelled")
            return
        }
        
        print("Contact was created successfully \(contact)")
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Save", forIndexPath: indexPath)
        if (indexPath.row == 0)
        {
            cell.textLabel?.text = "Save to Contacts"
        }
        else if (indexPath.row == 1)
        { if (officemobiledata != "" || bsnltocall != "" || residancemobiledata != "") {
            cell.textLabel?.text = "Call"}
        else {
            cell.textLabel?.text = "No Number to Call"
            cell.textLabel?.textColor = UIColor.init(red: CGFloat(128.0/255.0), green:CGFloat(128.0/255.0), blue:CGFloat(128.0/255.0), alpha: CGFloat(1.0))
            cell.userInteractionEnabled = false
            
            
            }
            
        }
        else if (indexPath.row == 2) {
            if ( officemobiledata != "" || bsnltocall != "" || residancemobiledata != ""){
                cell.textLabel?.text = "Send Message"}
            else {
                cell.textLabel?.text = "No Number to Send Message"
                cell.textLabel?.textColor = UIColor.init(red: CGFloat(128.0/255.0), green:CGFloat(128.0/255.0), blue:CGFloat(128.0/255.0), alpha: CGFloat(1.0))
                cell.userInteractionEnabled = false
                
                
            }
        }
            
        else {
            if ( emaildata != ""){
                cell.textLabel?.text = "Mail " + emaildata + "@iitr.ac.in" }
            else {
                
                cell.textLabel?.text = "No Email to Mail"
                cell.textLabel?.textColor = UIColor.init(red: CGFloat(128.0/255.0), green:CGFloat(128.0/255.0), blue:CGFloat(128.0/255.0), alpha: CGFloat(1.0))
                cell.userInteractionEnabled = false
                
                
            }
            
        }
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if ( indexPath.row == 0)
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
                label:CNLabelWork,
                value:CNPhoneNumber(stringValue:resdoffstdcode + residancemobiledata))
            
            if (residancemobiledata != ""){
                phonenumbers.append(HomeNumber)
            }
            phonenumbers.append(CNLabeledValue(
                label:CNLabelPhoneNumberMain,
                value:CNPhoneNumber(stringValue:bsnltocall)))
            
            contact.phoneNumbers = phonenumbers
            let store = CNContactStore()
            let controller = CNContactViewController(forNewContact: contact)
            controller.contactStore = store
            controller.delegate = self
            navigationController?
                .pushViewController(controller, animated: true)
            
        }
        else if (indexPath.row == 1)
        {
            let CallAlertView = UIAlertController( title: "Call", message: "Choose any number to call", preferredStyle: .ActionSheet)
          
            
            
            let offcieaction = UIAlertAction(title: "Office: " + (resdoffstdcode + officemobiledata).removeWhitespace(), style: .Default, handler: { (alert: UIAlertAction!) -> Void in
                self.callProf((self.resdoffstdcode + self.officemobiledata).removeWhitespace())
            })
            let residenceaction = UIAlertAction(title: "Residence: " + (resdoffstdcode + residancemobiledata).removeWhitespace() , style: .Default, handler: { (alert: UIAlertAction!) -> Void in
                self.callProf((self.resdoffstdcode + self.residancemobiledata).removeWhitespace())
                
            })
            
            let mobileaction = UIAlertAction(title: bsnlPhone.removeWhitespace(), style: .Default, handler: { (alert: UIAlertAction!) -> Void in
                self.callProf(self.bsnltocall.removeWhitespace())
            })
            let cancelaction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (alert: UIAlertAction!) -> Void in
            })
            
            if(officemobiledata != "")
            {
                CallAlertView.addAction(offcieaction)
            }
            if(residancemobiledata  != "")
            {
                CallAlertView.addAction(residenceaction)
            }
            if(LandlineorMobiledata != "")
            {
                CallAlertView.addAction(mobileaction)
            }
            CallAlertView.addAction(cancelaction)
            
            self.presentViewController(CallAlertView, animated: true, completion: nil)
            
        }
        else if (indexPath.row == 2)
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
        else
        {
            let mailViewController = MFMailComposeViewController()
            let recipent = [emaildata+"@iitr.ac.in"]
            mailViewController.mailComposeDelegate = self
            mailViewController.setToRecipients(recipent)
            self.presentViewController(mailViewController, animated: true, completion: nil)
            
            
            
        }
        
        
        
    }
    func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    
    



    func callProf(number: String){
       UIApplication.sharedApplication().openURL(NSURL(string: "tel://" + number)!)
    }
    func messageProf(number: String){
        let messageViewontroller = MFMessageComposeViewController()
        let recipents = [number]
        messageViewontroller.recipients = recipents
        messageViewontroller.messageComposeDelegate = self
        self.presentViewController(messageViewontroller, animated: true, completion: nil)
    
    
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
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
