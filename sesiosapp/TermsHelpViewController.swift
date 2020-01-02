//
//  TermsHelpViewController.swift
//  sesiosnativeapp
//
//  Created by Vaibhav on 15/02/18.
//  Copyright © 2018 SocialEngineSolutions. All rights reserved.
//

import Foundation
class TermsHelpViewController: UIViewController , UIWebViewDelegate{
    var siteTitle:String = ""
    var webview:UIWebView!
  //  var animator = NVActivityIndicatorView(frame: appLoaderframe, type: loadingImageType(), color: appLoadingImageColor, padding: CGFloat(0))
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = navigationColor
        self.navigationController?.navigationBar.tintColor = navigationTitleColor
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: navigationTitleColor]
        self.title = self.siteTitle
        self.view.backgroundColor = appBackgroundColor
        var backImg = UIImage(named: "back.png")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        backImg = backImg.imageWithColor(color: navigationTitleColor)
        let backImageButton = UIButton(type: .custom)
        backImageButton.setImage(backImg, for: UIControl.State())
       // let backButtonIcon = UIBarButtonItem(badge: nil,button: backImageButton, target: self, action: #selector(self.backButton))
       // self.navigationItem.leftBarButtonItem = backButtonIcon
        
        self.webview = UIWebView(frame:CGRect(x: 5, y: 5, width: appWidth - 10, height: appHeight))
        self.webview.backgroundColor = appBackgroundColor
        self.webview.isOpaque = false
        self.webview.delegate = self
        self.webview.scrollView.bounces = false
        self.view.addSubview(webview)
    }
    @objc func backButton(){
        self.dismiss(animated: true, completion: nil)
    }
    func getData() {
     //   animator.center = self.view.center
        
        
       // animator.startAnimating()
       // self.view.addSubview(animator)
        if Reachability.isConnectedToNetwork() {
            let imageData = Data()
            sendRequest(paramsPost as Dictionary<String, AnyObject>, url: "sesapi/index/terms/", method: "POST",image:imageData) { (succeeded) -> () in
                DispatchQueue.main.async(execute: {
                    //self.animator.stopAnimating()
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
                        if let responseResult = succeeded["result"] as? NSDictionary{
                            //success
                            if let data = responseResult["terms"] as? NSDictionary{
                                self.webview.loadHTMLString((data["description"] as! String), baseURL: nil)
                            }
                        }
                    }
                })
            }
        }else{
            self.view.makeToast(String(format: NSLocalizedString("No Internet Connection", comment: "")), duration: 5, position: .bottom)
        }
    }
//    public func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool
//    {
//        if navigationType == .linkClicked
//        {
//            if let url_text = request.url?.absoluteURL {
//                let pvc = WebViewController()
//                pvc.url = "\(url_text)"
//                pvc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
//                let navigationController = UINavigationController(rootViewController: pvc)
//                self.present(navigationController, animated: true, completion: nil)
//            }
//            return false
//        }
//        return true;
//    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
       // animator.center = self.view.center
      //  animator.startAnimating()
       // view.addSubview(animator)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
      //  animator.stopAnimating()
    }
    override func viewDidAppear(_ animated: Bool) {
        getData()
    }
}

