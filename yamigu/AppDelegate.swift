//
//  AppDelegate.swift
//  yamigu
//
//  Created by Yoon on 29/09/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import KakaoOpenSDK
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    
    var ref: DatabaseReference!
    var refHandle : DatabaseHandle!
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        guard let scheme = url.scheme else { return true }
        if KOSession.isKakaoAccountLoginCallback(url.absoluteURL) {
            return KOSession.handleOpen(url)
        }
        
        if KOSession.isKakaoAgeAuthCallback(url) {
            return KOSession.handleOpen(url)
        }
        return true
        
        
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        guard let scheme = url.scheme else { return true }
        if KOSession.isKakaoAccountLoginCallback(url.absoluteURL) {
            return KOSession.handleOpen(url)
        }
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //Messaging.messaging().apnsToken = deviceToken
        
        // Convert token to string (디바이스 토큰 값을 가져옵니다.)
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        // Print it to console(토큰 값을 콘솔창에 보여줍니다. 이 토큰값으로 푸시를 전송할 대상을 정합니다.)
        print("APNs device token: \(deviceTokenString)")
        
        Messaging.messaging().apnsToken = deviceToken
        
        
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessag
        
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        print("userInfo = \(userInfo["aps"]!)")
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        RunLoop.current.run(until: NSDate(timeIntervalSinceNow:1) as Date)
        
        
        // Override point for customization after application launch.
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        UITextViewWorkaround.unique.executeWorkaround()
        FirebaseApp.configure()
        
        
        Messaging.messaging().delegate = self
        
        // iOS 10 support
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        // 이미 등록된 토큰이 있는지 확인 없을 경우 nil 호출됨
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")
        /**************************** Push service end *****************************/
        
        
        
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                print("Remote InstanceID token: \(result.token)")
            }
        }
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        self.ref = Database.database().reference()
        self.refHandle = self.ref.child("user").child(userDictionary["uid"]! as! String).child("notifications").observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.children.allObjects as? [DataSnapshot] {
                badgeCount = 0
                for dict in dictionary {
                    if let data = dict.value as? Dictionary<String, Any> {

                        print("data = \(data)")
                        
                        if data["isUnread"] as! Bool {
                            badgeCount += 1
                        }
                    }
                }
                //UIApplication.shared.applicationIconBadgeNumber = badgeCount
                application.applicationIconBadgeNumber = badgeCount
            }
        })
    }
    
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        self.ref.removeObserver(withHandle: refHandle)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        KOSession.handleDidBecomeActive()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "yamigu")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    /*
     func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
     
     print("getget \(notification)")
     //notification.userInfo
     print("\(#function)")
     }Z*/
    
    /*func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
     print("Firebase registration token: \(fcmToken)")
     let dataDict:[String: String] = ["token": fcmToken]
     NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
     
     
     }*/
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
        
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        badgeCount = badgeCount + 1
        UIApplication.shared.applicationIconBadgeNumber = badgeCount
        // Print full message.
        let messageDict = userInfo as! [String : Any]
        print(messageDict)
        
        
        if "\(messageDict["content"]!)" == "인증이 완료되었어요! 즐거운 야미구 하세요!" {
            if let wd = UIApplication.shared.delegate?.window {
                var vc = wd!.rootViewController?.presentedViewController
                vc = vc?.topMostViewController()
                
                let alert = UIAlertController(title: "", message: "인증 완료 기념으로 미팅티켓 1장을 무료로 드렸어요.\n신청하기를 눌러 야미구를 시작해보세요!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action: UIAlertAction!) in
                    
                }))
                vc!.present(alert, animated: true, completion: nil)
            }
        }
        
        if let wd = UIApplication.shared.delegate?.window {
            var vc = wd!.rootViewController?.presentedViewController
        
            
            
            if(vc is UINavigationController) {
                vc = (vc as! UINavigationController).visibleViewController

            }
            
            if(vc is UITabBarController) {
                vc = vc?.topMostViewController()
                
                if(vc is HomeVC) {
                    let homeVC = vc as! HomeVC
                    /*let args = messageDict["intentArgs"] as! String
                    let argsData = args.data(using: .utf8)
                    let argsDict = try! JSONSerialization.jsonObject(with: argsData!, options: .allowFragments) as! [String: Any]
                    let type = (argsDict["type"] as! Int)
                    if  type == 3 || type == 5 {
                        homeVC.getMyMeeting(urlString: "http://106.10.39.154:9999/api/meetings/my/")
                    }*/
                    let args = messageDict["intentArgs"] as! String
                    if args == "" {
                        homeVC.getMyMeeting(urlString: "http://106.10.39.154:9999/api/meetings/my/")
                    }
                    
                    
                } else if(vc is ChattingVC) {
                    let chattingVC = vc as! ChattingVC
                    let args = messageDict["intentArgs"] as! String
                    let argsData = args.data(using: .utf8)
                    let argsDict = try! JSONSerialization.jsonObject(with: argsData!, options: .allowFragments) as! [String: Any]
                    
                    
                    print(chattingVC.matchDict)
                    if ("\(chattingVC.matchDict["id"]!)" == "\(argsDict["meeting_id"]!)") {
                        completionHandler([])
                    }
                }
            }

            if(vc is HomeVC) {
                let homeVC = vc as! HomeVC
                /*let args = messageDict["intentArgs"] as! String
                let argsData = args.data(using: .utf8)
                let argsDict = try! JSONSerialization.jsonObject(with: argsData!, options: .allowFragments) as! [String: Any]
                let type = (argsDict["type"] as! Int)
                if  type == 3 || type == 5 {
                    homeVC.getMyMeeting(urlString: "http://106.10.39.154:9999/api/meetings/my/")
                }*/
                let args = messageDict["intentArgs"] as! String
                if args == "" {
                    homeVC.getMyMeeting(urlString: "http://106.10.39.154:9999/api/meetings/my/")
                }
            }
            
            if(vc is ChattingVC){
                let chattingVC = vc as! ChattingVC
                let args = messageDict["intentArgs"] as! String
                let argsData = args.data(using: .utf8)
                let argsDict = try! JSONSerialization.jsonObject(with: argsData!, options: .allowFragments) as! [String: Any]
                
                
                print(chattingVC.matchDict)
                if ("\(chattingVC.matchDict["id"]!)" == "\(argsDict["meeting_id"]!)") {
                    completionHandler([])
                }
            }
        }
        
        print(messageDict)
        
        
        // Change this to your preferred presentation option
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        let message = userInfo as! [String: Any]
        
        if "\(message["content"]!)" == "인증이 완료되었어요! 즐거운 야미구 하세요!" {
            if let wd = UIApplication.shared.delegate?.window {
                var vc = wd!.rootViewController?.presentedViewController
                vc = vc?.topMostViewController()
                
                let alert = UIAlertController(title: "", message: "인증 완료 기념으로 미팅티켓 1장을 무료로 드렸어요.\n신청하기를 눌러 야미구를 시작해보세요!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action: UIAlertAction!) in
                    
                }))
                vc!.present(alert, animated: true, completion: nil)
            }
        } else {
            if let wd = UIApplication.shared.delegate?.window {
                var vc = wd!.rootViewController?.presentedViewController
                if(vc is UITabBarController) {
                    let tabbarVC = vc as! MainTC
                    vc = vc?.topMostViewController()
                    
                    if(vc is HomeVC) {
                        if "\(message["clickAction"]!)" == ".ChattingActivity" {
                            let args = message["intentArgs"] as! String
                            let argsData = args.data(using: .utf8)
                            let intentArgs = try! JSONSerialization.jsonObject(with: argsData!, options: .allowFragments) as! [String: Any]
                            print(message)
                            
                                   let meetingId = intentArgs["meeting_id"] as! String
                                   self.goChatVC(meetingId: meetingId)
                        }
                    } else {
                        if(vc is RegisterMeetingVC) {
                            vc?.dismiss(animated: false, completion: {
                                if "\(message["clickAction"]!)" == ".ChattingActivity" {
                                    let args = message["intentArgs"] as! String
                                    let argsData = args.data(using: .utf8)
                                    let intentArgs = try! JSONSerialization.jsonObject(with: argsData!, options: .allowFragments) as! [String: Any]
                                    print(message)
                                    
                                           let meetingId = intentArgs["meeting_id"] as! String
                                           self.goChatVC(meetingId: meetingId)
                                }
                            })
                        } else {
                            DispatchQueue.main.async {
                                tabbarVC.selectedIndex = 0
                                if "\(message["clickAction"]!)" == ".ChattingActivity" {
                                    let args = message["intentArgs"] as! String
                                    let argsData = args.data(using: .utf8)
                                    let intentArgs = try! JSONSerialization.jsonObject(with: argsData!, options: .allowFragments) as! [String: Any]
                                    print(message)
                                    
                                           let meetingId = intentArgs["meeting_id"] as! String
                                           self.goChatVC(meetingId: meetingId)
                                }
                            }
                            
                        }
                    }
                }
                
            }
        }
        
        
        
       
        
        
        completionHandler()
    }
    
    func goChatVC(meetingId : String) {
        if let wd = UIApplication.shared.delegate?.window {
            var vc = wd!.rootViewController?.presentedViewController
            
            if(vc is UITabBarController) {
                let homevc = vc?.topMostViewController() as! HomeVC
                homevc.goChatting(meetingId: meetingId)
            }
        }
    }
}
extension UIViewController {
    func topMostViewController() -> UIViewController {
        
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        }
        
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }
        
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }
        
        return self
    }
}
