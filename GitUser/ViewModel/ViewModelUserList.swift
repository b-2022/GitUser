//
//  ViewModelUser.swift
//  GitUser
//
//  Created by Boon on 01/11/2022.
//

import Foundation
import UIKit

protocol ViewModelUserListDelegate {
    func loadedAPI()
}

class ViewModelUserList: NSObject {
    
    lazy var userList: [ModelUser] = [ModelUser]() {
        didSet{
            DispatchQueue.main.async {
                self.delegate?.loadedAPI()
            }
        }
    }
    lazy var searchUserList: [ModelUser] = [ModelUser]()
    var delegate: ViewModelUserListDelegate?
    
    override init() {
        super.init()
    }
    
    func loadData(){
        callApi(since: 0)
    }
    
    private func callApi(since: Int){
        ApiHelper.getUserList(since: since) { [weak self] result, data, status in
            if result {
                if let array = data {
                    self?.userList.append(contentsOf: array)
                    CoreDataManager().saveUserList(array: array) { result in
                        print("Success Save")
                    }
                }
            }
        }
    }
    
}
