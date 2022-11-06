//
//  ViewModelUserDetails.swift
//  GitUser
//
//  Created by Boon on 05/11/2022.
//

import UIKit

protocol ViewModelUserDetailsDelegate: AnyObject {
    func responseSuccessRetrieve(user: User)
    func responseFailedRetrieve()
    func responseSaveNoteSuccess()
}

class ViewModelUserDetails: NSObject {
    private var login: String = ""
    
    weak var delegate: ViewModelUserDetailsDelegate?
    
    var user: User?

    func loadData(login: String){
        self.login = login
        loadData()
    }
    
    func saveNote(_ string: String){
        if let user = user {
            if CoreDataManager.shared.updateUserNote(user: user, note: string) {
                delegate?.responseSaveNoteSuccess()
            }
        }
    }
    
    private func loadData(){
        //Get user from local core data
        if let _user = CoreDataManager.shared.getUser(login: login) {
            //Check if user details is not empty
            if _user.detail != nil{
                //Resposne user to view controller
                user = _user
                self.delegate?.responseSuccessRetrieve(user: _user)
                return
            }
        }
        
        //If data not exist, call api to download data
        loadAPI()
    }
    
    private func loadAPI(){
        ApiHelper.getUserDetails(user: login) { [weak self] result, data, status in
            if result {
                if let data = data {
                    //Get user info from api and save to database
                    CoreDataManager.shared.updateUserDetails(user: data) { result, data in
                        if result {
                            guard let _user = data else {
                                self?.delegate?.responseFailedRetrieve()
                                return
                            }
                            
                            self?.user = _user
                            //Response delegate with data
                            self?.delegate?.responseSuccessRetrieve(user: _user)
                            return
                        }
                        
                        self?.delegate?.responseFailedRetrieve()
                    }
                }
            }
            else{
                self?.delegate?.responseFailedRetrieve()
            }
        }
    }
}
