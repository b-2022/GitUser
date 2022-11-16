//
//  UserNote+CoreDataProperties.swift
//  GitUser
//
//  Created by Boon on 15/11/2022.
//
//

import Foundation
import CoreData


extension UserNote {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserNote> {
        return NSFetchRequest<UserNote>(entityName: "UserNote")
    }

    @NSManaged public var note: String?
    @NSManaged public var user: User?

}

extension UserNote : Identifiable {

}
