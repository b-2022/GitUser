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
    
    func configCellData(user: User?)
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
        self.imageProfile?.layer.cornerRadius = (self.imageProfile?.bounds.width ?? 0)/2
        self.imageProfile?.image = UIImage(named: "user")
    }
    
    func configCellData(user: User?) {
        if let user = user{
            if let imageURL = user.avatar_url {
                self.imageProfile?.loadImage(urlString: imageURL, completion: { [weak self] img in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.imageProfile?.image = img
                    }
                })
            }
            
            lblName?.text = user.login
            lblDetails?.text = user.type
        }
    }
    
    func deallocCellData(){
        imageProfile?.image = nil
        lblName?.text = nil
        lblDetails?.text = nil
    }
}

class TableViewCellNote: TableViewCellNormal, CellNoteConfig{
    @IBOutlet weak var imageNote: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class TableViewCellInverted: TableViewCellNormal{
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func configCellData(user: User?) {
        super.configCellData(user: user)
        
        if let user = user {
            //Check if image profile not default image, then invert image
            if !(imageProfile?.image?.isEqual(UIImage(named: "user")) ?? false) {
                let newImage = imageProfile?.image?.invertColor()
                imageProfile?.image = newImage
            }
        }
    }
}
