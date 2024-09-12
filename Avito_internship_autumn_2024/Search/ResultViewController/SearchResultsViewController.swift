//
//  SearchResultsViewController.swift
//  Avito_internship_autumn_2024
//
//  Created by Никита Абаев on 11.09.2024.
//

import UIKit

protocol SearchResultsViewControllerProtocol: AnyObject {
    func didSelectHistoryItem(historyItem: String)
}

class SearchResultsViewController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: SearchResultsViewControllerProtocol?
    
    private lazy var dataSource = createDataSource()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: R.Constants.historyItemCellIdentifier)
        tableView.backgroundColor = R.Colors.backgroungColor
        view.addSubview(tableView)
        
        tableView.delegate = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        return tableView
    }()
    
    // MARK: - ViewController lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Methods
    
    private func createDataSource() -> UITableViewDiffableDataSource<Int, String> {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: R.Constants.historyItemCellIdentifier, for: indexPath)
            
            cell.backgroundColor = R.Colors.backgroungColor
            
            cell.textLabel?.text = itemIdentifier
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            cell.textLabel?.textColor = R.Colors.black
            
            
            cell.imageView?.image = R.Image.clock
            cell.imageView?.tintColor = R.Colors.black
            
            let arrowImageView = UIImageView(image: R.Image.chevronRight)
            arrowImageView.tintColor = R.Colors.black
            cell.accessoryView = arrowImageView
            
            return cell
        })
        return dataSource
    }


    
    func updateView(historyItems: [String]) {
        createSnapshot(historyItems: historyItems)
    }
    
    func createSnapshot(historyItems: [String]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems(historyItems)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    
    // MARK: - Keyboard Show and Hide methods
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
            tableView.contentInset = insets
            tableView.scrollIndicatorInsets = insets
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        tableView.contentInset = .zero
        tableView.scrollIndicatorInsets = .zero
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

    // MARK: - Ext

extension SearchResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedCell = tableView.cellForRow(at: indexPath),
           let historyItem = selectedCell.textLabel?.text {
            delegate?.didSelectHistoryItem(historyItem: historyItem)
        }
    }
    
}
