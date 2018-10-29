//
//  ListViewModel.swift
//  Galery
//
//  Created by Milan Schon on 28/10/2018.
//  Copyright © 2018 Milan Schon. All rights reserved.
//

import UIKit

class ListViewModel {
    fileprivate (set) var sourceViewModel:[TableCellVieWModel] = [TableCellVieWModel]()
    fileprivate var dataSource :DataSource!
    fileprivate let path = "https://www.obrazky.cz/searchAjax?q=iphone%10ipad&s=&step=20&size=any&color=any&filter=true&from=11"
    

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
        self.dataSource.start()

    }
}

class TableCellVieWModel {
    let dimensions:String?
    var image:UIImage?
    let description:String?
    
    init(dimensions:String, image:UIImage?,description:String) {
        self.dimensions = dimensions
        self.image = image
        self.description = description
    }
    init (dataModel:DataModel) {
        self.dimensions = dataModel.dimension
        self.image = dataModel.image
        self.description = dataModel.title
    }
}
