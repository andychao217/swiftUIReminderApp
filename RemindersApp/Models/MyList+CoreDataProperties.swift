//
//  MyList+CoreDataProperties.swift
//  RemindersApp
//
//  Created by Andy Chao on 2024/11/15.
//

import Foundation
import CoreData
import UIKit

extension MyList {
	@nonobjc public class func fetchRequest() -> NSFetchRequest<MyList> {
		return NSFetchRequest<MyList>(entityName: "MyList")
	}
	
	@NSManaged public var name : String
	@NSManaged public var color : UIColor
	@NSManaged public var reminders : NSSet?
}

extension MyList: Identifiable {
	
}

// MARK: Generated accessors for notes
extension MyList {
	@objc(addRemindersObject:)
	@NSManaged public func addToReminders(_ value: Reminder)
	
	@objc(removeRemindersObject:)
	@NSManaged public func removeFromReminders(_ value: Reminder)
	
	@objc(addReminders:)
	@NSManaged public func addToReminders(_ values: NSSet)
	
	@objc(removeReminders:)
	@NSManaged public func removeFromReminders(_ values: NSSet)
}
