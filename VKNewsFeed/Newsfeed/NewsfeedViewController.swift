//
//  NewsfeedViewController.swift
//  VKNewsFeed
//
//  Created by Иван Бабушкин on 19.11.2019.
//  Copyright (c) 2019 Ivan Babushkin. All rights reserved.
//

import UIKit
import VKSdkFramework

protocol NewsfeedDisplayLogic: class {
    func displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData)
}

class NewsfeedViewController: UIViewController, NewsfeedDisplayLogic {
    
    var interactor: NewsfeedBusinessLogic?
    var router: (NSObjectProtocol & NewsfeedRoutingLogic)?
    private var feedViewModel = FeedViewModel.init(cells: [], footerTitle: nil)
    @IBOutlet weak var tableView: UITableView!
    
    private var titleView = TitleView()
    private lazy var footerView = FooterView()
    private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: - Setup
    
    private func setup() {
        let viewController        = self
        let interactor            = NewsfeedInteractor()
        let presenter             = NewsfeedPresenter()
        let router                = NewsfeedRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setUpTableView()
        setUpTopBar()
        
        interactor?.makeRequest(request: .getNewsFeed)
        interactor?.makeRequest(request: .getUser)
        titleView.delegate = self
    }

    private func setUpTableView() {
        let topInset: CGFloat = 8
        tableView.contentInset.top = topInset
        
        //        tableView.register(UINib(nibName: "NewsfeedCell", bundle: nil), forCellReuseIdentifier: NewsfeedCell.reuseId)
        tableView.register(NewsfeedCodeCell.self, forCellReuseIdentifier: NewsfeedCodeCell.reuseId)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        
        tableView.addSubview(refreshControl)
        tableView.tableFooterView = footerView
    }
    
    private func setUpTopBar() {
        let topBar = UIView(frame: UIApplication.shared.statusBarFrame)
        topBar.backgroundColor = .white
        topBar.layer.shadowColor = UIColor.black.cgColor
        topBar.layer.shadowOpacity = 0.3
        topBar.layer.shadowOffset = CGSize.zero
        topBar.layer.shadowRadius = 8
        self.view.addSubview(topBar)
        
        self.navigationController?.hidesBarsOnSwipe = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.titleView = titleView
    }
    
    @objc private func refresh() {
        interactor?.makeRequest(request: .getNewsFeed)
    }
    
    func displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayNewsFeed(let feedViewModel):
            self.feedViewModel = feedViewModel
            DispatchQueue.main.async {
                self.footerView.setTitle(feedViewModel.footerTitle)
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        case .displayUser(let userViewModel):
            titleView.set(userViewModel: userViewModel)
        case .presentFooterLoader:
            footerView.showLoader()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > scrollView.contentSize.height / 1.1 {
            interactor?.makeRequest(request: .getNextBatch)
        }
    }
    
    func setCell(cell: UITableViewCell) -> FeedViewModel.Cell{
        guard let indexPath = tableView.indexPath(for: cell) else { fatalError() }
        let cellViewModel = feedViewModel.cells[indexPath.row]
        return cellViewModel
    }
}

//MARK: - NewsFeedCellSettings
extension NewsfeedViewController: UITableViewDelegate, UITableViewDataSource, NewsFeedCodeCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsfeedCodeCell.reuseId, for: indexPath) as! NewsfeedCodeCell
        let cellViewModel = feedViewModel.cells[indexPath.row]
        cell.set(viewModel: cellViewModel)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = feedViewModel.cells[indexPath.row]
        return cellViewModel.sizes.totalHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = feedViewModel.cells[indexPath.row]
        return cellViewModel.sizes.totalHeight
    }
    
    func revealPost(for cell: NewsfeedCodeCell) {
        let cellViewModel = setCell(cell: cell)
        interactor?.makeRequest(request: .revealPostIds(postId: cellViewModel.postId))
    }
    
    func likeAdded(for cell: NewsfeedCodeCell) {
        let cellViewModel = setCell(cell: cell)
        interactor?.makeRequest(request: .addLike(sourceId: cellViewModel.sourceId, postId: cellViewModel.postId))
    }
    
    func likeRemoved(for cell: NewsfeedCodeCell) {
        let cellViewModel = setCell(cell: cell)
        interactor?.makeRequest(request: .removeLike(sourceId: cellViewModel.sourceId, postId: cellViewModel.postId))
    }
    
    func share(for cell: NewsfeedCodeCell) {
        let cellViewModel = setCell(cell: cell)
        let sourceId = cellViewModel.sourceId
        let postId = cellViewModel.postId
        let fullLink = "https://vk.com/wall\(sourceId)_\(postId)"
        
        let activityController = UIActivityViewController(activityItems: [fullLink], applicationActivities: [VKActivity()])
        present(activityController, animated: true)
        print("share button activated")
    }
}


// MARK: - NewsFeedCodeCellDelegate

// MARK: - TitleViewViewModelDelegate
extension NewsfeedViewController: TitleViewViewModelDelegate {
    func segueToSettings() {
        print(#function)
        router?.navigateToSettings()
    }
}

// MARK: - NewsFeedSegue
//extension NewsfeedViewController {
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let scene = segue.identifier {
//            let selector = NSSelectorFromString("routeTo\(scene)WithSegue")
//            
//            if let router = router, router.responds(to: selector) {
//                router.perform(selector, with: segue)
//            }
//        }
//    }
//}
