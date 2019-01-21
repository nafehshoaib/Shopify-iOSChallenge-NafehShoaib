//
//  CustomCollectionsCollectionViewController.swift
//  ShopifyTest
//
//  Created by Nafeh Shoaib on 2019-01-08.
//  Copyright © 2019 nafehshoaib. All rights reserved.
//

import UIKit
import ViewAnimator

private let reuseIdentifier = "CustomCollectionCollectionViewCell"

class CustomCollectionsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    var customCollections = [CustomCollection]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    private let sectionInsets = UIEdgeInsets(top: 10,
                                             left: 10,
                                             bottom: 10,
                                             right: 10)
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredCustomCollections = [CustomCollection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Begin the CollectionView's refresh control refreshing
        self.collectionView.refreshControl?.beginRefreshing()
        // Add getData() as its target using an @obj selector, to be executed when the user triggers a refresh
        self.collectionView.refreshControl?.addTarget(self, action: #selector(getData), for: .valueChanged)
        // Get product data using helper function
        self.getData()
        // Setup the searchBar
        self.setupSearch()
    }
    
    /** Helper method that sets data to array from Services using Shopify API. */
    @objc func getData() {
        // Access the Services class's getCustomCollections method to get data from the API,
        // using a completion handler to handle the data once it is downloaded
        Services().getCustomCollections { result in
            // Safely set the customCollections array as the completion handler's result parameter's value
            if let value = result.value {
                self.customCollections = value
            }
            // Reload the collectionView to update the new data
            self.collectionView?.reloadData()
            // end the Refreshing of the refresh Control to
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    /** Search Controller Setup. */
    func setupSearch() {
        // Since Implementing UISearchController through Storyboards is not completely supported
        // yet on UICollectionViewControllers, it is done here programatically
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        // Set the placeholder for the searchBar
        searchController.searchBar.placeholder = "Search Custom Collections"
        // Set the bar Style of the search bar as black, to make the text white, conforming to the design of the view
        searchController.searchBar.barStyle = .black
        // Set the search bar to be minimal to work well with the design of the view
        searchController.searchBar.searchBarStyle = .minimal
        // set the navigationItem's search controller as this searchController, for it to appear at the bottom of the navBar
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
    }
    
    // Set the status bar's elements to be white, as the navBar's design has a dark colour
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        // Check if segue identifier matches the one specified on the storyboard
        if segue.identifier == "CollectionToProductsSeque" {
            // Safeley cast the selected cell as CustomCollectionViewCell, and then get its indexPath
            guard let selectedCell = sender as? CustomCollectionCollectionViewCell,
                let indexPath = collectionView.indexPath(for: selectedCell) else {
                    preconditionFailure("selected cell not custom collection view cell")
            }
            // Safely cast the destinationController as ProductsTableViewController
            guard let destinationController = segue.destination as? ProductsTableViewController else {
                preconditionFailure("segue destination not product table view controller")
            }
            
            // Once both indexPath and destinatinationController are available,
            // Get the customCollection data of the selected cell using the index path
            let customCollection = isFiltering() ? filteredCustomCollections[indexPath.row] : customCollections[indexPath.row]
            // Set the destinationContoller's customCollection variable to said data, to correctly handle the transition and
            // show the correct date.
            destinationController.customCollection = customCollection
        }
    }

    // MARK: UICollectionViewDataSource
    
    // Since there are only one type of collection cell currently, return 1
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    // Return the number of items depending on if user is searching or not
    // If user is searching, return the filtered array's count, otherwise, the total collection array's count,
    // using Swifty syntax that first has a boolean, that it is filtering, and then the value if true followed by
    // the value if false after a colon.
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isFiltering() ? filteredCustomCollections.count : customCollections.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        if let collectionCell = cell as? CustomCollectionCollectionViewCell {
            // Configure the cell using the CustomCollectionViewCell's setup helper method by first checking if user
            // is searching using aforementioned Swift syntax, passing in the correct array's element.
            isFiltering() ? collectionCell.setup(using: filteredCustomCollections[indexPath.row]) : collectionCell.setup(using: customCollections[indexPath.row])
            // return this collectionCell
            return collectionCell
        }
        // if the cell is not a CustomCollectionViewCell, then return the cell without casting.
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    // MARK: UICollectionView Flow Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    // MARK: UISearchController
    /** Helper method to check if user is filtering. */
    func isFiltering() -> Bool {
        // return using Swift's boolean algebra syntax
        return searchController.isActive && !searchBarIsEmpty()
    }
    /** Helper method to check if the searchBar is empty. */
    func searchBarIsEmpty() -> Bool {
        // return using Swift's conditional boolean return syntax
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    /** Helper method that filters content based on searchText. */
    func filteredContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredCustomCollections = customCollections.filter { customCollection in
            return customCollection.title!.lowercased().contains(searchText.lowercased())
        }
        self.collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        self.filteredContentForSearchText(searchController.searchBar.text!)
    }
    
}
