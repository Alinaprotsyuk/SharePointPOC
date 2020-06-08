//
//  ViewController.swift
//  BerkleyAppPOC
//
//  Created by Alina Protsiuk on 5/27/19.
//  Copyright © 2019 CoreValue. All rights reserved.
//

import UIKit

class SharePointViewController: BaseViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let refreshControl = UIRefreshControl()
    fileprivate var presenter: SharePointPresenter!
    private let search = UISearchController(searchResultsController: nil)
    private let networkService = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //createAccountView(name: "A", surname: "B")
        setupSearchBar()
        
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)

        //collectionView.dragInteractionEnabled = true
//        ADKeychainTokenCache.defaultKeychain().removeAll(forClientId: "1ab3e10a-b879-42eb-9f16-ce2c48f9f931", error: nil)
//        ADKeychainTokenCache.defaultKeychain().removeAll(forClientId: "b1e2aa87-9270-4a2b-80f3-50a1a09b47a6", error: nil)
        
        presenter = SharePointPresenter(interactor: SharePointInteractor(networkManager: networkService))
        
        presenter.attachView(self)
        presenter.getInitialData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
    }
    
    @objc private func refreshData(_ sender: Any) {
        presenter.isFiltering = false
        presenter.getInitialData()
        refreshControl.endRefreshing()
    }
   
    private func setupSearchBar() {
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search"
        search.hidesNavigationBarDuringPresentation = false
        search.searchBar.sizeToFit()
        search.searchBar.delegate = self
        search.definesPresentationContext = false
        navigationItem.hidesSearchBarWhenScrolling = false

    }
    
    private func showSearchBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = search
        
        let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font :
            UIFont(name: "Roboto", size: 17.0) ?? UIFont.systemFont(ofSize: 17)]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes , for: .normal)
        if !presenter.searchText.isEmpty {
            search.searchBar.text = presenter.searchText
        }
    }
    
    private func hideSearchBar() {
        navigationItem.searchController = nil
        
        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: .layoutSubviews, animations: {
            self.collectionView.contentOffset = CGPoint(x: 0, y: 0)

        }, completion: nil)
        
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let viewController = segue.destination as? EditViewController else { return }
        
        if let row = sender as? Int {
            let value = presenter.isFiltering ? presenter.filteredItems[row] : presenter.items[row]
            viewController.setup(networkManager: networkService, item: value, and: presenter.columns)
            viewController.editItemClouser = { [weak self] fields in
                guard let wrapSelf = self else { return }
                if wrapSelf.presenter.isFiltering {
                    wrapSelf.presenter.filteredItems[row].fields = fields
                    if let index = wrapSelf.presenter.items.firstIndex(where: { (item) -> Bool in
                        return item.id == value.id
                    }) {
                        wrapSelf.presenter.items[index].fields = fields
                    }
                } else {
                    wrapSelf.presenter.items[row].fields = fields
                }
                wrapSelf.collectionView.reloadSections(IndexSet(integer: row + 1))
            }
        } else {
            viewController.setup(networkManager: networkService, columns: presenter.columns)
            viewController.createItemClouser = { [weak self] item in
                guard let wrapSelf = self else { return }
                
                wrapSelf.invalidateLayout()
                if wrapSelf.presenter.isFiltering {
                   wrapSelf.presenter.isFiltering = false
                }
                wrapSelf.presenter.items.append(item)
                
                wrapSelf.collectionView.reloadData()
            }
        }
    }
    
    internal func createNavView() {
        let view = UIView(frame: CGRect(x: -80, y: 0, width: 350, height: 44))
        let imageView = UIImageView(frame: view.frame)
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        navigationItem.titleView = view
        navigationItem.titleView?.center = CGPoint(x: 10, y: 30)
    }
    
    fileprivate func createRightBarButton() {
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didPressAddNewButton(_:)))
        addBarButton.tintColor = .white
        let searchBarButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didPressSearchButton(_:)))
        searchBarButton.tintColor = .white
        navigationItem.rightBarButtonItems = [addBarButton, searchBarButton]
    }
    
    fileprivate func showDialog(for editingText: String?, on row: Int?) {
        promptTitle(for: editingText) { [weak self] (title) in
            guard !title.isEmpty else {
                return
            }
            
            if let row = row {
                self?.presenter.editItem(for: row, on: title)
            } else {
                self?.presenter.save(text: title)
            }
        }
    }
    
    fileprivate func invalidateLayout() {
        if let layout = collectionView?.collectionViewLayout as? CustomCollectionViewLayout {
            layout.cleanCache()
        }
    }
    
    //MARK: - Actions
    @IBAction func didPressSearchButton(_ sender: UIBarButtonItem) {
        if navigationItem.searchController == nil {
            showSearchBar()
        } else {
            hideSearchBar()
        }
    }
    
    @IBAction func didPressAddNewButton(_ sender: UIBarButtonItem) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            showDialog(for: nil, on: nil)
        } else {
            performSegue(withIdentifier: "editItemSegue", sender: nil)
        }
    }
}

