//
//  VcUserList.swift
//  GitUser
//
//  Created by Boon on 01/11/2022.
//

import UIKit

class VcUserList: UIViewController, ViewModelUserListDelegate {
    
    var viewModel: ViewModelUserList = ViewModelUserList()
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var searchBar: UISearchBar?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.loadData()
    }
    
    func loadedAPI() {
        self.tableView?.reloadData()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToDetails" {
            let vc = segue.destination as? VcUserDetails
        }
    }
}

extension VcUserList: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: TableCellType.normal.cellIdentifier)

        if indexPath.row % 3 == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: TableCellType.inverted.cellIdentifier)
        }

        print("Cell : \(cell)")
        if let _cell = cell as? CellConfig {
            print("Cell 2 : \(_cell)")
            _cell.configCellData(user: viewModel.userList[indexPath.row])
        }
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "segueToDetails", sender: nil)
    }
}


