//
//  CoreDataManage.swift
//  GitUser
//
//  Created by Boon on 03/11/2022.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {
    static let shared: CoreDataManager = CoreDataManager()
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GitUser")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            

            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var contextSave = persistentContainer.newBackgroundContext()
    lazy var contextRead = persistentContainer.viewContext

    func saveUserList(array: [ModelUser], completion: (_ result: Bool) -> ()){
        contextSave.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        contextSave.automaticallyMergesChangesFromParent = true
        
        //Init index=0 as string index of array to be use later in Batch Insert Request
        var index = 0
        
        // Create batch insert request
        let batchInsertRequest = NSBatchInsertRequest(entity: User.entity(), managedObjectHandler: { (managedObject) -> Bool in
            
            //Get ModelUser from array based on index
            let user = array[index]
            
            //User Mirror reflect to properties of User, then set managedObject value
            let _ = Mirror(reflecting: user).children.map { child in
                guard let key = child.label else { return }
                
                //Convert child.value to AnyObject as it always return Optional(value)
                let value = child.value as AnyObject
                
                //Check the type if NOT NSNull then proceed, because the value is not able to save in core data
                if type(of: value) != NSNull.self {
                    managedObject.setValue(value, forKey: key)
                }
            }
            
            index += 1
            
            //Return true if index more or equal to array count, or else it will be infite loop
            return index>=array.count ? true : false
        })
        
        
        //Execute core data BatchInsertRequest
        do{
            try contextSave.execute(batchInsertRequest)
            completion(true)
        }
        catch{
            print("Error Insert Core Data")
            completion(false)
        }
    }
    
    func updateUserDetails(user: ModelUser, completion: ((_ result: Bool, _ data: User?) -> ())? = nil){
        let fetchUser: NSFetchRequest<User> = User.fetchRequest()
        fetchUser.predicate = NSPredicate(format: "login = %@", user.login!)

        do{
            let result = try? contextSave.fetch(fetchUser)
            if result?.count ?? 0 > 0 {
                guard let coreDataUser = result?.first else { return }
                
                coreDataUser.detail = UserDetail(context: contextSave)
                
                let _ = Mirror(reflecting: user).children.map { child in
                    guard let key = child.label else { return }
                    
                    //Convert child.value to AnyObject as it always return Optional(value)
                    let value = child.value as AnyObject
                    
                    //Check the type if NOT NSNull then proceed, because the value is not able to save in core data
                    if type(of: value) != NSNull.self {
                        print((coreDataUser.detail?.entity.attributesByName.keys.contains(key) ?? false))
                        if (coreDataUser.detail?.entity.attributesByName.keys.contains(key) ?? false){
                            coreDataUser.detail?.setValue(value, forKey: key)
                        }
                    }
                }
                
                try contextSave.save()
                
                completion?(true, coreDataUser)
                return
            }
            
            completion?(false, nil)
        }
        catch{
            print("Update User Error: \(error)")
            completion?(false, nil)
        }
    }
    
    func updateUserNote(user: User, note: String) -> Bool {
        do{
            let coreDataUser = contextSave.object(with: user.objectID) as? User
            
            if coreDataUser?.note == nil {
                coreDataUser?.note = UserNote(context: contextSave)
            }
            
            coreDataUser?.note?.note = note
                
            try contextSave.save()
            
            return true
        }
        catch{
            print("Update User Error: \(error)")
            return false
        }
    }
    
    func getUserList(offset: Int, length: Int) -> [User]? {
        let fetchUser: NSFetchRequest<User> = User.fetchRequest()
        fetchUser.fetchOffset = offset
        fetchUser.fetchLimit = length

        let result = try? contextRead.fetch(fetchUser)
        
        if result?.count ?? 0 > 0 {
            return result
        }
        
        return nil
    }
    
    func getUser(login: String) -> User? {
        let fetchUser: NSFetchRequest<User> = User.fetchRequest()
        fetchUser.predicate = NSPredicate(format: "login = %@", login)

        let result = try? contextRead.fetch(fetchUser)
        if result?.count ?? 0 > 0 {
            guard let user = result?.first else { return nil }
            
            return user
        }
        
        return nil
    }
    
    func searchUser(text: String) -> [User]? {
        let fetchUser: NSFetchRequest<User> = User.fetchRequest()
        fetchUser.predicate = NSPredicate(format: "login LIKE %@", text)

        let result = try? contextRead.fetch(fetchUser)
        
        if result?.count ?? 0 > 0 {
            if let _result = result {
                return _result
            }
        }
        
        return nil
    }
    
}
