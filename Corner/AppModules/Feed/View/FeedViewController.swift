//
//  FeedViewController.swift
//  Corner
//
//  Created by manish singh on 02/10/24.
//

import UIKit

extension FeedViewController {
    enum Section: Int {
        case feed
    }
}

class FeedViewController: BaseViewController, StoryboardLoadable {
    
    var viewModel: FeedViewModel!
    
    private var dataSource: UITableViewDiffableDataSource<Section, FeedTableViewCellModel>!

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
                                    #selector(FeedViewController.handleRefresh(_:)),
                                 for: .valueChanged)
        refreshControl.tintColor = UIColor.lightGray
        return refreshControl
    }()
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        tableView.register(cellType: FeedTableViewCell.self)
        
        tableView.addSubview(self.refreshControl)

        setupTableViewDatasource()
        registerFeedViewModelCallback()
        
        viewModel.fetchFeedItems(state: .loading(.initalData))
    }
}

//MARK: - RefreshControl
private extension FeedViewController {
    @objc func handleRefresh(_ sender: Any) {
        Utilities.generateHaptic()
        viewModel.fetchFeedItems(state: .loading(.PTR))
    }
}

//MARK: - TableView setup
private extension FeedViewController {
    func setupTableViewDatasource() {
        dataSource = UITableViewDiffableDataSource<Section, FeedTableViewCellModel>(tableView: tableView) {
            tableView,
            indexPath,
            feedItem in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: FeedTableViewCell.identifier,
                for: indexPath
            ) as? FeedTableViewCell else {return UITableViewCell()}
            cell.setup(feedItem,
                       at: indexPath)
            cell.delegate = self
            return cell
        }
        
        tableView.dataSource = dataSource
    }
}

extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height * 0.8
    }
}

//MARK: - Datasource Snapshot
private extension FeedViewController {
    func applySnapshot(with feedItems: [FeedTableViewCellModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, FeedTableViewCellModel>()
        snapshot.appendSections([Section.feed])
        snapshot.appendItems(feedItems, toSection: Section.feed)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func getFeedItem(for indexPath: IndexPath) -> FeedTableViewCellModel {
        let feedItem = getAllFeedItem[indexPath.row]
        return feedItem
    }
    
    var getAllFeedItem: [FeedTableViewCellModel] {
        dataSource.snapshot().itemIdentifiers(inSection: .feed)
    }
    
    func applyNewSnapshot(with item: FeedTableViewCellModel, at indexPath: IndexPath) {
        var allFeedItems = getAllFeedItem
        allFeedItems[indexPath.row] = item
        applySnapshot(with: allFeedItems)
    }
}

private extension FeedViewController {
    func registerFeedViewModelCallback() {
        viewModel
            .feedViewModelPassThroughSubject
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print(completion)
            } receiveValue: { [weak self] state in
                guard let self else {return}
                
                switch state {
                case .loading(let state):
                    switch state {
                    case .initalData:
                        showLoader(true)
                    case .pagination, .PTR:
                        break
                    }
                case .success(let data):
                    self.showLoader(false)
                    self.refreshControl.endRefreshing()
                    DispatchQueue.main.async {
                        self.applySnapshot(with: data)
                    }
                }
            }.store(in: &cancellables)
    }
}

//MARK: - FeedTableViewCellDelegate
extension FeedViewController: FeedTableViewCellDelegate {
    func feedTableViewCell(
        _ cell: FeedTableViewCell,
        didChangedCurrentImage index: Int,
        at indexPath: IndexPath
    ) {
        var feedItem = getFeedItem(for: indexPath)
        feedItem.currentImageIndex = index
        applyNewSnapshot(with: feedItem, at: indexPath)
    }
    
    func feedTableViewCell(
        _ cell: FeedTableViewCell,
        didScrollReactionView position: CGPoint,
        at indexPath: IndexPath
    ) {
        var feedItem = getFeedItem(for: indexPath)
        feedItem.reactionScrollPosition = position
        applyNewSnapshot(with: feedItem, at: indexPath)
    }
    
    func feedTableViewCell(
        _ cell: FeedTableViewCell,
        didSelect type: ReactionType,
        reaction: String,
        at indexPath: IndexPath
    ) {
        var feedItem = getFeedItem(for: indexPath)
        
        switch type {
        case .bookmark:
            viewModel.bookmarkSelection(feedItem.id)
        case .comment:
            viewModel.commentSelection(feedItem.id)
        case .reaction:
            if feedItem.currentUserReactions?.contains(reaction) == false {
                feedItem.currentUserReactions?.append(reaction)
            }
            
            if let value = feedItem.reaction?[reaction] {
                feedItem.reaction?[reaction] = value + 1
            } else {
                feedItem.reaction?[reaction] = 1
            }
                        
            applyNewSnapshot(with: feedItem, at: indexPath)
            
            //Need improvement here
            cell.updateReactions(with: feedItem)
            
            viewModel.addReaction(reaction)
        }
    }
}
