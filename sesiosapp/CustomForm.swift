//
//  CustomForm.swift
//  sesiosnativeapp
//
//  Created by Vaibhav on 07/03/17.
//  Copyright © 2017 SocialEngineSolutions. All rights reserved.
//

import UIKit
protocol ClassNavigate: class {
    
    func getCallNavigate(str: NSString)
}
var formData = [AnyObject]()
var multiOptionsData = [String:String]()
var dateOptionsData = [String:String]()
class CustomForm: NSObject, FXForm {
    var valuesByKey = NSMutableDictionary()
    weak var delegate1: ClassNavigate!

    //because we want to rearrange how this form
    //is displayed, we've implemented the fields array
    //which lets us dictate exactly which fields appear
    //and in what order they appear
    
    override func setValue(_ value: Any?, forUndefinedKey key: String)
    {
        if ((value) != nil)
        {
            self.valuesByKey[key] = value;
        }else
        {
            valuesByKey.removeObject(forKey: key)
        }
    }
    override func value(forUndefinedKey key: String) -> Any?
    {
        return valuesByKey[key]
    }
    
    
    func fields() -> [AnyObject] {
        return (generateFormFromArray(formData as NSArray) as! NSArray) as [AnyObject]
        
    }
    
    func extraFields() -> [AnyObject] {
        
        return [
            //this field doesn't correspond to any property of the form
            //it's just an action button. the action will be called on first
            //object in the responder chain that implements the submitForm
            //method, which in this case would be the AppDelegate
            
            //[FXFormFieldCell: SubmitButtonCell.self, FXFormFieldHeader: "", FXFormFieldAction: "submitRegistrationForm:"],
        ]
    }
    
