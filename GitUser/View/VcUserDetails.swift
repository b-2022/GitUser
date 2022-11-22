//
//  VcUserDetails.swift
//  GitUser
//
//  Created by Boon on 01/11/2022.
//

import UIKit

class VcUserDetails: UIViewController {
    
    @IBOutlet weak var imageProfile: UIImageView?
    @IBOutlet weak var lblFollowers: UILabel?
    @IBOutlet weak var lblFollowing: UILabel?
    @IBOutlet weak var lblName: UILabel?
    @IBOutlet weak var lblCompany: UILabel?
    @IBOutlet weak var lblBlog: UILabel?
    @IBOutlet weak var txtNote: UITextView?
    
    @IBOutlet weak var offlineHeightConstraint: NSLayoutConstraint?
    
    var login: String = ""
    var viewModel: ViewModelUserDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ViewModelUserDetails()
        viewModel?.delegate = self
        viewModel?.loadData(login: login)
        
        self.txtNote?.layer.borderWidth = 1.0
        self.txtNote?.layer.borderColor = UIColor.gray.cgColor
        
        Network.shared.startMonitor { connection in
            if connection {
                self.offlineHeightConstraint?.constant = 0
            }
            else{
                self.offlineHeightConstraint?.constant = 25
            }
        }
    }
    
    @IBAction func clickedSave(_ sender: UIButton) {
        txtNote?.resignFirstResponder()
        viewModel?.saveNote(txtNote?.text ?? "")
    }
}

extension VcUserDetails: ViewModelUserDetailsDelegate{
    func responseSuccessRetrieve(user: User) {
        imageProfile?.loadImage(urlString: user.avatar_url ?? "")
        lblFollowers?.text = "\(user.detail?.followers ?? 0)"
        lblFollowing?.text = "\(user.detail?.following ?? 0)"
        lblName?.text = user.detail?.name
        lblCompany?.text = user.detail?.company
        lblBlog?.text = user.detail?.blog
        
        txtNote?.text = user.note?.note
    }
    
    func responseFailedRetrieve() {
        
    }
    
    func responseSaveNoteSuccess(){
        
    }
}
