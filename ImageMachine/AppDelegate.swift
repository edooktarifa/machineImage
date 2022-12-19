//
//  AppDelegate.swift
//  ImageMachine
//
//  Created by Phincon on 14/12/22.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let tabBarController = UITabBarController()
        
        let firstViewController = CodeReaderViewController()
        
        let tabBarItemQr:UITabBarItem = UITabBarItem(title: "QR Reader", image: UIImage(named: "qrcode")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "qrcode"))
        
        firstViewController.tabBarItem = tabBarItemQr
        
        let secondViewController = MachineDataViewController()
        secondViewController.view.backgroundColor = .white
        let tabBarMachine:UITabBarItem = UITabBarItem(title: "Image Machine", image: UIImage(named: "machine")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "machine"))
        secondViewController.tabBarItem = tabBarMachine
        
        
        let controllers = [secondViewController, firstViewController].map { (viewController) -> UINavigationController in
            UINavigationController(rootViewController: viewController)
        }
        
        tabBarController.setViewControllers(controllers, animated: true)
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        CoreDataManager.sharedManager.saveContext()
      }
    
}

