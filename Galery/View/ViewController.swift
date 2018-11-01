//
//  ViewController.swift
//  Galery
//
//  Created by Milan Schon on 27/10/2018.
//  Copyright © 2018 Milan Schon. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate, UISearchBarDelegate {
    
    // main view controlle
    // custom data sources for tableview
    fileprivate var dataSource:TableViewDataSource<TableViewCell,TableCellVieWModel>!
    //listviewmodel
    fileprivate var listViewModel:ListViewModel!
    //cell identifier
    fileprivate let celldentifier = "search_result"
    //outlers
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var imageTableView: UITableView!
    
 

    override func viewDidLoad() {
        super.viewDidLoad()
        // initializing view controller and calling populating cells when there are new images
        listViewModel = ListViewModel()
        // setting table view with data from download
        dataSource = TableViewDataSource(cellIntetifier: celldentifier, items: self.listViewModel.sourceViewModel, configurationCell: { (cell, viewModel) in
            cell.descriptLabel.text = viewModel.description
            cell.dimensionLabel.text = viewModel.dimensions
            cell.mainImageView.image = viewModel.image
        })
        // initial query and delegates
        self.populateListView(query: "iphone a ipad ")
        imageTableView.delegate = self
        imageTableView.dataSource = dataSource
        searchBar.delegate = self
    }
    // prepering the custom segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "imageDetail" {
            if let position = imageTableView.indexPathForSelectedRow?.row {
//                sending data to view controller
                let controller = segue.destination as! ImageDetailVC
                let tableViewModels = self.dataSource.getItems() as [TableCellVieWModel]
//                maping view model
                let urls = tableViewModels.map {
                    $0.imagePath!
                }
//                sending all urls to image view controller
                controller.items = urls
                controller.position = position
            }
            
        }
    }
    // calls when search bar gets triggered
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard var searchText = searchBar.text  else {
            return
        }
        searchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        // search query have to be minimum 3 letters
        if searchText.count >= 3 {
            //than populate the webview
           self.populateListView(query: searchText)
        }
    }
    // populating data of datasource and reloading the table view
    fileprivate func populateListView (query:String) {
        dataSource.releaseItems()
        let defaulURLPath = SearchQuery(params: SearchParms(query: query, step: "20", from: "21"))
        let urlPath = defaulURLPath.build
        listViewModel.populateData(urlPath: urlPath) { [weak self] (tableItem, error) in
            self?.dataSource.addItem(model:tableItem)
            self?.imageTableView.reloadData()
        }
    }
    //custom zoom out seque when is released
    @IBAction func prepaForUnwind (segue:UIStoryboardSegue) {
        
    }
    // calling segue when image viewcontroller gets relead
    override func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
        let segue = UnwindScaleSegue(identifier: unwindSegue.identifier, source: unwindSegue.source, destination: unwindSegue.destination) {
            
        }
        segue.perform()
    }
    // calling alert if there is no internet connection
    override func viewDidAppear(_ animated: Bool) {
        if !CheckInternet.Connection(){
            self.Alert(Message: "Your Device is not connected with internet")
        }
    }
    func Alert (Message: String){
        let alert = UIAlertController(title: "Alert", message: Message, preferredStyle: UIAlertController.Style.alert)
//        alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

