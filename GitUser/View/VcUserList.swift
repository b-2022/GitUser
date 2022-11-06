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
    
    // MARK: - ViewModelUserListDelegate
    func dataLoaded() {
        self.tableView?.reloadData()
    }
    
    func updateTable(){
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToDetails" {
            let vc = segue.destination as? VcUserDetails
            vc?.login = sender as? String ?? ""
        }
        else if segue.identifier == "segueToDetailsSwiftUI"{
            let vc = segue.destination as? VcUserDetails
            vc?.login = sender as? String ?? ""
        }
    }
}

extension VcUserList: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.userList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: TableCellType.normal.cellIdentifier)

        if indexPath.row != 0 && indexPath.row % 3 == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: TableCellType.inverted.cellIdentifier)
        }
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segueToDetails", sender: viewModel.userList?[indexPath.row].login)
//        performSegue(withIdentifier: "segueToDetailsSwiftUI", sender: viewModel.userList[indexPath.row].login)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //Configure cell data when going to display, to reduce memory usage
        if let _cell = cell as? CellNormalConfig {
            _cell.configCellData(user: viewModel.userList?[indexPath.row])
        }
        
        if indexPath.row >= (viewModel.userList?.count ?? 0)-1{
            viewModel.loadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //Dealloc cell data when out of screen, to reduce memory usage
        if let _cell = cell as? CellNormalConfig {
            _cell.deallocCellData()
        }
    }
}

extension VcUserList: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchText(text: searchText)
    }
}
