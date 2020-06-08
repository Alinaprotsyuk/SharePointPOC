//
//  BaseViewController.swift
//  BerkleyAppPOC
//
//  Created by Alina Protsiuk on 5/28/19.
//  Copyright © 2019 CoreValue. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    private var container = UIView()
    let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    var loadView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            navigationController?.navigationBar.largeTitleTextAttributes =
                [NSAttributedString.Key.foregroundColor: UIColor.white,
                 NSAttributedString.Key.font: UIFont(name: "Hoefler Text", size: 30) ??
                    UIFont.systemFont(ofSize: 30)]
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func startAnimating() {
        loadView = UIView(frame: self.view.frame)
        guard let view = loadView else { return }
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        navigationController?.view.addSubview(view)
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
    }
    
    func endAnimating() {
        loadView?.removeFromSuperview()
    }
    
    func showAlert(title: String = "Error!", and message: String) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            print("Ok button was pressed")
        }
        controller.addAction(action)
        self.present(controller, animated: true, completion: nil)
    }
    
    func promptTitle(for editingText: String?, completion: @escaping (String) -> Void) {
        let ac = UIAlertController(title: "Enter title", message: nil, preferredStyle: .alert)
        ac.addTextField()
        if let textField = ac.textFields?.first,
           let title = editingText {
                textField.text = title
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
            let title = ac.textFields![0]
            completion(title.text ?? "")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { _ in
            completion("")
        }
        
        ac.addAction(submitAction)
        ac.addAction(cancelAction)
        present(ac, animated: true)
    }
}
