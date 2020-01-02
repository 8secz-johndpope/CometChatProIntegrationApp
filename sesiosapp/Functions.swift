//
//  Functions.swift
//  Social Networking
//
//  Created by Vaibhav on 02/01/17.
//  Copyright © 2017 SocialEngineSolutions. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import EventKit
var commingFromDeletedCondition:Bool = false
//var baseController : TabBarController!
var window: UIWindow?
let appWidth = UIScreen.main.bounds.size.width
let appHeight = UIScreen.main.bounds.size.height
var paramsPost = Dictionary<String, String>()
var searchDictionary = Dictionary<String, String>()
var checkLoggedUserActivity:Bool = true
var hiddenElementFromFormIndex = [Int]()
var outsideModule = true
var postingPermission:String = "everyone"
let multiPhotoCountSelect = 10
var reactionIcons:NSArray!
var isUserLoggedIn:Bool = false
var loggedinUserId:Int = 0
var reactionImageCache = [String:UIImage]()
var speechRecognitionText:String = ""
let appDelegateObject = UIApplication.shared.delegate as! AppDelegate
@available(iOS 10.0, *)
//let context = appDelegateObject.persistentContainer.viewContext

var multiSelectPhoto = true
var strCheck = ""
var allowMultipleTypes = true
var maxSelectableCount = 0
func alertView(_ error: String,selfController: UIViewController,title: String){
    let alert = UIAlertController(title: "Error", message:
        error, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: title, style: UIAlertAction.Style.default,handler: nil))
    selfController.present(alert, animated: true, completion: nil)
}

func showConfirmationAlert(_ buttonTitle:String!,title: String!, message: String!,presentWindow:UIViewController,success: (() -> Void)? , cancel: (() -> Void)?) {
    DispatchQueue.main.async(execute: {
        let alertController = UIAlertController(title:title,
            message: message,
            preferredStyle: UIAlertController.Style.alert)
        
        let cancelLocalized = NSLocalizedString("Cancel", comment: "")
        let okLocalized = NSLocalizedString(buttonTitle, comment:"")
        
        let cancelAction: UIAlertAction = UIAlertAction(title: cancelLocalized,
        style: .cancel) {
            action -> Void in cancel?()
        }
        let deleteString = NSLocalizedString("Delete", comment: "")
        var type = UIAlertAction.Style.default
        if buttonTitle == deleteString{
            type = UIAlertAction.Style.destructive
        }
        
        let successAction: UIAlertAction = UIAlertAction(title: okLocalized,
        style: type) {
            action -> Void in success?()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(successAction)
        
        presentWindow.present(alertController, animated: true, completion: nil)
    })
}
func isValidEmail(_ email:String) -> Bool {
    // print("validate calendar: \(testStr)")
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: email)
}

func createTabBarNavigations() {
    window = UIWindow(frame: UIScreen.main.bounds)
   // window?.rootViewController = baseController
    
    window?.makeKeyAndVisible()
}

extension String {
    /// Decodes string with html encoding.
    var htmlDecoded: String {
        guard let encodedData = self.data(using: .utf8) else { return self }
        
        let attributedOptions = [
            NSAttributedString.DocumentAttributeKey.documentType.rawValue: NSAttributedString.DocumentType.html,
            NSAttributedString.DocumentAttributeKey.characterEncoding.rawValue: String.Encoding.utf8.rawValue
        ] as  [String: Any]
        
        do {
            let attributedString = try NSAttributedString(data: encodedData,
                                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                                          documentAttributes: nil)
            return attributedString.string
        } catch {
            print("Error: \(error)")
            return self
        }
    }
}
 
func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
extension UINavigationController {
    public func pushViewController(
        _ viewController: UIViewController,
        animated: Bool,
        completion: @escaping () -> Void)
    {
        pushViewController(viewController, animated: animated)
        
        guard animated, let coordinator = transitionCoordinator else {
            completion()
            return
        }
        
        coordinator.animate(alongsideTransition: nil) { _ in completion() }
    }
}
extension UITextView {
    
    func resolveHashTags(){
        
        // turn string in to NSString
        let tag = self.tag
        if let nsText:NSString = self.text as NSString?{
             let stringText = nsText.replacingOccurrences(of: "", with: "")
            // this needs to be an array of NSString.  String does not work.
            let words:[String] = stringText.components(separatedBy: " ")
            
            // you can't set the font size in the storyboard anymore, since it gets overridden here.
            let attrs = [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17.0)
            ]
            // you can staple URLs onto attributed strings
            let attrString = NSMutableAttributedString(string: nsText as String, attributes:attrs)
            let inputLength = attrString.string.count
           // var boldFontHighlight = CTFontCreateWithName(boldFont as CFString, fontSizeLarge, nil)
            
            for searchString in words {
              if searchString.hasPrefix("#") && searchString.count > 1 {
                let searchLength = searchString.count
                // tag each word if it has a hashtag
                var range = NSRange(location: 0, length: nsText.length)
                while (range.location != NSNotFound) {
                    range = (attrString.string as NSString).range(of: searchString, options: [.caseInsensitive], range: range)
                    if (range.location != NSNotFound) {
                        //attrString.addAttribute(NSAttributedString.Key(rawValue: kCTFontAttributeName as String as String), value: boldFontHighlight, range: NSRange(location: range.location, length: searchLength))
                       // range = NSRange(location: range.location + range.length, length: inputLength - (range.location + range.length))
                    }
                }
              }
            }
            
            
            if tag == 666{
                attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: nsText.length))
            }
            // we're used to textView.text
            // but here we use textView.attributedText
            // again, this will also wipe out any fonts and colors from the storyboard,
            // so remember to re-add them in the attrs dictionary above
            self.attributedText = attrString
      }
    }
}

