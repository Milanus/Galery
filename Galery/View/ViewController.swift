//
//  ViewController.swift
//  Galery
//
//  Created by Milan Schon on 27/10/2018.
//  Copyright © 2018 Milan Schon. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate, UISearchBarDelegate {
    
    
    fileprivate var dataSource:TableViewDataSource<TableViewCell,TableCellVieWModel>!
    fileprivate var listViewModel:ListViewModel!
    fileprivate let celldentifier = "search_result"
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var imageTableView: UITableView!
    
 

    override func viewDidLoad() {
        super.viewDidLoad()
        listViewModel = ListViewModel()
        dataSource = TableViewDataSource(cellIntetifier: celldentifier, items: self.listViewModel.sourceViewModel, configurationCell: { (cell, viewModel) in
            cell.descriptLabel.text = viewModel.description
            cell.dimensionLabel.text = viewModel.dimensions
            cell.mainImageView.image = viewModel.image

        })
        self.populateListView(query: "iphone a ipad ")
        imageTableView.delegate = self
        imageTableView.dataSource = dataSource
        searchBar.delegate = self
      
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard var searchText = searchBar.text  else {
            return
        }
        searchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if searchText.count > 3 {
           self.populateListView(query: searchText)
        }
    }
    
    fileprivate func populateListView (query:String) {
        dataSource.releaseItems()
        let defaulURLPath = SearchQuery(params: SearchParms(query: query, step: "20", from: "21"))
        let urlPath = defaulURLPath.build
        listViewModel.populateData(urlPath: urlPath) { (tableItem, error) in
            self.dataSource.addItem(model:tableItem)
            self.imageTableView.reloadData()
        }
    }


}

