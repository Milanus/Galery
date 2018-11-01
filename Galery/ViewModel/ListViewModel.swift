//
//  ListViewModel.swift
//  Galery
//
//  Created by Milan Schon on 28/10/2018.
//  Copyright © 2018 Milan Schon. All rights reserved.
//

import UIKit
// Representand view model for tableview
class ListViewModel {
    // contains all cell values
    fileprivate (set) var sourceViewModel:[TableCellVieWModel] = [TableCellVieWModel]()
    fileprivate var dataSource :DataSource!
    fileprivate let path = "https://www.obrazky.cz/searchAjax?q=iphone%10ipad&s=&step=20&size=any&color=any&filter=true&from=11"
    
// populate data of viewmodel with image, dimension,
    func populateData (urlPath:String?, reloadHandler:@escaping (TableCellVieWModel,String?)->())  {
        
        if dataSource != nil {
            if dataSource.isSubscribed() {
                dataSource.unsubscribe()
            }
        }
        self.dataSource = DataSource(urlPath: urlPath ?? path, complete: { dataModel,error in
            DispatchQueue.main.async {
                reloadHandler(TableCellVieWModel(dataModel: dataModel),error)
            }
        })
        // starting data source
        self.dataSource.start()

    }
}
// table view cell viewmodel
class TableCellVieWModel {
    let dimensions:String?
    var image:UIImage?
    let description:String?
    var imagePath:String?
    
    init(dimensions:String, image:UIImage?,description:String,imagePath:String?) {
        self.dimensions = dimensions
        self.image = image
        self.description = description
        self.imagePath = imagePath
    }
    // init from datamodel all values
    init (dataModel:DataModel) {
        self.dimensions = dataModel.dimension
        self.image = dataModel.image
        self.description = dataModel.title
        self.imagePath = dataModel.imagePath
    }
}
