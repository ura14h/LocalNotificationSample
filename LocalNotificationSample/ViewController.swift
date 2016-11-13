//
//  ViewController.swift
//  LocalNotificationSample
//
//  Created by Hiroki Ishiura on 2016/11/13.
//  Copyright © 2016年 Hiroki Ishiura. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func didTapReminderButton(_ sender: Any) {
		scheduleNotification()
	}

	// MARK: -
	
	func scheduleNotification() {
		let identifier = "reminder"
		let title = "Hello!"
		let body = "Are you sure to display the first scene?"
		let delay: TimeInterval = 10.0
		let badge = UIApplication.shared.applicationIconBadgeNumber + 1
		
		// Schedule a notification.
		if #available(iOS 10.0, *) {
			let content = UNMutableNotificationContent()
			content.title = title
			content.body = body
			content.sound = UNNotificationSound.default()
			content.badge = badge as NSNumber
			let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
			let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
			
			UNUserNotificationCenter.current().removeAllDeliveredNotifications()
			UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
			UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
			
		} else {
			let notification = UILocalNotification()
			notification.alertTitle = title
			notification.alertBody = body
			notification.fireDate = Date(timeIntervalSinceNow: delay)
			notification.soundName = UILocalNotificationDefaultSoundName
			notification.applicationIconBadgeNumber = badge
			notification.userInfo = [ "identifier": identifier ]
			
			UIApplication.shared.cancelAllLocalNotifications()
			UIApplication.shared.scheduleLocalNotification(notification)
			
		}
	}
}

