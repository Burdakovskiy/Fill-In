//
//  AppDelegate.swift
//  Fill In
//
//  Created by Дмитрий on 16.10.2025.
//

import UIKit
import RealmSwift
import FirebaseCore
import GoogleSignIn
import FBSDKCoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        let config = Realm.Configuration(
            schemaVersion: 1) { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                    
                }
            }
        Realm.Configuration.defaultConfiguration = config
        
        do {
            _ = try Realm()
            print("Realm sucessfuly initialized")
        } catch {
            print("Realm initialization error: \(error)")
        }
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) { }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let handledByFB = ApplicationDelegate.shared.application(app, open: url, options: options)
        let handledByGoogle = GIDSignIn.sharedInstance.handle(url)
        return handledByFB || handledByGoogle
    }
}

