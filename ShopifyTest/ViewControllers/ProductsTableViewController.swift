//
//  ProductsTableViewController.swift
//  ShopifyTest
//
//  Created by Nafeh Shoaib on 2019-01-08.
//  Copyright © 2019 nafehshoaib. All rights reserved.
//

import UIKit
import ViewAnimator

class ProductsTableViewController: UITableViewController, UISearchResultsUpdating {
    
    let productReuseIdentifier = "ProductTableViewCell"
    let collectionHeaderReuseIdentifier = "CollectionHeader"
    
    var customCollection: CustomCollection?
    var collectId: Double!
    
    var products = [Product]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    var fileteredProducts = [Product]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let animations = [AnimationType.from(direction: .right, offset: 30.0)]
    
    private let sectionInsets = UIEdgeInsets(top: 10,
                                             left: 10,
                                             bottom: 10,
                                             right: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var collection = self.customCollection?.title!.components(separatedBy: " ")
        collection?.removeLast()
        self.title = collection?.joined(separator: " ")
        self.collectId = customCollection?.id
        self.tableView.refreshControl?.addTarget(self, action: #selector(getCollects), for: .valueChanged)
        
        self.setupSearchBar()
        
        self.getCollects()
    }
    
    @objc func getCollects() {
        Services().getCollects(for: self.collectId) { result in
            if let collects = result.value {
                let ids = collects.map { Int($0.productID) }
                self.getProducts(ids: ids)
            }
        }
    }
    
    func getProducts(ids: [Int]) {
        Services().getProducts(withProductIDs: ids) { result in
            if let value = result.value {
                self.products = value
                self.reloadTableViewWithAnimations()
            }
        }
    }
    
    func reloadTableViewWithAnimations() {
        self.tableView.reloadData()
        UIView.animate(views: self.tableView.visibleCells(in: 1), animations: self.animations)
        self.refreshControl?.endRefreshing()
    }
    
    func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Custom Collections"
        searchController.searchBar.barStyle = .black
        searchController.searchBar.searchBarStyle = .minimal
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return isFiltering() ? fileteredProducts.count : products.count
        default:
            return 1
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: collectionHeaderReuseIdentifier, for: indexPath) as! ProductCollectionTableViewCell
            cell.setup(usingCustomCollection: customCollection!)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: productReuseIdentifier, for: indexPath) as! ProductTableViewCell
            isFiltering() ? cell.setup(using: fileteredProducts[indexPath.row]) : cell.setup(using: products[indexPath.row])
            return cell
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: UISearchController
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filteredContentForSearchText(_ searchText: String, scope: String = "All") {
        fileteredProducts = products.filter { product in
            return product.title.lowercased().contains(searchText.lowercased())
        }
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredContentForSearchText(searchController.searchBar.text!)
    }

}
