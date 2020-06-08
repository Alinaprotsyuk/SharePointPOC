//
//  SharePointPresenter.swift
//  BerkleyAppPOC
//
//  Created by Alina Protsiuk on 5/28/19.
//  Copyright © 2019 CoreValue. All rights reserved.
//

import Foundation
import WebKit

class SharePointPresenter {
    weak var view: SharePointView?
    let interactor: SharePointInteractor
    
    var items = [Item]()
    var columns = [Column]()
    var data: DataSitesId?
    var userData = [String: String]()
    
    var isFiltering = false
    var filteredItems = [Item]()
    var searchText = ""
    var selectedIndexPath: IndexPath?
    var editedSelectedSection: Int?
    var selectedSections = [Int]()
    
    let kDefaultSpace: CGFloat = 30.0
    
    init(interactor: SharePointInteractor) {
        self.interactor = interactor
    }
    
    //MARK: - functions
    func attachView(_ view: SharePointView) {
        self.view = view
    }
    
    func getInitialData() {
        interactor.getInitialInfo(completion: { [weak self] (data, userData, error) in
            if let error = error {
                self?.view?.showError(error)
            } else {
                self?.data = data
                self?.userData = userData ?? [String: String]()
                self?.view?.setup(title: data?.displayName ?? "")
                self?.getAllItems()
            }
        })
    }
    
    func getAllItems() {
        view?.showActivity()
        interactor.getAllItems { [unowned self] (result, data, error) in
            self.view?.hideActivity()
            if let error = error {
                self.view?.showError(error)
            } else {
                if let account = data {
                    self.createAccountView(account)
                }
                
                self.items = result?.items ?? [Item]()
                if let columns = result?.columns {
                    self.columns = columns.filter({ (column) -> Bool in
                        guard let readOnly = column.readOnly else { return false }
                        if column.name != "ContentType" && column.name != "Attachments" {
                            return !readOnly
                        } else {
                            return false
                        }
                    })
                    
                }
                // find max element in every column
                let fields = self.items.map({ $0.fields }) ?? [Dictionary<String, Any>]()
                if !self.columns.isEmpty,
                    !fields.isEmpty {
                    for index in 0..<self.columns.count {
                        var stringArray = fields.map({ (dict) -> String in
                            guard let text = dict[self.columns[index].name ?? ""] as? String else { return "" }
                            return text
                        })
                        
                        stringArray.insert(self.columns[index].displayName ?? "", at: 0)
                        
                        if let maxText = stringArray.max(by: { $0.count < $1.count}) {
                            self.columns[index].width = maxText.widthOfString(usingFont: UIFont.systemFont(ofSize: 12.0)) + self.kDefaultSpace
                        }
                    }
                }
                
                self.view?.success()
            }
        }
    }
    
    private func maximum<T: Comparable>(_ array: [T]) -> T? {
        guard var maximum = array.first else { return nil }
        
        for element in array.dropFirst() {
            maximum = element > maximum ? element : maximum
        }
        return maximum
    }
    
    private func createAccountView(_ account: [String: String]) {
        userData = account
        view?.createAccountView()
    }
    
    func editItem(for row: Int, on text: String) {
        //TODO: - if needed
    }
    
    func save(text: String) {
        //TODO: - if needed
    }
    
    //don't use now
    func signOut() {
        interactor.signOut()
    }
    
    func sortByUp(name: String) {
        view?.showActivity()
        let sort = items.sorted { (item1, item2) -> Bool in
            let d1 = String(describing: item1.fields[name] ?? "")
            let d2 = String(describing: item2.fields[name] ?? "")
            
            return d1.uppercased() < d2.uppercased()
        }
        print(sort)
        items = sort
        view?.hideActivity()
        view?.success()
    }
    
    func sortByDown(name: String) {
        view?.showActivity()
        let sort = items.sorted { (item1, item2) -> Bool in
            let d1 = String(describing: item1.fields[name] ?? "")
            let d2 = String(describing: item2.fields[name] ?? "")
            
            return d1.uppercased() > d2.uppercased()
        }
        print(sort)
        items = sort
        view?.hideActivity()
        view?.success()
    }
    
    func filter() {
         filteredItems = items.map { (item) -> Item? in
            let dict = item.fields
            var isInclude = false
            dict.values.forEach({ (value) in
                let text = String(describing: value)
                let include = text.contains(searchText)
                if include {
                    isInclude = include
                }
            })
            if isInclude {
                return item
            } else {
                return nil
            }
            }.compactMap({ $0 })
        view?.reload()
    }
}

