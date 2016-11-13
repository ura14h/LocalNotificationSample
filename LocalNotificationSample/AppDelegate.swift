//
//  AppDelegate.swift
//  LocalNotificationSample
//
//  Created by Hiroki Ishiura on 2016/11/13.
//  Copyright © 2016年 Hiroki Ishiura. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

	var window: UIWindow?


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.

		// Clean up notification.
		if application.applicationIconBadgeNumber > 0 {
			application.applicationIconBadgeNumber = 0
		}
		if #available(iOS 10.0, *) {
			// See UNUserNotificationCenterDelegate
			
		} else {
			if let launchOptions = launchOptions, let notification = launchOptions[UIApplicationLaunchOptionsKey.localNotification] as? UILocalNotification {
				application.cancelLocalNotification(notification)
			}
			
		}
		
		// Permit using notificaiton.
		if #available(iOS 10.0, *) {
			let center = UNUserNotificationCenter.current()
			let options: UNAuthorizationOptions = [ .alert, .sound, .badge]
			center.requestAuthorization(options: options, completionHandler: { (granted, error) in
			})
			center.delegate = self

		} else {
			let type: UIUserNotificationType = [ .alert, .sound, .badge ]
			let category: Set<UIUserNotificationCategory>? = nil
			let settings = UIUserNotificationSettings(types: type, categories: category)
			application.registerUserNotificationSettings(settings)
			application.registerForRemoteNotifications()
			
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

		if application.applicationIconBadgeNumber > 0 {
			application.applicationIconBadgeNumber = 0
		}
	
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}

	// MARK: -
	
	// MARK: Notification handler for iOS 9
	
	func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
		// Sent when the application receives a local notification.
		// If the app is not active in the foreground when the notification fires, the system uses the information in the UILocalNotification object to determine whether it should display an alert, badge the app icon, or play a sound.
		// If the app is running in the foreground, the system calls this method directly without alerting the user in any way.

		if #available(iOS 10.0, *) {
			// See UNUserNotificationCenterDelegate
		} else {

			// Clean up notification.
			if application.applicationIconBadgeNumber > 0 {
				application.applicationIconBadgeNumber = 0
			}
			application.cancelLocalNotification(notification)
			
			// Execute custom action.
			guard
				let window = application.keyWindow,
				let navigationController = window.rootViewController as? UINavigationController else {
					return
			}
			if application.applicationState == .active {
				// Show a view controller for notificaiton when the app is in foreground mode.

				// Execute custom action with alert dialog.
				let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self] (action) in
					self?.executeCustomAction(navigationController: navigationController)
				})
				let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
				let alertController = UIAlertController(title: notification.alertTitle, message: notification.alertBody, preferredStyle: .alert)
				alertController.addAction(defaultAction)
				alertController.addAction(cancelAction)
				if let currentController = navigationController.viewControllers.last {
					currentController.present(alertController, animated: true, completion: nil)
				}

			} else {
				// Show a view controller for notificaiton when the app is in background mode.

				executeCustomAction(navigationController: navigationController)
				
			}
		}
	}

	// MARK: Notification handler  for iOS 10
	
	@available(iOS 10.0, *)
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		// Called when a notification is delivered to a foreground app.
		
		completionHandler([ .alert, .sound, .badge ])
	}
	
	@available(iOS 10.0, *)
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		// Called to let your app know which action was selected by the user for a given notification.
		
		let application = UIApplication.shared
		
		// Clean up notification.
		if application.applicationIconBadgeNumber > 0 {
			application.applicationIconBadgeNumber = 0
		}
		UNUserNotificationCenter.current().removeAllDeliveredNotifications()
		UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

		// Execute custom action.
		guard
			let window = application.keyWindow,
			let navigationController = window.rootViewController as? UINavigationController else {
				return
		}
		executeCustomAction(navigationController: navigationController)

		completionHandler()
	}

	// MARK: -
	
	func executeCustomAction(navigationController: UINavigationController) {
		let animatable = navigationController.isViewLoaded && navigationController.view.window != nil
		navigationController.popToRootViewController(animated: animatable)
	}
}

