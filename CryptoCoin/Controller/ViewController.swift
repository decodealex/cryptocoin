//
//  ViewController.swift
//  CryptoCoin
//
//  Created by admin on 10.01.2018.
//  Copyright © 2018 skovcustom. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

//CoinsViewController
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, NSFetchedResultsControllerDelegate, UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let previewView = storyboard?.instantiateViewController(withIdentifier: "singleCoinView")
        return previewView
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        let finalView = storyboard?.instantiateViewController(withIdentifier: "singleCoinView")
        show(finalView!, sender: self)
    }
    
    
    
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var crypts: [Crypt] = []
    var images = ["defaultImage", "downArrow", "upArrow"]
    var refreshControl = UIRefreshControl()
    var filteredCrypts = [Crypt]()
    var managedObjectContext: NSManagedObjectContext? = nil
    
    
    
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Checking for supporting 3D-touch
        if traitCollection.forceTouchCapability == UIForceTouchCapability.available {
            registerForPreviewing(with: self, sourceView: view)
        }
        else {
            print("3D-TOUCH NOT SUPPORTED")
        }
        
        self.crypts = AppStorage.getObject(ofType: [Crypt].self, forKey: "crypts", priority: .permanent) ?? []
        
        self.navigationController?.view.backgroundColor = UIColor.white
        self.refreshData()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
        self.refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        self.tableView.refreshControl = self.refreshControl
        self.refreshControl.layer.zPosition = -1
        var nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "customCell")
        
        searchController.searchResultsUpdater = self as! UISearchResultsUpdating
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Coin"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
//        self.tableView.backgroundColor = .red
//        self.tableView.layer.backgroundColor = UIColor(red: 22/255, green: 54/255, blue: 62/255, alpha: 1)
        
        
        //        let logo = UIImage(named: "defaultImage")
        //        let navigationImage = UIImageView(image: logo)
        //        self.navigationItem.titleView = navigationImage
        
//        
//        var respond = UIResponder()
//        CustomTableViewCell.touchesBegan(respond)
        
//
//        let addButton = UIBarButtonItem(UIBarButtonItemStyle: .add, target: self, action: #selector(insertNewObject(_:)))
//        navigationItem.rightBarButtonItem = addButton
        
    }
    
    // refreshData
    
    @objc func refreshData() {
        self.loadData {
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    // MARK: - UITableViewDataSource
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredCrypts.count
        }
        return self.crypts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableViewCell
        let crypt: Crypt
        if isFiltering() {
            crypt = filteredCrypts[indexPath.row]
        }
        else {
             crypt = self.crypts[indexPath.row]
        }
        cell.configure(withModel: crypt)
        
        // actions when refreshControl.isRefreshing
        
//        if refreshControl.isRefreshing {
//            cell.changeLabel.layer.borderWidth = 1
//            let marginSpace = CGFloat(integerLiteral: 3)
//            let insets = UIEdgeInsets(top: marginSpace, left: marginSpace, bottom: marginSpace, right: marginSpace)
//            cell.changeLabel.layoutMargins = insets
//
//            let when = DispatchTime.now() + 1.5 // change  to desired number of seconds
//            DispatchQueue.main.asyncAfter(deadline: when) {
//                cell.changeLabel.layer.borderWidth = 0
//            }
//        }
        
        var changes = crypt.percent_change_24h
        print(changes, "test")
        var changesInt = Float(changes)
        print(changesInt, "floatChange")
        
        // actions when  < 0 changesInt >0
        
        if changesInt! > 0.00 {
            cell.arrowImage.image = UIImage(named: "upArrow")
            cell.changeLabel.textColor = UIColor(displayP3Red: 82.0/255.0, green: 146.0/255.0, blue: 96.0/255.0, alpha: 1)
        }
        else {
            cell.arrowImage.image = UIImage(named: "downArrow")
            cell.changeLabel.textColor = .red
        }
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchController.searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.endEditing(true)
    }
   
    
    // MARK: - LoadData
    
    func loadData(completion: @escaping(() -> Void)) {
        
        Alamofire.request("https://api.coinmarketcap.com/v1/ticker/", method: .get).responseData { (response) in
            
            guard let data = response.data else {
                return
            }
            do {
                let decoder = JSONDecoder()
                let crypts = try decoder.decode([Crypt].self, from: data)
                
                AppStorage.setObject(crypts, forKey: "crypts", priority: .permanent)
                
                print(crypts)
                self.crypts = crypts
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    completion()
                }
            } catch {
            }
        }
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let crypt = self.crypts[indexPath.row]
        let crypt: Crypt
        if isFiltering() {
            crypt = filteredCrypts[indexPath.row]
//            searchController.searchBar.endEditing(true)
        }
        else {
            crypt = self.crypts[indexPath.row]
        }
        self.performSegue(withIdentifier: "toSingleCoinViewTableController", sender: crypt)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let SingleCoinTableViewController = segue.destination as? SingleCoinTableViewController, let crypt = sender as? Crypt {
            SingleCoinTableViewController.coinTitleName = crypt.name
            SingleCoinTableViewController.idSingleCoin = crypt.id
            SingleCoinTableViewController.title = crypt.name
        }
        
        if let favouriteTableViewController = segue.destination as? FavouriteTableViewController {
            favouriteTableViewController.crypts = self.crypts
        }
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredCrypts = crypts.filter({ (crypt: Crypt) -> Bool in
            return crypt.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}

// MARK: - UISearchController

let searchController = UISearchController(searchResultsController: nil)
extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController : UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}





