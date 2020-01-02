//
//
//  SignUpFieldsViewController.swift
//  sesiosnativeapp
//
//  Created by Vaibhav on 15/03/17.
//  Copyright © 2017 SocialEngineSolutions. All rights reserved.
//

import Foundation

class SignUpFieldsViewController: FXFormViewController {
    var dataDictionary: NSMutableArray!
  //  var animator = NVActivityIndicatorView(frame: appLoaderframe, type: loadingImageType(), color: appLoadingImageColor, padding: CGFloat(0))
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.isHidden = false
//        self.title = NSLocalizedString("Sign Up",  comment: "")
//        var backImg = UIImage(named: "back.png")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//        backImg = backImg.imageWithColor(color: navigationTitleColor)
//        let backImageButton = UIButton(type: .custom)
//        backImageButton.setImage(backImg, for: UIControl.State())
      //  let backButtonIcon = UIBarButtonItem(badge: nil,button: backImageButton, target: self, action: #selector(CorePrivacySettingsViewController.backButton))
     //   self.navigationItem.leftBarButtonItem = backButtonIcon
        getSignupFormData()
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
          //  animator.center = self.view.center
            
            
           // self.view.addSubview(animator)
            let imageData = Data()
            paramsPost["validateFieldsForm"] = "1"
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
                        }else if let responseResult = succeeded["result"] as? String{
                            if(responseResult == "Sesapi_Form_Signup_Photo"){
                              //  let VC = SignUpPhotoViewController()
                              //  VC.skipEnable = true
                                //self.navigationController?.pushViewController(VC, animated: true)
                            }else if(responseResult == "require_confirmation"){
                               //self.navigationController?.pushViewController(SignUpConfirmationPageViewController(), animated: true)
                            }else if(responseResult == "Sesapi_Form_Signup_Subscription"){
                                let alertController = UIAlertController(title: "Message", message:
                                    "You have successfully signed up to this app, please choose a subscription plan for your account.", preferredStyle: UIAlertController.Style.alert)
                                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (UIAlertAction) -> Void in
                                  //  let pVC = WebViewController()
//                                    pVC.url = domainname+"sesapi/subscription"
//                                    pVC.siteTitle = "Subscription"
//                                    pVC.isSubscriptionViewController = true
//                                    pVC.paymentWebView = true
//                                    self.navigationController?.pushViewController(pVC, animated: true)
                                }))
                                self.present(alertController, animated: true, completion: nil)
                            }
                            
                        }
                    }
                })
            }
        }else{
            self.view.makeToast(String(format: NSLocalizedString("No Internet Connection", comment: "")), duration: 5, position: .bottom)
        }
        
    }
    func backButton() {
        let alertController = UIAlertController(title: nil, message: "Are you sure want to go back?", preferredStyle: UIAlertController.Style.actionSheet)
        
        let signout = UIAlertAction(title: "Go Back", style: .destructive, handler: {(alert: UIAlertAction!) in
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
            }
        )
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(alert: UIAlertAction!) in
            // self.tableView.reloadData()
            }
        )
        alertController.addAction(signout)
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
            alertController.popoverPresentationController!.sourceView = view
            alertController.popoverPresentationController!.sourceRect = CGRect(x: appWidth/2, y: appHeight/2, width: 0, height: 0)
            alertController.popoverPresentationController!.permittedArrowDirections = UIPopoverArrowDirection()

        }else{
            alertController.addAction(cancelAction)
        }
        self.present(alertController, animated: true, completion:{})
    }
    func getSignupFormData() {
        if Reachability.isConnectedToNetwork() {
           // animator.center = self.view.center
            
            
           // animator.startAnimating()
          //  self.view.addSubview(animator)
            let imageData = Data()
            sendRequest(["getForm":"fields" as AnyObject], url: "signup", method: "POST",image:imageData) { (succeeded) -> () in
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
                                formData = formFields as [AnyObject]
                                self.formController.form = CustomForm()
                                self.formController.tableView.reloadData()
                                
                            }
                        }
                    }
                    
                })
            }
            
        }else{
            self.view.makeToast(String(format: NSLocalizedString("No Internet Connection", comment: "")), duration: 5, position: .bottom)
        }
    }
}
