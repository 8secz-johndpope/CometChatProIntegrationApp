//
//
//  Config.swift
//  Social Networking
//
//  Created by Vaibhav on 04/01/17.
//  Copyright © 2017 SocialEngineSolutions. All rights reserved.
//

import Foundation
//AdvanceApp URL
let domainname = "https://demo4seapps.socialnetworking.solutions/staging/"
var sesapi_version = "1.8"
//CoreApp URL
let shareExtentionName = ""
var limitCount = "10"
var siteTitle = ""
var tabBarTitle: Bool? = true
var shareOnText = ""
var activityBodyTruncationLimit:Int = 200
var enableSkipLogin = false
var enableTabbedMenuInActivityScreen:Bool = true
var fixedHeaderInActivityScreen:Bool = true
var showSearchViewInActivityScreen:Bool = true
var itunesUrlForRating = ""
var allowStats:Bool = true
// google map api key to get location
var googleMapApiServerKey = ""
var appLoadingImage:Int = 32
var appLoaderframe = CGRect(x: (appWidth - 50)/2, y: (appHeight - 50)/2, width: 50, height: 50)

var rememberMeEnableApp = false


var activityFeedAllignment:String = "left"

//lazy loading image
var animationDelayImage = 0.1
var animationDurationImage = 0.3



//video slideshow settings
//SettingApp
var settingAppLive = ""//"Activity"
var videoSlideshowBackgroundColor = hexStringToUIColor(hex: "#424844")
var videoBackgroundTextColor = hexStringToUIColor(hex: "#aeb3af")

var isNavigationTransparent = true

var memberImageShapeIsRound = true

let appBackgroundImage = "backgound_image.png"
let appLogo = ""

var loginBackgroundImage = UIImage()
var forgotBackgroundImage = UIImage()
var rateusBackgroundImage = UIImage()
var menudashboardBackgroundImage = UIImage()

let facebookLoginEnable: Bool? = false
var userLoggedin: Bool? = false
var refreshControl: UIRefreshControl!

var isOnInnerSite: Bool? = false
var errorMessageCounterValue:Int = 5
//for pagging in table view
let activityIndicatorBottomHeight:Int = 100
var playSoundInApp:Bool = false
let defaultLocationRadius = 300
let locationRadius = 4000

let feedCheckNotification:Int = 10
let tabBarNotificationCount:Int = 10
var tableViewScrollPosition:CGFloat = 0
var FXformMediaType:String = "photo"
var uploadedVideoData:Data? = nil//Data()

var globalTabBarHeight:CGFloat = 0
var tabBarHeightHidden:Bool = false
var selectedMusicSongsArray = Dictionary<Int, Any>()
var currentPlayingSong:Int = 0
var playerPlayingSong:Bool = false
var isAppearFromMusicPopUp:Bool = false
var isIpad:Bool = false


var slideshowImages = [String]()
var textSlideshow = [String]()
var descriptionSlideshow = [String]()
var colorTitleSlideshow = [String]()
var colorDescriptionSlideshow = [String]()
//duration of slide to change
let slideDuration = 2.7

//app font sizes
var fontSizeNormal:CGFloat = 10.0
var fontSizeMedium:CGFloat = 12.0
var fontSizeLarge:CGFloat = 14.0
var fontSizeVeryLarge:CGFloat = 16.0
var fontSizeVeryVeryLarge:CGFloat = 18.0
var fontSizeHuge:CGFloat = 20.0

//color
var navigationColor = UIColor.black
var navigationTitleColor = UIColor.white

var appLoadingImageColor = UIColor.clear

//placeholder
var placeholdercolor = UIColor.clear
var outsidePlaceHolderColor = UIColor.clear
var outsideTitleColor = UIColor.clear
var outsideButtonTitleColor = UIColor.clear
var outsideButtonBackgroundColor = UIColor.clear
var outsideNavigationTitleColor = UIColor.clear

//search bar text color
var searchBarTextColor = UIColor.clear
var searchBarPlaceHolderColor = UIColor.clear
var searchBarIconColor = UIColor.clear

//button height
let heightButton:CGFloat = 40.0

let spaccing: CGFloat = 20.0

var buttonRadius:CGFloat = 5
var buttonBorderWidth:CGFloat = 1
var buttonBorderColor = UIColor.black



// Application Background color
var appBackgroundColor = UIColor.white

//forground color
var appforgroundcolor = UIColor.clear

//Table View Seprator Color
var tableViewSeparatorColor = UIColor.clear

var appFontColor = UIColor.clear
var hashValueAppFontColor = "#ffffff"
var activityFeedLinkColor = UIColor.clear

var appSepratorColor = UIColor.clear

var noDataLabelTextColor = UIColor.clear
var navigationDisabledColor = UIColor.clear
var navigationActiveColor = UIColor.clear

var statsTextColor = UIColor.clear

var titleLightColor = UIColor.clear

let tabBarColor = UIColor.white

var starColor = UIColor.clear
let favouriteColor = UIColor(red:1.00, green:0.30, blue:0.30, alpha:1.0)

let linkActiveColor = UIColor.black

let ratingColor = starColor

let divideSepratorScaleValue = UIScreen.main.scale

let appLineHeight:CGFloat = 7


//menu screen
var menuCategoryColor = UIColor.clear
var composerFilterOptionsType:Int = 1

var menuGradientColor1:String = "#d7c0ac"
var menuGradientColor2:String = "#9abeb1"
var menuGradientColor3:String = "#19989e"
var menuGradientColor4:String = "#0f6a75"
var menuGradientColor5:String = "#085361"

var buttonBackgroundColor = UIColor.clear
var buttonTitleColor = UIColor.black

//styling

var contentProfilePageTabTitleColor = UIColor.clear
var contentProfilePageTabActiveColor = UIColor.clear
var contentProfilePageTabBackgroundColor = UIColor.clear

// Plugin menu
var menuButtonTitleColor = UIColor.clear
var menuButtonBackgroundColor = UIColor.clear
var menuButtonActiveTitleColor = UIColor.clear

//my content screen
var contentScreenTitleColor = UIColor.clear
var contentScreenTitleBackgroundColor = UIColor.clear
var contentScreenActiveColor = UIColor.clear

//font icons
let likeIcon = "\u{f164}"
let commentIcon = "\u{f075}"
let favouriteIcon = "\u{f004}"

//font
let boldFont = "Arial-BoldMT"
let fontName  = "HelveticaNeue"
let fontIcon = "FontAwesome"
let fontHTML : Int = 100
let kMain                       = "Main"
let kScreenWidth                = UIScreen.main.bounds.size.width
let kScreenHeight               = UIScreen.main.bounds.size.height

let kSharedUserDefaults         = UserDefaults.standard

