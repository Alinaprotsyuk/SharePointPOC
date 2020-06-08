//
//  EditViewController.swift
//  BerkleyAppPOC
//
//  Created by Alina Protsiuk on 5/28/19.
//  Copyright © 2019 CoreValue. All rights reserved.
//

import UIKit

class EditViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    var editItemClouser: ((Dictionary<String, Any>) -> Void)?
    var createItemClouser: ((Item) -> Void)?
    
    var presenter: EditViewPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.attachView(view: self)
    }
    
    deinit {
        editItemClouser = nil
        createItemClouser = nil
    }
    
    func setup(networkManager: NetworkService) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        self.navigationItem.title = " "
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        let clientText = "Client"
        if presenter.item == nil {
            title = "Add Create \(clientText)"
            saveBarButton.title = "Add"
        } else {
            title = "Edit \(clientText)"
            saveBarButton.title = "Edit"
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func setup(networkManager: NetworkService, item: Item, and columns: [Column]) {
        presenter = EditViewPresenter(interactor: EditViewInteractor(networkManager: networkManager))
        presenter.item = item
        presenter.columns = columns
    }
    
    func setup(networkManager: NetworkService, columns: [Column]) {
        presenter = EditViewPresenter(interactor: EditViewInteractor(networkManager: networkManager))
        presenter.columns = columns
    }
    
    //MARK: - Actions
    @IBAction func didPressCancelButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didPressSaveButton(_ sender: UIBarButtonItem) {
        if presenter.dictionary.isEmpty {
            showAlert(and: "There are nothing for saving")
        } else {
            presenter.saveChanges()
        }
    }
}

//MARK: - UITableViewDataSource
extension EditViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.columns.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if presenter.columns[indexPath.row].displayName?.lowercased() == "attachments" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.identifier)
                as? ButtonTableViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            return cell
        } else if let textType = presenter.columns[indexPath.row].text,
            let allowMultipleLines = textType.allowMultipleLines,
            allowMultipleLines {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextViewTableViewCell.identifier)
                as? TextViewTableViewCell else {
                return UITableViewCell()
            }
            cell.textView.placeholder = presenter.columns[indexPath.row].displayName?.capitalized
            
            if let fields = presenter.item?.fields,
                let name = presenter.columns[indexPath.row].name,
                let data = fields[name] {
                cell.setup(text: String(describing: data))
            }
            
            cell.textView.accessibilityIdentifier = presenter.columns[indexPath.row].name
            
            return cell
            
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier)
                as? TextFieldTableViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.textField.placeholder = presenter.columns[indexPath.row].displayName?.capitalized
            
            if let fields = presenter.item?.fields,
                let name = presenter.columns[indexPath.row].name,
                let data = fields[name] {
                cell.setup(text: String(describing: data), required: presenter.columns[indexPath.row].required ?? false)
            }
            
            cell.textField.accessibilityIdentifier = presenter.columns[indexPath.row].name
            
            return cell
        }
        
    }
}

//MARK: - ButtonTableViewCellDelegate
extension EditViewController: ButtonTableViewCellDelegate {
    func didPressAddButton() {
        print("Button press")
    }
}

//MARK: - TextFieldTableViewCellDelegate
extension EditViewController: TextFieldTableViewCellDelegate {
    func textFieldDidEndEditing(text: String, key: String) {
        print(text, " - ", key)
        presenter.dictionary[key] = text.isEmpty ? nil : text
    }
}

//MARK: - EditView
extension EditViewController: EditView {
    func didReceiveEditedItemFileds(_ item: Dictionary<String, Any>) {
        editItemClouser?(item)
        navigationController?.popViewController(animated: true)
    }
    
    func didReceiveNewItemFileds(_ item: Item) {
        createItemClouser?(item)
        navigationController?.popViewController(animated: true)
    }
    
    func showErrorMessage(_ text: String) {
        showAlert(and: text)
    }
    
    func showActivity() {
        startAnimating()
    }
    
    func hideActivity() {
        endAnimating()
    }
}

