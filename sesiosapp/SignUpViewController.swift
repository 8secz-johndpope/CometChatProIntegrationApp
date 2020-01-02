//
//  SignUpViewController.swift
//  sesiosnativeapp
//
//  Created by Vaibhav on 15/03/17.
//  Copyright © 2017 SocialEngineSolutions. All rights reserved.
//

import Foundation

class SignUpViewController: FXFormViewController {
    var dataDictionary: NSMutableArray!
   var hiddenField = Dictionary<String, String>()
   var selectedCustomForm:CustomForm!
   var resources_type:String = ""
   var resources_id:Int = 0
   var paramsPost = Dictionary<String, String>()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.title = "SignUp"
       
        getSignupFormData()
    }
    func termsCondition(_ cell: FXFormFieldCellProtocol) {
        let pVC = TermsHelpViewController()
        pVC.siteTitle = "Terms of Service"
        pVC.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        let navigationController = UINavigationController(rootViewController: pVC)
        if #available(iOS 13.0, *) {
                       navigationController.isModalInPresentation = true
                       navigationController.modalPresentationStyle = .fullScreen
                   } else {
                       // Fallback on earlier versions
                   }
        self.present(navigationController, animated: true, completion: nil)
    }
    func changeFields(_ cell: FXFormFieldCellProtocol) {
    }
    func submitForm(_ cell: FXFormFieldCellProtocol) {
        let form = cell.field.form as! CustomForm
        paramsPost = [String:String]()
        for (key, value) in form.valuesByKey{
            if let keyOption = multiOptionsData["\(key)"]{
                paramsPost["\(key)"] = getValueForValueKey(keyOption,fieldValue: ("\(value)"))
            }else{
                paramsPost["\(key)"] = "\(value)"
            }
        }
        if Reachability.isConnectedToNetwork() {
            self.view.isUserInteractionEnabled = false
           // animator.center = self.view.center
            
            
          //  animator.startAnimating()
           // self.view.addSubview(animator)
            let imageData = Data()
            paramsPost["validateAccountForm"] = "1"
            sendRequest(paramsPost as Dictionary<String, AnyObject>, url: "signup", method: "POST",image:imageData) { (succeeded) -> () in
                DispatchQueue.main.async(execute: {
                   // self.animator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    if(succeeded["error_message"] != nil){
                        if let code = succeeded["error_message"] as? String{
                            if !code.isEmpty{
                                var message = ""
                                if let messageString = succeeded["message"] as? String{
                                    message = messageString
                                }
                                //openMaintainanceMode(view: self,code: code,message:message)
                                return
                            }
                        }
                        //alert error
                        self.view.makeToast(succeeded["error_message"]! as! String, duration: 5, position: .bottom)
                    }else{
                        //success
                        if let responseResult = succeeded["result"] as? NSDictionary{
                            
                            if let responseResultError = responseResult["valdateFieldsError"] as? NSMutableArray{
                                var errorMessage: String = ""
                                let totalError = responseResultError.count
                                var counter:Int = 1
                                for data in responseResultError {
                                    errorMessage += (data as AnyObject).object(forKey: "errorMessage")! as! String
                                    if(counter != totalError){
                                        errorMessage += "\n"
                                    }
                                    if(counter > errorMessageCounterValue){
                                        break
                                    }
                                    counter = counter + 1
                                }
                                self.view.makeToast(errorMessage, duration: 5, position: .bottom)
                            }else if let formFields = responseResult["formFields"] as? NSMutableArray  {
                                formData = formFields as [AnyObject]
                                self.formController.form = CustomForm()
                                self.formController.tableView.reloadData()
                            }
                        }else if let responseResult = succeeded["result"] as? String{
                            if(responseResult == "Sesapi_Form_Signup_Fields"){
                            self.navigationController?.pushViewController(SignUpFieldsViewController(), animated: true)
                            }else if(responseResult == "Sesapi_Form_Signup_Photo"){
                                //let VC = SignUpPhotoViewController()
                             //   VC.skipEnable = true
                                //self.navigationController?.pushViewController(VC, animated: true)
                            }else if(responseResult == "require_confirmation"){
                                //self.navigationController?.pushViewController(SignUpConfirmationPageViewController(), animated: true)
                            }else if let responseResult = succeeded["result"] as? NSDictionary{
                                //save data to NSUserDefaults
                                let defaults = UserDefaults.standard
                                defaults.set("\(responseResult["displayname"]!)", forKey: "displaynameUser")
                                defaults.set("\(responseResult["photo_url"]!)", forKey: "photoUrlUser")
                                defaults.set("\(responseResult["email"]!)", forKey: "emailUser")
                                userLoggedin = true
                                isUserLoggedIn = true
                                checkLoggedUserActivity = true
                                isOnInnerSite = false
                                //self.navigationController?.pushViewController(ActivityViewController(), animated: false)
                            }
                        }
                    }
                })
            }
        }else{
            self.view.makeToast(String(format: NSLocalizedString("No Internet Connection", comment: "")), duration: 5, position: .bottom)
        }
    }
    @objc func backButton() {
        //playSound(sound: "back")
        self.navigationController?.popViewController(animated: true)
    }
    func getSignupFormData() {
        if Reachability.isConnectedToNetwork() {
           // animator.center = self.view.center
            
            
           // animator.startAnimating()
          //  self.view.addSubview(animator)
            let imageData = Data()
            sendRequest(["getForm":"account" as AnyObject], url: "signup", method: "POST",image:imageData) { (succeeded) -> () in
                DispatchQueue.main.async(execute: {
                   // self.animator.stopAnimating()
                    if(succeeded["error_message"] != nil){
                        if let code = succeeded["error_message"] as? String{
                            if !code.isEmpty{
                                var message = ""
                                if let messageString = succeeded["message"] as? String{
                                    message = messageString
                                }
                                //openMaintainanceMode(view: self,code: code,message:message)
                                return
                            }
                        }
                        //alert error
                        self.view.makeToast(succeeded["error_message"]! as! String, duration: 5, position: .bottom)
                    }else{
                        //success
                        if let responseResult = succeeded["result"] as? NSDictionary{
                            if let formFields = responseResult["formFields"] as? NSMutableArray  {
                                 DispatchQueue.main.async(){
                                formData = formFields as [AnyObject]
                                    print(formData)
                                self.formController.form = CustomForm()
                                self.formController.tableView.reloadData()
                                }
                                
                            }
                        }
                    }
                })
            }
        }else{
            self.view.makeToast(String(format: NSLocalizedString("No Internet Connection", comment: "")), duration: 5, position: .bottom)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        //self.title = NSLocalizedString("Sign Up",  comment: "")
        //self.navigationController?.navigationBar.setBackgroundImage(getImageWithColor(navigationColor,size: CGSize(width: 1, height: 1)), for: UIBarMetrics.default)
        //self.navigationController?.navigationBar.shadowImage = getImageWithColor(navigationColor,size: CGSize(width: 1, height: 1))
        self.navigationController?.navigationBar.isTranslucent = isNavigationTransparent
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.view.backgroundColor = navigationColor
    }
    
}
