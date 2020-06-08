//
//  EditViewPresenter.swift
//  BerkleyAppPOC
//
//  Created by Alina Protsiuk on 5/28/19.
//  Copyright © 2019 CoreValue. All rights reserved.
//

import Foundation

class EditViewPresenter {
    weak var view: EditView?
    var item: Item?
    let interactor: EditViewInteractor
    var columns = [Column]()
    var dictionary = [String: String]()
    
    init(interactor: EditViewInteractor) {
        self.interactor = interactor
    }
    
    //MARK: - functions
    func attachView(view: EditView) {
        self.view = view
    }
    
    func saveChanges() {
        view?.showActivity()
        interactor.prepare(id: item?.id, parameters: dictionary) { [weak self] (result, error) in
            self?.view?.hideActivity()
            if let error = error {
                self?.view?.showErrorMessage(error)
            } else {
                if result is Item,
                    let newItem = result as? Item {
                    self?.view?.didReceiveNewItemFileds(newItem)
                }
                if result is Dictionary<String, Any>,
                    let editedItem = result as? Dictionary<String, Any> {
                    self?.view?.didReceiveEditedItemFileds(editedItem)
                }
            }
        }
    }
}
