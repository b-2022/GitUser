//
//  TableViewDataSource.swift
//  GitUser
//
//  Created by Boon on 05/11/2022.
//

import UIKit

enum TableCellType{
    case normal, noted, inverted
    
    var cellIdentifier: String {
        switch self {
            case .normal:
                return "TableViewCellNormal"
            case .noted:
                return "TableViewCellNote"
            case .inverted:
                return "TableViewCellInverted"
        }
    }
}

protocol CellNormalConfig {
    var imageProfile: UIImageView? { get set }
    var lblName: UILabel? { get set }
    var lblDetails: UILabel? { get set }
    
    func configCellData(user: User)
    func deallocCellData()
}

protocol CellNoteConfig{
    var imageNote: UIImageView? { get set }
}

class TableViewCellNormal: UITableViewCell, CellNormalConfig{
    @IBOutlet weak var imageProfile: UIImageView?
    @IBOutlet weak var lblName: UILabel?
    @IBOutlet weak var lblDetails: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Set Image Profile round and default image 'user'
        self.imageProfile?.layer.cornerRadius = (self.imageProfile?.bounds.width ?? 0)/2
        self.imageProfile?.image = UIImage(named: "user")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageProfile?.image = UIImage(named: "user")
    }
    
    func configCellData(user: User) {
        loadData(user: user)
        
        //Check if imageURL NOT nill and not empty string, then proceed to download image from server
        if let imageURL = user.avatar_url, !(user.avatar_url?.isEmpty ?? false) {
            self.imageProfile?.loadImage(urlString: imageURL, completion: { [weak self] img in
                DispatchQueue.main.async {
                    if let _image = img {
                        self?.imageProfile?.image = _image
                    }
                }
            })
        }
    }
    
    func deallocCellData(){
        imageProfile?.image = nil
        lblName?.text = nil
        lblDetails?.text = nil
    }
    
    fileprivate func loadData(user: User){
        lblName?.text = user.login
        lblDetails?.text = user.type
    }
}

class TableViewCellNote: TableViewCellNormal, CellNoteConfig{
    @IBOutlet weak var imageNote: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func configCellData(user: User) {
        super.configCellData(user: user)
    }
}

class TableViewCellInverted: TableViewCellNormal{
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func configCellData(user: User) {
        super.loadData(user: user)
        
        //Check if imageURL NOT nill and not empty string, then proceed to download image from server
        if let imageURL = user.avatar_url, !(user.avatar_url?.isEmpty ?? false) {
            self.imageProfile?.loadImage(urlString: imageURL, completion: { [weak self] image in
                DispatchQueue.main.async {
                    //If response image not nil, invert color of image and set image profile with latest
                    if let _image = image {
                        self?.imageProfile?.image = _image.invertColor()
                    }
                }
            })
        }
    }
}
