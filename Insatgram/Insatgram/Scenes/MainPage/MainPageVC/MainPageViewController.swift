//
//  MainPageViewController.swift
//  Insatgram
//
//  Created by irakli kharshiladze on 22.11.24.
//

import UIKit

final class MainPageViewController: UIViewController {
        
    private let instagramLogoImage = UIImageView()
    
    private let mainPageViewModel = MainPageViewModel()
    
    private lazy var newsFeedTableView: UITableView = {
        let tableview = UITableView()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.backgroundColor = .white
        return tableview
    }()
    
    private let headerView: UIView = {
        let hv = UIView()
        hv.backgroundColor = .white
        return hv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        mainPageViewModel.postsCanged = { [weak self] in
            self?.newsFeedTableView.reloadData()
        }
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
        
        setupHeaderView()
        setupMainTableView()
    }
    
    private func setupHeaderView() {
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(instagramLogoImage)
        instagramLogoImage.translatesAutoresizingMaskIntoConstraints = false
        instagramLogoImage.image = UIImage(named: "InstagramLogo")
        
        NSLayoutConstraint.activate([
            
            headerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            headerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 44),
            
            instagramLogoImage.topAnchor.constraint(equalTo: headerView.topAnchor),
            instagramLogoImage.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            instagramLogoImage.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
        ])
    }
    
    private func setupMainTableView() {
        view.addSubview(newsFeedTableView)
        newsFeedTableView.register(NewsFeedTableViewCell.self, forCellReuseIdentifier: "NewsFeedTableViewCell")

        NSLayoutConstraint.activate([
            newsFeedTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            newsFeedTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            newsFeedTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            newsFeedTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension MainPageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mainPageViewModel.postCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFeedTableViewCell", for: indexPath) as! NewsFeedTableViewCell
        let currentPost = mainPageViewModel.getPost(at: indexPath.row)
        cell.post = currentPost
        cell.configureCell(post: currentPost)
        
        cell.parentViewController = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 625
    }
    
}

