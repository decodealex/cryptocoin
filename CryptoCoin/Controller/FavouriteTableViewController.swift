//
//  FavouriteTableViewController.swift
//  CryptoCoin
//
//  Created by admin on 05.02.2018.
//  Copyright © 2018 skovcustom. All rights reserved.
//

import UIKit
import Alamofire

class FavouriteTableViewController: UITableViewController, UISearchBarDelegate {
    

    var cryptsFavourite: [Crypt] = []
    var filteredCryptsFavourite = [Crypt]()
    
    @IBOutlet var favouriteTableView: UITableView! {
        didSet {
            favouriteTableView.delegate = self
            favouriteTableView.dataSource = self
        }
    }
    
    
    var favCrypts: [Crypt] = []
    var images = ["defaultImage", "downArrow", "upArrow"]
    var favRefreshControl = UIRefreshControl()
    var favFilteredCrypts = [Crypt]()
    
    
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshData()
        self.favRefreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
        self.favRefreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        self.tableView.refreshControl = self.favRefreshControl
        self.favRefreshControl.layer.zPosition = -1
        var nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "customCell")
        
        favSearchController.searchResultsUpdater = self as UISearchResultsUpdating
        favSearchController.obscuresBackgroundDuringPresentation = false
        favSearchController.searchBar.placeholder = "Search Coin"
        navigationItem.searchController = favSearchController
        definesPresentationContext = true
        
        //        self.tableView.backgroundColor = .red
        //        self.tableView.layer.backgroundColor = UIColor(red: 22/255, green: 54/255, blue: 62/255, alpha: 1)
        
        
        //        let logo = UIImage(named: "defaultImage")
        //        let navigationImage = UIImageView(image: logo)
        //        self.navigationItem.titleView = navigationImage
        
        //
        //        var respond = UIResponder()
        //        CustomTableViewCell.touchesBegan(respond)
        
        
    }
    
    // refreshData
    
    @objc func refreshData() {
        self.loadData {
            DispatchQueue.main.async {
                self.favRefreshControl.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    // MARK: - UITableViewDataSource
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return favFilteredCrypts.count
        }
        return self.favCrypts.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableViewCell
        let crypt: Crypt
        if isFiltering() {
            crypt = favFilteredCrypts[indexPath.row]
        }
        else {
            crypt = self.favCrypts[indexPath.row]
        }
        cell.configure(withModel: crypt)
        
        // actions when refreshControl.isRefreshing
        
        if favRefreshControl.isRefreshing {
            cell.changeLabel.layer.borderWidth = 1
            let marginSpace = CGFloat(integerLiteral: 3)
            let insets = UIEdgeInsets(top: marginSpace, left: marginSpace, bottom: marginSpace, right: marginSpace)
            cell.changeLabel.layoutMargins = insets
            
            let when = DispatchTime.now() + 1.5 // change  to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                cell.changeLabel.layer.borderWidth = 0
            }
        }
        
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
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        favSearchController.searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        favSearchController.searchBar.endEditing(true)
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
                print(crypts)
                self.favCrypts = crypts
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    completion()
                }
            } catch {
            }
        }
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let crypt = self.crypts[indexPath.row]
        let crypt: Crypt
        if isFiltering() {
            crypt = favFilteredCrypts[indexPath.row]
            //            searchController.searchBar.endEditing(true)
        }
        else {
            crypt = self.favCrypts[indexPath.row]
        }
        self.performSegue(withIdentifier: "toSingleCoinViewController", sender: crypt)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let singleCoinViewController = segue.destination as? SingleCoinViewController, let crypt = sender as? Crypt {
            singleCoinViewController.coinTitleName = crypt.name
            singleCoinViewController.idSingleCoin = crypt.id
            singleCoinViewController.title = crypt.name
        }
    }
    
    func searchBarIsEmpty() -> Bool {
        return favSearchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String) {
        favFilteredCrypts = favCrypts.filter({ (crypt: Crypt) -> Bool in
            return crypt.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return favSearchController.isActive && !searchBarIsEmpty()
    }

// MARK: - UISearchController

//let favSearchController = UISearchController(searchResultsController: nil)
////extension ViewController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        filterContentForSearchText(searchController.searchBar.text!)
//}

//    func favUpdateSearchResults(for searchController : UISearchController) {
//        filterContentForSearchText(searchController.searchBar.text!)
//    }
    
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.title = "Favorites"
//        // Uncomment the following line to preserve selection between presentations
//        // self.clearsSelectionOnViewWillAppear = false
//
//        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//        // self.navigationItem.rightBarButtonItem = self.editButtonItem
//    }
//

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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - LoadData
    

}

// MARK: - UISearchController

let favSearchController = UISearchController(searchResultsController: nil)
extension FavouriteTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController : UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
