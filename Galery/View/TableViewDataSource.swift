//
//  TableViewDataSource.swift
//  Galery
//
//  Created by Milan Schon on 28/10/2018.
//  Copyright © 2018 Milan Schon. All rights reserved.
//

import UIKit

class TableViewDataSource<Cell:UITableViewCell,ViewModel> :NSObject,UITableViewDataSource {
    
    private var cellIdentifier:String!
    private var items:[ViewModel]!
    var configuration:(Cell,ViewModel) -> ()
    
    init(cellIntetifier:String,items:[ViewModel], configurationCell:@escaping (Cell,ViewModel) ->()) {
        self.cellIdentifier = cellIntetifier
        self.items = items
        self.configuration = configurationCell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cell identifier \(String(describing: self.cellIdentifier))")
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! Cell
        let item = self.items[indexPath.row]
        self.configuration(cell,item)
        return cell
    }
    
    func addItem(model:ViewModel) {
        items.append( model)
    }
    
    func releaseItems () {
        items.removeAll()
    }
}