//margin
class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}


func backButtonCommon(view:UIViewController){
    if view.isModal == true{
        view.dismiss(animated: true, completion: nil)
    }else{
        view.navigationController?.popViewController(animated: true)
    }
}
extension UIView {
    func addBackground(image:String,imageViewBackground:UIImageView) {
        // screen width and height:
      //  imageViewBackground.image = rateusBackgroundImage
        // you can change the content mode:
        imageViewBackground.contentMode = UIView.ContentMode.scaleAspectFill
        self.addSubview(imageViewBackground)
        self.sendSubviewToBack(imageViewBackground)
    }}
extension UIViewController {
    var isModal: Bool {
        if let index = navigationController?.viewControllers.index(of: self), index > 0 {
            return false
        } else if presentingViewController != nil {
            return true
        } else if navigationController?.presentingViewController?.presentedViewController == navigationController  {
            return true
        } else if tabBarController?.presentingViewController is UITabBarController {
            return true
        } else {
            return false
        }
    }
}
extension AVPlayer {
    var ready:Bool {
        let timeRange = currentItem?.loadedTimeRanges.first as? CMTimeRange
        guard let duration = timeRange?.duration else { return false }
        let timeLoaded = Int(duration.value) / Int(duration.timescale) // value/timescale = seconds
        let loaded = timeLoaded > 0
        
        return status == .readyToPlay && loaded
    }
}
extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(colorImage, for: forState)
    }}
extension UIImage {
    func getPixelColor(pos: CGPoint) -> UIColor {
        
        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
}

enum ViewBorder: String {
    case left, right, top, bottom
}
extension UIView {
    func addBorder(border: ViewBorder, color: UIColor, width: CGFloat) {
        let borderLayer = CALayer()
        borderLayer.backgroundColor = color.cgColor
        borderLayer.name = border.rawValue
        switch border {
        case .left:
            borderLayer.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        case .right:
            borderLayer.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        case .top:
            borderLayer.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        case .bottom:
            borderLayer.frame = CGRect(x: 0, y: self.frame.size.height, width: self.frame.size.width, height: width)
        }
        self.layer.addSublayer(borderLayer)
    }
    
    func removeBorder(border: ViewBorder) {
        guard let sublayers = self.layer.sublayers else { return }
        var layerForRemove: CALayer?
        for layer in sublayers {
            if layer.name == border.rawValue {
                layerForRemove = layer
            }
        }
        if let layer = layerForRemove {
            layer.removeFromSuperlayer()
        }
    }
}
extension URL {
    func valueOf(_ queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }
}
extension UIButton {
    func leftImage(image: UIImage, renderMode: UIImage.RenderingMode,type:String, title:String) {
        if type == "selected"{
             self.setImage(image.withRenderingMode(renderMode), for: .selected)
        }else{
             self.setImage(image.withRenderingMode(renderMode), for: .normal)
        }
        self.setTitle(title, for: UIControl.State.normal)
        self.setTitle(title, for: UIControl.State.selected)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: image.size.width / 2)
        self.contentHorizontalAlignment = .left
        self.setTitleColor(UIColor.black, for: UIControl.State.normal)
        self.setTitleColor(UIColor.black, for: UIControl.State.selected)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        self.layoutIfNeeded()
        //self.imageView?.contentMode = .scaleAspectFit
    }
    
    func rightImage(image: UIImage, renderMode: UIImage.RenderingMode,type:String, title:String){
        if type == "selected"{
            self.setImage(image.withRenderingMode(renderMode), for: .selected)
        }else{
            self.setImage(image.withRenderingMode(renderMode), for: .normal)
        }
        self.setTitle(title, for: UIControl.State.normal)
        self.setTitle(title, for: UIControl.State.selected)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left:image.size.width / 2, bottom: 0, right: 0)
        self.contentHorizontalAlignment = .right
        self.imageView?.contentMode = .scaleAspectFit
    }
}
func addEventToCalendar(title: String, description: String?, startDate: Date, endDate: Date, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
    let eventStore = EKEventStore()
    
    eventStore.requestAccess(to: .event, completion: { (granted, error) in
        if (granted) && (error == nil) {
            let event = EKEvent(eventStore: eventStore)
            event.title = title
            event.startDate = startDate
            event.endDate = endDate
            event.notes = description
            event.calendar = eventStore.defaultCalendarForNewEvents
            do {
                try eventStore.save(event, span: .thisEvent)
            } catch let e as NSError {
                completion?(false, e)
                return
            }
            completion?(true, nil)
        } else {
            completion?(false, error as NSError?)
        }
    })
}

extension UIImage {
    func imageWithColor(color:UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height);
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.clip(to: rect, mask: self.cgImage!)
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let imageFromCurrentContext = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIImage(cgImage: imageFromCurrentContext!.cgImage!, scale: 1.0, orientation:.downMirrored)
    }
}
extension UITextView {
    func centerText() {
        self.textAlignment = .center
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
    
}
extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
