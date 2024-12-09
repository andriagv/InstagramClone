//
//  SearchPageViewController.swift
//  Instagram
//
//  Created by irakli kharshiladze on 22.11.24.
 
import UIKit
 
final class SearchPageViewController: UIViewController {
    private var collectionView: UICollectionView?
    private let searchPageViewModel = SearchPageViewModel()
    private var timer: Timer?
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.backgroundColor = .systemBackground
        
        return searchBar
    }()
    
    private let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let searchOverlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.alpha = 0
        view.isHidden = true
        return view
    }()
    
    private let tagStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let tagName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let tagCount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .caption1)
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .label
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        searchBar.delegate = self
        navigationController?.navigationBar.topItem?.titleView = searchBar
        
        setupTopView()
        setupCollectionView()
        setupSearchOverlayView()
        setupSearchTagAndCount()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.topItem?.titleView = searchBar
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.topItem?.titleView = nil
        searchBar.resignFirstResponder()
    }
    
    private func setupTopView() {
        view.addSubview(topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        guard let collectionView = collectionView else {
            return
        }
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupSearchOverlayView() {
        view.addSubview(searchOverlayView)
        searchOverlayView.translatesAutoresizingMaskIntoConstraints = false
        searchOverlayView.isUserInteractionEnabled = false
        NSLayoutConstraint.activate([
            searchOverlayView.topAnchor.constraint(equalTo: view.topAnchor),
            searchOverlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchOverlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchOverlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupSearchTagAndCount() {
        searchOverlayView.addSubview(tagStackView)
        tagStackView.addArrangedSubview(tagName)
        tagStackView.addArrangedSubview(tagCount)
        
        NSLayoutConstraint.activate([
            tagStackView.leftAnchor.constraint(equalTo: searchOverlayView.leftAnchor, constant: 20),
            tagStackView.rightAnchor.constraint(equalTo: searchOverlayView.rightAnchor, constant: -20),
            tagStackView.topAnchor.constraint(equalTo: searchOverlayView.topAnchor, constant: 150),
        ])
    }
}
extension SearchPageViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {
            print("Search text is empty")
            return
        }
        query(text)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didCancelSearch))
        searchOverlayView.isHidden = false
        searchBar.showsCancelButton = true
        UIView.animate(withDuration: 0.1) {
            self.searchOverlayView.alpha = 1
        }
        searchBar.becomeFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(handleTypingFinished), userInfo: searchText, repeats: false)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        didCancelSearch()
        searchBar.showsCancelButton = false
    }
    
    @objc private func didCancelSearch() {
        searchBar.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
        searchBar.text = ""
        UIView.animate(withDuration: 0.1, animations: {
            self.searchOverlayView.alpha = 0
        }) { _ in
            self.searchOverlayView.isHidden = true
        }
    }
    
    @objc private func handleTypingFinished(_ timer: Timer) {
        guard let searchText = timer.userInfo as? String else {
            return
        }
        query(searchText)
    }
    
    private func query(_ text: String) {
        let results = searchPageViewModel.searchTag(with: text)
        if let firstTag = results.first {
            tagName.text = "#\(firstTag.name)"
            tagCount.text = "\(firstTag.mediaCount) matches found"
        } else {
            tagName.text = "No results found"
            tagCount.text = ""
        }
        
        UIView.animate(withDuration: 0.2) {
            self.searchOverlayView.alpha = 1
            self.searchOverlayView.isHidden = false
        }
    }
}
 
 
 
extension SearchPageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchPageViewModel.getMediaCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        let currentImage = searchPageViewModel.getImage(at: indexPath.row)
        let showOverlay = Bool.random()
        cell.configure(with: currentImage, showOverlay: showOverlay)
        return cell
    }
}
 
extension SearchPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        if indexPath.row % 8 == 0 {
            return CGSize(width: width*2/3 - 2/3, height: width*2/3 - 2/3)
        } else {
            return CGSize(width: (width - 4) / 3, height: (width - 4) / 3)
        }
    }
}

