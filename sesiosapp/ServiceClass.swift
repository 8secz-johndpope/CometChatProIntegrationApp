//
//  Request.swift
//  Social Networking
//
//  Created by Vaibhav on 04/01/17.
//  Copyright © 2017 SocialEngineSolutions. All rights reserved.
//

import Foundation
var deviceTokenString:String = ""
var auth_token:String = ""
var selectedMultipleImagesActivity = [String:UIImage]()

func sendRequest(_ params: Dictionary<String,AnyObject>, url: String!, method: String!,image: Data?, postCompleted : @escaping (_ succeeded:NSDictionary) -> ())
{
    /*sesapi_platform = 1 IOS App*/
    var deviceToken:String = ""
    /*url.lowercased().range(of: "login") != nil || url.lowercased().range(of: "signup") != nil ) && */
    if deviceTokenString != "" {
        deviceToken = "&device_uuid="+deviceTokenString
    }
    
    var language = ""
    if let langStr = Locale.current.languageCode{
        language = langStr
    }
    var device_id = ""
    if let deviceID = UIDevice.current.identifierForVendor?.uuidString{
        device_id = deviceID
    }
    var urlString:String = ""
        urlString = domainname+url+"?restApi=Sesapi&debug=1&sesapi_platform=1&auth_token=\(auth_token)"+deviceToken+"&language="+language+"&device_id="+device_id+"&sesapi_version=\(sesapi_version)"
 
    //if urlString.range(of:"navigation/updates") == nil && urlString.range(of:"activity/index") == nil {
        print(urlString)
    //}
    let url = URL(string: urlString)
    
    let request = NSMutableURLRequest(url:url!);
    request.httpMethod = method;
    request.setValue("Keep-Alive", forHTTPHeaderField: "Connection")
    
    let boundary = generateBoundaryString()
    
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    //print(url ?? "Invalid URL")
    request.httpBody = createBodyWithParameters(params, filePathKey: "image", imageDataKey: (image)!, boundary: boundary)
    print( request.httpBody ?? "No Response" )
    let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
        data, response, error -> Void in
        var result:Dictionary<String, AnyObject> = [:]
       //  print(response ?? "Blank Response")
        if (response == nil){
            //result["error"] = 1 as AnyObject;
            //result["error_message"] = "Unable to parse response" as AnyObject
            postCompleted([:])
            return
        }
        var responseString:String = ""
        if let responseStringS = String(data: data!, encoding: String.Encoding.utf8){
            responseString = responseStringS
        }
        //if urlString.range(of:"navigation/updates") == nil && urlString.range(of:"activity/index") == nil {
            print(responseString)
        //}
        do{
            if let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
               // print(json)
                if(json["error"] != nil ){
                    result["success"] = false as AnyObject;
                    result["message"] = json["message"] as AnyObject
                    result["error_message"] = json["error_message"] as AnyObject
                    postCompleted(result as NSDictionary)
                }else{
                    if let token = json["aouth_token"] as? String{
                        auth_token = token
                        let  userdefaults = UserDefaults.standard
                        userdefaults.set("\(auth_token)", forKey: "auth_token")
                        
                       let userDefaultsExt = UserDefaults(suiteName: "\(shareExtentionName)")
                        userDefaultsExt!.set("\(auth_token)", forKey: "auth_token")
                        userDefaultsExt!.synchronize()
                    }
                    
                    result["result"] = json["result"] as AnyObject
                    if let responseResult = result["result"] as? NSDictionary{
                        if let user_id = responseResult["loggedin_user_id"] as? Int{
                            if user_id > 0{
                                loggedinUserId = user_id
                                isUserLoggedIn = true
                            }else{
                                let userDefaultsExt = UserDefaults(suiteName: "\(shareExtentionName)")
                                userDefaultsExt!.set("", forKey: "auth_token")
                                userDefaultsExt!.synchronize()
                                isUserLoggedIn = false
                            }
                        }
                    }
                    postCompleted(result as NSDictionary)
                }
            }else{
                result["error"] = 1 as AnyObject;
                result["error_message"] = "Unable to parse response" as AnyObject
                postCompleted(result as NSDictionary)
            }
        }
        catch _ as NSError{
            // error.description
            result["error"] = 1 as AnyObject;
            result["error_message"] = "Unable to parse response" as AnyObject
            postCompleted(result as NSDictionary)
        }
    })
  
    task.resume()
}
func createBodyWithParameters(_ parameters: Dictionary<String, AnyObject>, filePathKey: String?, imageDataKey: Data, boundary: String) -> Data {
    let body = NSMutableData();
    var isHostPhotoUpload = false
    if parameters.count > 0 {
        for (key, value) in parameters {
            if key == "isHostPhotoUpload"{
                isHostPhotoUpload = true
            }
            if key == "multipleImages"{
                continue
            }
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
    }
    var filePathKeyCus = "image"
    if let module = parameters["module"] as? String{
        if module == "sesevent"{
            filePathKeyCus = "photo"
        }
    }
    let mimetype = "image/jpg"
    if isHostPhotoUpload == true && selectedMultipleImagesActivity.count > 0{
        for (key,value) in selectedMultipleImagesActivity{
            let image = value
            let filename = "image\(key).jpg"
            let data = image.jpegData(compressionQuality: 1)
            let keyval = "host_photo"
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"\(keyval)\"; filename=\"\(filename)\"\r\n")
            body.appendString("Content-Type: \(mimetype)\r\n\r\n")
            body.append(data!)
            body.appendString("\r\n")
        }
        selectedMultipleImagesActivity.removeAll(keepingCapacity: false)
    }else if selectedMultipleImagesActivity.count > 0{
        for (key,value) in selectedMultipleImagesActivity{
            let image = value
            let filename = "image\(key).jpg"
            let data = image.jpegData(compressionQuality: 1)
            let keyval = "attachmentImage[\(key)]"
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"\(keyval)\"; filename=\"\(filename)\"\r\n")
            body.appendString("Content-Type: \(mimetype)\r\n\r\n")
            body.append(data!)
            body.appendString("\r\n")
        }
        selectedMultipleImagesActivity.removeAll(keepingCapacity: false)
    }
    var filename = "image.jpg"
    if uploadedVideoData != nil{
    //if uploadedVideoData!.count > 0{
        filename = "video.mov"
        filePathKeyCus = "video"
       
    }else{
         uploadedVideoData = nil
    }
//    }
    body.appendString("--\(boundary)\r\n")
    body.appendString("Content-Disposition: form-data; name=\"\(filePathKeyCus)\"; filename=\"\(filename)\"\r\n")
    body.appendString("Content-Type: \(mimetype)\r\n\r\n")
    if uploadedVideoData != nil{
   // if uploadedVideoData!.count > 0{
        body.append(uploadedVideoData!)
        uploadedVideoData = nil
        // print("YES")
    }else{
        body.append(imageDataKey)
        uploadedVideoData = nil
    }
  //  }
    body.appendString("\r\n")
    
    body.appendString("--\(boundary)--\r\n")
    //print(body);
    return body as Data
}

func generateBoundaryString() -> String {
    return "Boundary-\(UUID().uuidString)"
}
extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
