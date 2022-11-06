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

protocol CellConfig {
    func configCellData(user: ModelUser)
}

class TableViewCellNormal: UITableViewCell, CellConfig{
    @IBOutlet weak var imageProfile: UIImageView?
    @IBOutlet weak var lblName: UILabel?
    @IBOutlet weak var lblDetails: UILabel?
    
    var item: ModelUser? {
        didSet{
            if let imageURL = item?.avatar_url {
                imageProfile?.loadImage(urlString: imageURL, completion: { [weak self] img in
                    guard let self = self else { return }
                    self.imageProfile?.image = img
                })
            }
            self.imageProfile?.layer.cornerRadius = (self.imageProfile?.bounds.width ?? 0)/2
            lblName?.text = item?.name
            lblDetails?.text = item?.type
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configCellData(user: ModelUser) {
        self.item = user
    }
}

class TableViewCellNote: TableViewCellNormal{
    @IBOutlet weak var imageNote: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class TableViewCellInverted: TableViewCellNormal{
    override var item: ModelUser? {
        didSet{
            imageProfile?.image = imageProfile?.image?.invertColor()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
