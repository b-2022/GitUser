//
//  ViewModelUser.swift
//  GitUser
//
//  Created by Boon on 01/11/2022.
//

import Foundation
import UIKit

protocol ViewModelUserListDelegate: AnyObject {
    func dataLoaded()
    func updateTable()
}

class ViewModelUserList: NSObject {
    
    var userList: [User]? {
        didSet{
            DispatchQueue.main.async {
                self.delegate?.dataLoaded()
            }
        }
    }

    var lastId: Int = 0
    var offset: Int = 0
    weak var delegate: ViewModelUserListDelegate?
    
    override init() {
        userList = [User]()
    }
    
    func cell(indexPath: IndexPath) -> String {
        if indexPath.row != 0 && (indexPath.row+1) % 4 == 0 {
            return TableCellType.inverted.cellIdentifier
        }
        
        if userList?[indexPath.row].note != nil {
            return TableCellType.noted.cellIdentifier
        }
        
        return TableCellType.normal.cellIdentifier
        
    }
    
    func loadData(){
        let length = Int.random(in: 10..<20)
        if let array = CoreDataManager.shared.getUserList(offset: offset, length: length){
            offset += array.count
            lastId = Int(array[array.count-1].id)
            
            userList?.append(contentsOf: array)
            return
        }
            
        callApi(since: lastId)
    }
    
    func searchText(text: String){
        if text.count == 0 {
            offset = 0

            loadData()
            return
        }
        
        userList = CoreDataManager.shared.searchUser(text: text)
    }
    
    private func callApi(since: Int){
        ApiHelper.shared.getUserList(since: since) { [weak self] result, data, status in
            if result {
                if let array = data {
                    self?.lastId = array[array.count-1].id ?? 0
                    
                    CoreDataManager.shared.saveUserList(array: array) { result in
                        self?.loadData()
                    }
                }
            }
        }
    }
}
