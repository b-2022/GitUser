//
//  VcUserList.swift
//  GitUser
//
//  Created by Boon on 01/11/2022.
//

import UIKit

class VcUserList: UIViewController, ViewModelUserListDelegate, NetworkDelegate {
    
    var viewModel: ViewModelUserList = ViewModelUserList()
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var searchBar: UISearchBar?
    
    @IBOutlet weak var offlineHeightConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        
        Network.shared.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.loadData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - ViewModelUserListDelegate
    func dataLoaded() {
        self.tableView?.reloadData()
    }
    
    func updateTable(){
        
    }
    
    // MARK: - NetworkDelegate
    func network(connection: Bool) {
        if connection {
            offlineHeightConstraint?.constant = 0
        }
        else{
            offlineHeightConstraint?.constant = 25
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToDetails" {
            let vc = segue.destination as? VcUserDetails
            vc?.login = sender as? String ?? ""
        }
        else if segue.identifier == "segueToDetailsSwiftUI"{
            let vc = segue.destination as? SwiftUIViewHostingController
            vc?.login = sender as? String ?? ""
        }
    }
}

extension VcUserList: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.userList?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.cell(indexPath: indexPath))
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segueToDetails", sender: viewModel.userList?[indexPath.row].login)
//        performSegue(withIdentifier: "segueToDetailsSwiftUI", sender: viewModel.userList?[indexPath.row].login)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //Configure cell data when going to display, to reduce memory usage
        if let _cell = cell as? CellNormalConfig {
            if let user = viewModel.userList?[indexPath.row]{
                _cell.configCellData(user: user)
            }
        }
        
        //Check if search bar dont have text then, then load data
        if !(searchBar?.text?.count ?? 0 > 0) {
            if indexPath.row >= (viewModel.userList?.count ?? 0)-1{
                viewModel.loadData()
            }
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
