//
//  CoreDataManage.swift
//  GitUser
//
//  Created by Boon on 03/11/2022.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {
    
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

    func saveUserList(array: [ModelUser], completion: @escaping (_ result: Bool) -> ()){
        contextSave.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        contextSave.automaticallyMergesChangesFromParent = true
        
        //Init index=0 as string index of array to be use later in Batch Insert Request
        var index = 0
        
        // Create batch insert request
        let batchInsertRequest = NSBatchInsertRequest(entity: UserList.entity(), managedObjectHandler: { (managedObject) -> Bool in
            
            //Get ModelUser from array based on index
            let user = array[index]
            
            //User Mirror reflect to properties of User, then set managedObject value
            let _ = Mirror(reflecting: user).children.map { child in
                guard let key = child.label else { return }
                
                //Convert child.value to AnyObject as it always return Optional(value)
                let value = child.value as AnyObject
                
                //Check the type if NOT NSNull then do not proceed, because the value is not able to save in core data
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
        }
        catch{
            print("Error Insert Core Data")
        }
    }
    
    func getUserList(array: [ModelUser], completion: @escaping (_ result: Bool) -> ()){
        
    }
}