//MARK: - UIViewControllerPreviewingDelegate
extension SharePointViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        print(collectionView.point(inside: location, with: .none))
        return UIViewController()
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        print("previewingContext")
    }
}

//MARK: - UICollectionViewDataSource
extension SharePointViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let count = presenter.isFiltering ? presenter.filteredItems.count : presenter.items.count
        return count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.columns.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeaderCollectionViewCell.identifier, for: indexPath) as? HeaderCollectionViewCell else { return UICollectionViewCell()}
            let title = presenter.columns[indexPath.row].displayName
            cell.titleLabel.text = String(describing: title ?? "No title").uppercased()
            if let selectedIndexPath = presenter.selectedIndexPath,
               selectedIndexPath == indexPath {
                cell.sortButton.isSelected = true
            } else {
                cell.sortButton.isSelected = false
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.identifier, for: indexPath) as? ItemCollectionViewCell else { return UICollectionViewCell()}
            cell.setup(section: indexPath.section)
            cell.delegate = self
            let key = presenter.columns[indexPath.item].name ?? ""
            let item = presenter.isFiltering ? presenter.filteredItems[indexPath.section - 1] : presenter.items[indexPath.section - 1]
            if let section = presenter.editedSelectedSection,
                section == indexPath.section && indexPath.row == 0 {
                cell.editButton.isHidden = false
            } else {
                cell.editButton.isHidden = true
            }
            
            if let text = item.fields[key] {
                cell.textLabel.text = String(describing: text)
            }
            
            return cell
        }
    }
}

//MARK: - ItemCollectionViewCellDelegate
extension SharePointViewController: ItemCollectionViewCellDelegate {
    func didPressEdit(for section: Int) {
        performSegue(withIdentifier: "editItemSegue", sender: section - 1)
    }
}

//MARK: - UICollectionViewDelegate
extension SharePointViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            guard let cell = collectionView.cellForItem(at: indexPath) as? HeaderCollectionViewCell else { return }
            collectionView.deselectItem(at: indexPath, animated: false)
            cell.sortButton.isSelected = !cell.sortButton.isSelected
            if cell.sortButton.isSelected {
                presenter.selectedIndexPath = indexPath
                presenter.sortByUp(name: presenter.columns[indexPath.row].name ?? "")
            } else {
                presenter.selectedIndexPath = nil
                presenter.sortByDown(name:presenter.columns[indexPath.row].name ?? "")
            }
//        } else if indexPath.row == 0 && indexPath.section != 0 {
        } else {
            collectionView.deselectItem(at: indexPath, animated: false)
            
            performSegue(withIdentifier: "editItemSegue", sender: indexPath.section - 1)

//            if let section = presenter.editedSelectedSection,
//                section != indexPath.section,
//                let previousSelectedCell = collectionView.cellForItem(at: IndexPath(item: 0, section: section)) as? ItemCollectionViewCell {
//                previousSelectedCell.editButton.isHidden = true
//            }
//
//            guard let cell = collectionView.cellForItem(at: indexPath) as? ItemCollectionViewCell else { return }
//
//            cell.editButton.isHidden = false
//            presenter.editedSelectedSection = indexPath.section
        }
    }
    
}

//MARK: - UIPopoverPresentationControllerDelegate
extension SharePointViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

//MARK: - UISearchResultsUpdating, UISearchBarDelegate
extension SharePointViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
                    presenter.searchText = ""
                    return }
        presenter.searchText = text
        if text.isEmpty {
            presenter.isFiltering = false
            collectionView.reloadData()
        } else {
            presenter.isFiltering = true
            presenter.filter()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.isFiltering = false
        hideSearchBar()
        invalidateLayout()
        collectionView.reloadData()
    }
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        guard let text = searchBar.text else {
//            presenter.searchText = ""
//            collectionView.reloadData()
//            return }
//        presenter.searchText = text
//
//        if text.isEmpty {
//            presenter.isFiltering = false
//            collectionView.reloadData()
//        } else {
//            presenter.isFiltering = true
//            presenter.filter()
//        }
//    }
}

//MARK: - SharePointView
extension SharePointViewController: SharePointView {
    func success() {
        createRightBarButton()
        if let layout = collectionView.collectionViewLayout as? CustomCollectionViewLayout {
            layout.cleanCache()
            layout.delegate = self
        }
        
        createNavView()
        self.collectionView.reloadData()
    }
    
    func showError(_ message: String) {
        showAlert(and: message)
    }
    
    func showActivity() {
        startAnimating()
    }
    
    func hideActivity() {
        endAnimating()
    }
    
    func setup(title: String) {
        print(title)
    }
    
    func createAccountView() {
        print("#func(createAccountView)")
    }
    
    func reload() {
        invalidateLayout()
        collectionView.reloadData()
    }
}

//MARK: - CustomCollectionViewLayoutDelegate
extension SharePointViewController: CustomCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, widthAtIndexPath indexPath: Int) -> CGFloat {
        return presenter.columns[indexPath].width
    }
}


