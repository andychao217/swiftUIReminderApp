//
//  MyList+CoreDataClass.swift
//  RemindersApp
//
//  Created by Andy Chao on 2024/11/15.
//

import Foundation
import CoreData

@objc(MyList)
public class MyList : NSManagedObject {
	var remindersArray: [Reminder] {
		reminders?.allObjects.compactMap { ($0 as! Reminder) } ?? []
	}
}
