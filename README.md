#  Shopify iOS Internship Summer 2019 Challenge Submission
This project is my submission for the Shopify Intern Challenge for the iOS Software Engineering Summer 2019 Intern Position at Shopify in Ottawa, Toronto, and Montreal. This App displays data from a given API in the form of UICollectionViews and UITableViews. There are added features like Search, 3D Touch, Animations, and an Info page.

The project has the following third-party dependecies and uses CocoaPods for package management:

* Alamofire - for HTTP Requests
* SwiftyJSON - for parsing data
* ViewAnimator - for build-in animations
* GhostyTypewriter - for info page animations

# Getting Started
### System Requirements
macOS Mojave or later has been tested and Xcode is required to build this project.

### Instructions
To clone this project in Xcode, click "Clone or download" and select "Open in Xcode".

# Features
This app displays a list of custom collections in a UICollectionViewController using the first HTTP API, as per the requirements of the challenge. Each cell includes the image and title of the collections. The API uses the URL below:

```
https://shopicruit.myshopify.com/admin/custom_collections.json
```

The user can then either 3D-Touch the cell to peek into the contents of the collection and then pop into the view controller itself, or tap the cell to go straight into the view controller.

The app then displays the list of products pertaining to that specific custom collection in a UITableViewController, with a top cell that includes the collection's title, description, and image . The user can also press the back button on the Navigation Bar to take them back to the collection page. The app uses asynchronous calls to two API's, by first getting a list of product ID's by calling the collects API:

```
https://shopicruit.myshopify.com/admin/collects.json
```

It then uses the product ID's compiled from this request to get product information by calling the Products API:

```
https://shopicruit.myshopify.com/admin/products.json
```

These Products API call is made once the Collects API call is finished and returned a successful string of comma-separated product ID's. These asynchronous calls are made using Swift's completion handler feature in functions and closures to nest API calls.

All views are designed using AutoLayout Constraints.

# File Structure and MVC
This Xcode project follows the Model-View-Controller paradigm, as do most iOS Apps and as has been officially recommended by Apple. The file structure for relevant files for this App is as follows:
* Services.swift: consolidates all Alamofire API Calls and houses a few Extensions
* Models: Includes Swift classes that provide custom models to be used to parse API Request results. Includes convenience initializers to construct objects using incoming raw SwiftyJSON data.
* Cell: Includes UICollectionViewCell and UITableViewCell classes for all ViewControllers with data cells.
* ViewControllers: Includes the UICollectionViewController and UITableViewController classes for the Collection and Product Views. Also includes a UIViewController class for the Info View.
* Main.storyboard: Includes all Design-related specifications using AutoLayout and Storyboard-segues
* Assets.xcassets: Includes all images used for this app


# Code Structure
## Services
All API Related code is confined to the Services class, which houses three Alamofire API Calls. The three public functions contain relevant parameters and a completion handler as their arguments. The completion handler is then called using **Grand Central Dispatch** asynchronously when the data is loaded successfully. All JSON parsing is handled by each respective Model class. The three API's that is used in other swift classes are as follows:

Custom Collections:
```swift
public func getCustomCollections(completion: @escaping (Result<[CustomCollection]>) -> Void) { }
```

Collects:
```swift
public func getCollects(for id: Double, completion: @escaping (Result<[Collect]>) -> Void) { }
```

Products:
```swift
public func getProducts(withProductIDs ids:[Int], completion: @escaping (Result<[Product]>) -> Void) { }
```

## Models
Each model uses primitive classes for simple data storage and UIKit's data classes for data like images and dates. Each model includes both a simple constructor (initializer), and a convenience intializer that parses SwiftyJSON data using the former initializer. The result of this implementation is a much more concise and cleaner code-base that consolidates roles.

Here's an example of a convenience initializer:
```swift
convenience init(fromJSON json: JSON) {
    self.init(
        id: json["id"].doubleValue,
        title: json["title"].stringValue,
        price: json["price"].doubleValue,
        sku:  json["sku"].stringValue,
        position: json["position"].doubleValue,
        inventoryQuantity: json["inventory_quantity"].intValue,
        requiresShipping: json["requires_shipping"].boolValue
    )
}
```

## Cells
Each cell class takes care of its own animations, view design, and data-setting using data from the viewcontrollers as custom Models with setup methods. An example of this can be seen below:

```swift
public func setup(using customCollection: CustomCollection) {
    self.backgroundColor = .white
    self.titleLabel.text = customCollection.title?.components(separatedBy: " ")[0]
    self.imageView.image = customCollection.image
}
```

## ViewControllers
View controllers do all API calls via the Services class, connects all views like cells, search bars, and button actions. All actions are organized by  `// MARK:- ` comments to allow Xcode to enable jumping between lines of code by section.

API calls via the Services class are handled using Swift's closures asynchronously, and the view is adapted accordingly. Here's an example:
```swift
Services().getCustomCollections { result in
    if let value = result.value {
        self.customCollections = value
    }
    self.collectionView?.reloadData()
    self.collectionView.refreshControl?.endRefreshing()
}
```

In the case of transferring data from one view controller to another, the `prepare(for:)` method is used to first switch cases of segue identifiers, and then send information by casting cells and destination view controllers appropriately.

# Code Style
Swift's code style is embraced in this project. The simplest example is the use of `if let` checks to ensure safety in app execution. Another instance is the map method is used in Arrays and Dictionaries to quickly transform each element of an array or dictionary into another variable. Here's an example:

```swift
let variants = json["variants"].map {
    Variant(fromJSON: $1)
}
```

Another instance is with shorter notations for forked boolean checks, to perform different operations based on the result of a boolean. Here's an example to illustrate this:
```swift
return isFiltering() ? fileteredProducts.count : products.count
```

This is also evident in the use of Swift's generics, especially useful in reloading data automatically and using sorting predicates.
Reload:
```swift
var products = [Product]() {
    didSet {
        self.tableView.reloadData()
    }
}
```

Predicates:
```swift
var minPrice: Double {
    return variants.min { a, b in a.price < b.price }!.price
}
```


**This project was created by Nafeh Shoaib**