    func generateFormFromArray(_ formelements: NSArray)->AnyObject {
        var formArray = [AnyObject]()
        //loop over formelents array
        hiddenElementFromFormIndex.removeAll(keepingCapacity: false)
        var index = 0
        for key in formelements{
            var field = Dictionary<String, AnyObject>()
            if let fieldDic = (key as? NSDictionary){
                if(fieldDic["type"] as! String == "Text"){
                    //field["type"] = "Text"
                    field["key"] = fieldDic["name"] as! String as AnyObject
                    if fieldDic["name"] as! String != "rate_value" && fieldDic["name"] as! String != "review_star"{
                        field["title"] = fieldDic["label"] as? String as AnyObject
                        if fieldDic["value"] as? String != ""{
                            field["default"] = fieldDic["value"] as? String as AnyObject
                        }
                        if fieldDic["description"] as? String != ""{
                            field["footer"] = fieldDic["description"] as? String as AnyObject
                        }
                        formArray.append(field as AnyObject)
                    }else{
                        field["type"] = "rateview" as AnyObject
                        field["title"] = fieldDic["label"] as? String as AnyObject
                        if fieldDic["value"] as? String != ""{
                            field["default"] = fieldDic["value"] as? String as AnyObject
                        }
                        if fieldDic["description"] as? String != ""{
                            field["footer"] = fieldDic["description"] as? String as AnyObject
                        }
                        formArray.append(field as AnyObject)
                    }
                }else if(fieldDic["type"] as! String == "Password"){
                    field["type"] = "password" as AnyObject
                    field["key"] = fieldDic["name"] as! String as AnyObject
                    field["title"] = fieldDic["label"] as? String as AnyObject
                    if fieldDic["value"] as? String != ""{
                        //field["default"] = fieldDic["value"] as? String
                    }
                    if fieldDic["description"] as? String != ""{
                        field["footer"] = fieldDic["description"] as? String as AnyObject
                    }
                    formArray.append(field as AnyObject)
                }else if(fieldDic["type"] as! String == "Select" || fieldDic["type"] as! String == "Radio"){
                    field["key"] = fieldDic["name"] as! String as AnyObject
                    field["title"] = fieldDic["label"] as? String as AnyObject
                    field["cell"] = "FXFormOptionPickerCell" as AnyObject
                    if fieldDic["description"] as? String != "" && fieldDic["name"] as! String != "host_type" && fieldDic["name"] as! String != "event_host" && fieldDic["name"] as! String != "selectonsitehost"{
                        field["footer"] = fieldDic["description"] as? String as AnyObject
                    }
                    if formResourcesType == "sesgroup_group" && fieldDic["name"] as! String == "approval"{
                        field["action"] = "chooseApproval:" as AnyObject
                    }
                    if (formResourcesType == "sesgroup_album" || formResourcesType == "sespage_album") && fieldDic["name"] as! String == "album"{
                        field["action"] = "chooseAlbum:" as AnyObject
                    }
                    if fieldDic["name"] as! String == "choose_host"{
                        field["action"] = "chooseHostType:" as AnyObject
                    }
                    if fieldDic["name"] as! String == "can_join"{
                        field["action"] = "changeSingularPlural:" as AnyObject
                    }
                    if fieldDic["name"] as! String == "is_custom_term_condition"{
                        field["action"] = "customTermAndCondition:" as AnyObject
                    }
                    if fieldDic["name"] as! String == "include_social_links"{
                        field["action"] = "includeSocialLink:" as AnyObject
                    }
                    if fieldDic["name"] as! String == "host_type"{
                        field["action"] = "selectHostType:" as AnyObject
                    }
                    if fieldDic["name"] as! String == "category_id"{
                        field["action"] = "subcategoryFetch:" as AnyObject
                    }
                    if fieldDic["name"] as! String == "subcat_id"{
                        field["action"] = "subsubcategoryFetch:" as AnyObject
                    }
                    if ((fieldDic["changeFields"] as? Int) != nil){
                        field["action"] = "changeFields:" as AnyObject
                    }
                    if fieldDic["name"] as! String == "mediatype"{
                        field["action"] = "changeMediaType:" as AnyObject
                    }
                    if fieldDic["name"] as! String == "posttype"{
                        field["action"] = "changePostingType:" as AnyObject
                    }
                    if let name = fieldDic["name"] as? String{
                        if name == "show_start_time"{
                            field["action"] = "showHideStartTime:" as AnyObject
                        }else if name == "playlist_id" || name == "list_id"{
                            field["action"] = "playlistHideShow:" as AnyObject
                        }
                    }
                    multiOptionsData[field["key"]! as! String] = field["key"]! as? String
                    
                    if let option = fieldDic["multiOptions"] as? NSDictionary{
                        //let optionKeys = option.allKeys
                        let optionKeys = option.allKeys.sorted(by: { (key1, key2) -> Bool in
                            (key1 as! String) < (key2 as! String)
                        })
                        var options = [AnyObject]()
                        for index in optionKeys{
                            options.append(option["\(index)"]! as AnyObject)
                        }
                        if fieldDic["value"] as? String != ""{
                            do{
                                if let val = fieldDic["value"] as? String{
                                    field["default"] = option[val] as? String as AnyObject
                                }
                            }
                        }
                        field["options"] = options as AnyObject
                    }else if let option = fieldDic["multiOptions"] as? NSArray{
                        if let val = fieldDic["value"] as? String {
                            do{
                                // if ( option[(fieldDic["value"] as? Int)!]) != nil{
                                field["default"] = val as AnyObject
                                //}
                            }
                        }
                        field["options"] = option
                    }
                    if let name = fieldDic["name"] as? String {
                        if name == "resource_video_type"{
                            field["action"] = "videouploadsource:" as AnyObject
                        }
                    }
                    formArray.append(field as AnyObject)
                }else if (fieldDic["type"] as! String == "File"){
                    field["key"] = fieldDic["name"] as? String as AnyObject
                    field["title"] = fieldDic["label"] as? String as AnyObject
                    field["type"] = "image" as AnyObject
                    if fieldDic["description"] as? String != ""{
                        field["footer"] = fieldDic["description"] as? String as AnyObject
                    }
                    if let valueFile = fieldDic["value"] as? String {
                        if valueFile != ""{
                            field["default"] = valueFile as AnyObject
                        }
                    }
                    
                    formArray.append(field as AnyObject)
                }else if(fieldDic["type"] as! String == "Date" || fieldDic["type"] as! String == "CalendarDateTime"){
                    field["key"] = fieldDic["name"] as! String as AnyObject
                    
                    if fieldDic["value"] != nil{
                        //field["default"] = fieldDic["value"] as? String
                        let formatdate = DateFormatter()
                        formatdate.dateFormat = "yyyy-MM-dd"
                        if let str = fieldDic["value"] as? String{
                            if !str.isEmpty{
                                field["default"] = formatdate.date(from: str) as AnyObject
                            }
                        }else{
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            let myString = formatter.string(from: fieldDic["value"] as! Date)
                           // field["default"] = convertOrg(myString) as AnyObject
                        }
                    }
                    if fieldDic["name"] as! String == "start_time" || fieldDic["name"] as! String == "end_time"{
                        field["type"] = "datetime" as AnyObject
                        if fieldDic["value"] as? String != ""{
                            //field["default"] = fieldDic["value"] as? String
                            let formatdate = DateFormatter()
                            formatdate.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            if let str = fieldDic["value"] as? String{
                                if !str.isEmpty{
                                  //  field["default"] = convertOrg(str) as AnyObject
                                }
                            }
                        }
                    }else{
                        field["type"] = "date" as AnyObject
                    }
                    field["title"] = fieldDic["label"] as? String as AnyObject
                    
                    if fieldDic["description"] as? String != ""{
                        field["footer"] = fieldDic["description"] as? String as AnyObject
                    }
                    formArray.append(field as AnyObject)
                }else if(fieldDic["type"] as! String == "openTinymceEditor" ){
                    field["type"] = "longtext" as AnyObject
                    let keyName = fieldDic["name"] as! String as AnyObject
                    var name = ""
                    field["segue"] = "segue" as AnyObject
                    
                    name = keyName as! String
                    
                    field["key"] = name as AnyObject
                    field["title"] = fieldDic["label"] as? String as AnyObject
                    if fieldDic["value"] as? String != ""{
                        field["default"] = fieldDic["value"] as? String as AnyObject
                    }
                    if fieldDic["description"] as? String != ""{
                        field["footer"] = fieldDic["description"] as? String as AnyObject
                    }
                    formArray.append(field as AnyObject)
                    
                    if (fieldDic["name"] as! String).range(of: "_hidetextareaforfxform") != nil{
                        hiddenElementFromFormIndex.append(index)
                    }
                    
                }else if(fieldDic["type"] as! String == "Textarea" || fieldDic["type"] as! String == "TinyMce"){
                    field["type"] = "longtext" as AnyObject
                    let keyName = fieldDic["name"] as! String as AnyObject
                    var name = ""
//                    if keyName as! String == "body"{
//                        field["segue"] = String.getString("segue") as AnyObject
//                    }
//                  else
                        if keyName as! String == "description"{
                        name = "\(keyName)_keydesciption"
                    }else{
                        name = keyName as! String
                    }
                    field["key"] = name as AnyObject
                    field["title"] = fieldDic["label"] as? String as AnyObject
                    if fieldDic["value"] as? String != ""{
                        field["default"] = fieldDic["value"] as? String as AnyObject
                    }
                    if fieldDic["description"] as? String != ""{
                        field["footer"] = fieldDic["description"] as? String as AnyObject
                    }
                    formArray.append(field as AnyObject)
                    
                    if (fieldDic["name"] as! String).range(of: "_hidetextareaforfxform") != nil{
                        hiddenElementFromFormIndex.append(index)
                    }
                    
                }else if(fieldDic["type"] as! String == "Heading"){
                    field["header"] = fieldDic["value"] as? String as AnyObject
                    hiddenElementFromFormIndex.append(index)
                    field["title"] = fieldDic["label"] as? String as AnyObject
                    field["key"] = fieldDic["name"] as! String as AnyObject
                    formArray.append(field as AnyObject)
                }else if(fieldDic["type"] as! String == "Button"){
                    field["header"] = "" as AnyObject
                    let keyName = fieldDic["name"] as! String as AnyObject
                    field["title"] = fieldDic["label"] as AnyObject
                    if keyName as! String != "join_question"{
                        field["action"] = "submitForm:" as AnyObject
                    }else{
                        field["action"] = "addQuestion:" as AnyObject
                    }
                    formArray.append(field as AnyObject)
                }else if(fieldDic["type"] as! String == "Hidden"){
                    field["title"] = fieldDic["label"] as? String as AnyObject
                    field["key"] = fieldDic["name"] as! String as AnyObject
                    field["default"] = "\(fieldDic["value"]!)" as AnyObject
                    if fieldDic["description"] as? String != ""{
                        field["footer"] = fieldDic["description"] as? String as AnyObject
                    }
                    hiddenElementFromFormIndex.append(index)
                    formArray.append(field as AnyObject)
                }else if(fieldDic["type"] as! String == "Checkbox"){
                    field["type"] = "boolean" as AnyObject
                    field["key"] = fieldDic["name"] as! String as AnyObject
                    field["title"] = fieldDic["label"] as? String as AnyObject
                    if let value = fieldDic["value"] as? Int{
                        field["default"] = value as AnyObject
                    }else{
                        field["default"] = 0 as AnyObject
                    }
                    if fieldDic["description"] as? String != ""{
                        field["footer"] = fieldDic["description"] as? String as AnyObject
                    }
                    formArray.append(field as AnyObject)
                    if(fieldDic["name"] as! String == "terms"){
                        var field = Dictionary<String, AnyObject>()
                        field["title"] = "Click here to read the terms of service." as AnyObject
                        field["action"] = "termsCondition:" as AnyObject
                        formArray.append(field as AnyObject)
                    }
                    if fieldDic["name"] as! String == "is_custom_term_condition"{
                        field["action"] = "termsCondition:" as AnyObject
                    }
                }else if(fieldDic["type"] as! String == "MultiCheckbox"){
                    field["type"] = "option" as AnyObject
                    //field["key"] = fieldDic["name"] as! String
                    field["header"] = fieldDic["label"] as? String as AnyObject
                    if let values = fieldDic["value"] as? NSArray{
                        var counter:Int = 0
                        for (key,value) in (fieldDic["multiOptions"] as! NSDictionary){
                            if(counter > 0){
                                field["header"] = nil
                            }
                            field["key"] = (fieldDic["name"] as? String)!+"[\(key)]" as AnyObject
                            field["title"] = value as AnyObject
                            // multiOptionsData[field["key"]! as! String] = field["key"]! as? String
                            if  values.contains(key) == true{
                                field["default"] = true as AnyObject
                            }else{
                                field["default"]  = nil
                            }
                            counter = counter+1
                            formArray.append(field as AnyObject)
                        }
                    }else if let values = fieldDic["value"] as? NSDictionary{
                        var counter:Int = 0
                        for (key,value) in (fieldDic["multiOptions"] as! NSDictionary){
                            if(counter > 0){
                                field["header"] = nil
                            }
                            field["key"] = (fieldDic["name"] as? String)!+"[\(key)]" as AnyObject
                            field["title"] = value as AnyObject
                            // multiOptionsData[field["key"]! as! String] = field["key"]! as? String
                            if (values[key]) != nil{
                                field["default"] = true as AnyObject
                            }else{
                                field["default"]  = nil
                            }
                            counter = counter+1
                            formArray.append(field as AnyObject)
                        }
                        
                    }
                }
            }
            index = index+1
        }
        return formArray as AnyObject
    }
}
func getValueForValueKey(_ value:String, fieldValue:String) -> String {
    for key in formData{
        if let dic = (key as? NSDictionary){
            let fieldName = dic["name"] as! String
            if(fieldName == value){
                if let options = (dic["multiOptions"] as? NSDictionary) {
                    for (key,_) in options {
                        if options["\(key)"] as? String == fieldValue{
                            return "\(key)"
                        }
                    }
                }
            }
        }
    }
    return ""
}

