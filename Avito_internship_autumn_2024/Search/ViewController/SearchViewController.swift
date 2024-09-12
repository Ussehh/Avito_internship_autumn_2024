//
//  SearchViewController.swift
//  Avito_internship_autumn_2024
//
//  Created by Никита Абаев on 11.09.2024.
//

import UIKit

protocol SearchViewControllerProtocol: AnyObject {
    func updateSearch(photos: [Photo])
    func updateHistory(queries: [String])
    func startActivityIndicator()
    func stopActivityIndicator()
    func clearView()
    func showError(_ message: String)
    func navigationToPhotoDetails(photo: Photo)
    func updateRandomPhotos(photos: [Photo])
    
}

class SearchViewController: UIViewController, SearchViewControllerProtocol {
    // MARK: - Properties
    
    var presenter: SearchPresenter
    private var page = 1
    
    
    private lazy var activityIndicator = UIActivityIndicatorView(style: .large)
    private lazy var colletionView = UICollectionView(frame: view.bounds, collectionViewLayout: createTwoColumnFlowLayout())
    
    private lazy var searchController: UISearchController = {
        let searchResultsController = SearchResultsViewController()
        searchResultsController.delegate = self
        let searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchBar.tintColor = R.Colors.black
        return searchController
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = R.Strings.ribbon
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .system)
        let image = R.Image.filter
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initializers
    
    init(presenter: SearchPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter.setView(view: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter.loadRandomPhotos(count: 10)
    }
    
    // MARK: - Setup view methods
    
    private func setupView() {
        view.backgroundColor = R.Colors.backgroungColor
        setupTitleLabel()
        setupCollectionView()
        setupActivityIndicator()
        setupNavigationBar()
        setupSearchController()
    }
    
    private func setupTitleLabel() {
       view.addSubview(titleLabel)
       view.addSubview(filterButton)
       
       NSLayoutConstraint.activate([
           titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
           titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
           titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
           
           filterButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
           filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        
       ])
   }
    
    private func setupCollectionView() {
        view.addSubview(colletionView)
        
        colletionView.register(SearchCollectionCell.self, forCellWithReuseIdentifier: SearchCollectionCell.reuseIdentifier)
        colletionView.register(Loader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: Loader.loaderID)
        colletionView.delegate = self
        colletionView.dataSource = self
        colletionView.alwaysBounceVertical = true
        
        colletionView.backgroundColor = R.Colors.backgroungColor
        colletionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            colletionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            colletionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            colletionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            colletionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
        ])
    }
    

    
    private func setupSearchController() {
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = R.Strings.placeholder
        searchController.searchBar.delegate = self
        searchController.showsSearchResultsController = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.title = R.Strings.title
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func createTwoColumnFlowLayout() -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 16
        let minimumItemSpacing: CGFloat = 10
        let numberOfColumns = 2
        
        let totalHorizontalPadding = padding * 2
        let totalSpacing = minimumItemSpacing * CGFloat(numberOfColumns - 1)
        let availableWidth = width - totalHorizontalPadding - totalSpacing
        let itemWidth = availableWidth / CGFloat(numberOfColumns)
        
        let itemHeight: CGFloat = 270
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.minimumInteritemSpacing = minimumItemSpacing
        flowLayout.minimumLineSpacing = minimumItemSpacing
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        return flowLayout
    }
    
    // MARK: - Search methods

    func updateSearch(photos: [Photo]) {
        presenter.setPhotos(photos)
        DispatchQueue.main.async {
            self.colletionView.reloadData()
        }
    }
    
    private func searchItems(term: String) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(searchDone))
        searchController.isActive = false
        presenter.searchItems(term: term)
        searchController.searchBar.text = term
    }
    
    // MARK: - @objc methods
    
    @objc func searchDone() {
        presenter.clearSearchResults()
    }
    
    @objc private func filterButtonTapped() {
        let filterVC = FilterViewController()
        filterVC.delegate = self
        filterVC.modalPresentationStyle = .custom
        filterVC.modalTransitionStyle = .coverVertical
        present(filterVC, animated: true)
    }
    
    
    // MARK: - methods
    
    func showError(_ message: String) {
        presentAlert(alertTitle: R.Strings.errorTitle, message: message, buttonTitle: R.Strings.OK)
    }
    
    func startActivityIndicator() {
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func clearView() {
        searchController.searchBar.text = nil
        navigationItem.leftBarButtonItem = nil
    }
    
    func updateHistory(queries: [String]) {
        if let searchResultsController = searchController.searchResultsController as? SearchResultsViewController {
            searchResultsController.updateView(historyItems: queries)
        }
    }
    
    // MARK: - SearchViewControllerProtocol methods
    
    func navigationToPhotoDetails(photo: Photo) {
        
        let detailViewController = DetailViewController(presenter: DetailPresenter(view: nil, photo: photo))
        
        let presenter = DetailPresenter(view: detailViewController, photo: photo)
        detailViewController.presenter = presenter
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    
    func updateRandomPhotos(photos: [Photo]) {
        presenter.addRandomPhotos(photos)
        
        DispatchQueue.main.async {
            self.colletionView.reloadData()
        }
    }

}

// MARK: - CollectionView ext

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionCell.reuseIdentifier, for: indexPath) as! SearchCollectionCell
        cell.configureCell(photo: presenter.photos[indexPath.item])
        return cell
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            if searchController.isActive, let term = searchController.searchBar.text, !term.isEmpty {

                guard presenter.hasMorePhotos else { return }
                page += 1
                presenter.searchItems(term: term, page: page)
            } else {

                presenter.loadMoreRandomPhotos(count: 10)
            }
        }
    }
    

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Loader.loaderID, for: indexPath) as! Loader
            return footer
        }
        return UICollectionReusableView()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return presenter.hasMorePhotos ? CGSize(width: collectionView.bounds.width, height: 50) : .zero
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.presenter.goToDetails(selectedItemIdx: indexPath.item)
    }
}

// MARK: - Search ext

extension SearchViewController: SearchResultsViewControllerProtocol {
    func didSelectHistoryItem(historyItem: String) {
        searchItems(term: historyItem)
    }
    
}


extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.isActive {
            presenter.getHistoryItems(term: searchController.searchBar.text ?? "")
        }
    }
}


extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        titleLabel.text = R.Strings.results
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let term = searchBar.text {
            searchItems(term: term)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchDone()
        titleLabel.text = R.Strings.ribbon
    }
}

extension SearchViewController: FilterViewControllerDelegate {
    func didSelectSortOption(_ option: SortOption) {
        presenter.sortPhotos(by: option)
    }
}
