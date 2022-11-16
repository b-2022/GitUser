//
//  UserDetail+CoreDataProperties.swift
//  GitUser
//
//  Created by Boon on 15/11/2022.
//
//

import Foundation
import CoreData


extension UserDetail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserDetail> {
        return NSFetchRequest<UserDetail>(entityName: "UserDetail")
    }

    @NSManaged public var bio: String?
    @NSManaged public var blog: String?
    @NSManaged public var company: String?
    @NSManaged public var created_at: String?
    @NSManaged public var email: String?
    @NSManaged public var followers: Int32
    @NSManaged public var following: Int32
    @NSManaged public var hireable: String?
    @NSManaged public var location: String?
    @NSManaged public var name: String?
    @NSManaged public var public_gists: Int32
    @NSManaged public var public_repos: Int32
    @NSManaged public var twitter_username: String?
    @NSManaged public var updated_at: String?
    @NSManaged public var user: User?

}

extension UserDetail : Identifiable {

}
