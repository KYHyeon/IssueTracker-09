//
//  MilestoneViewController.swift
//  IssueTracker
//
//  Created by 현기엽 on 2020/11/02.
//

import UIKit

extension Notification.Name {
    static let didMilestoneAppend = Notification.Name(rawValue: "MilestoneViewController.didMilestoneAppend")
}
class MilestoneViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var service: MilestoneService?
    private var refreshControl: UIRefreshControl?
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.stopAnimating()
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = createLayout()
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        service?.reloadData()
        configRightItem()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didMilestoneAppend),
                                               name: .didMilestoneAppend,
                                               object: nil)
        configRefreshControl()
    }
    
    func configRightItem() {
        let barButtonItem = UIBarButtonItem(systemItem: .add)
        barButtonItem.target = self
        barButtonItem.action = #selector(didAddButtonTapped)
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    func configRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didRefreshChanged), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        self.refreshControl = refreshControl
    }
    
    @objc func didAddButtonTapped(_ sender: UIBarButtonItem) {
        guard let viewController =
                UIStoryboard(name: "MilestoneAppend", bundle: nil).instantiateInitialViewController()
                as? MilestoneAppendViewController else {
            return
        }
        present(viewController, animated: true, completion: nil)
    }
    
    @objc func didMilestoneAppend(_ notification: Notification) {
        service?.reloadData()
        scrollToLast()
    }
    
    // https://stackoverflow.com/a/47036507
    func scrollToLast() {
        let numberOfSections = collectionView.numberOfSections
        let numberOfItems = collectionView.numberOfItems(inSection: numberOfSections - 1)
        let lastItemIndexPath = IndexPath(item: numberOfItems - 1,
                                          section: numberOfSections - 1)
        
        guard numberOfSections > 0, numberOfItems > 0 else {
            return
        }
        
        collectionView.scrollToItem(at: lastItemIndexPath, at: .bottom, animated: true)
    }
}

extension MilestoneViewController {
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection in
            let spacing = CGFloat(10)

            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalWidth(0.3))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
            group.interItemSpacing = .fixed(spacing)

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = spacing
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

            return section
        }
        return layout
    }
    
    @objc func didRefreshChanged(_ sender: UIRefreshControl) {
        service?.reloadData()
    }
}

extension MilestoneViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "MilestoneAppend", bundle: nil)
        guard let milestoneAppendViewController =
                storyBoard.instantiateInitialViewController() as? MilestoneAppendViewController else {
            return
        }
        
        navigationController?.present(milestoneAppendViewController, animated: true, completion: nil)
        
        if let milestone = service?[at: indexPath] {
            milestoneAppendViewController.config(milestone: milestone)
        }
    }
}

extension MilestoneViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        service?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                            for: indexPath) as? MilestoneCollectionViewCell,
              let milestone = service?[at: indexPath] else {
            return UICollectionViewCell()
        }
        cell.config(milestone: milestone)
        return cell
    }
}

extension MilestoneViewController: MileStoneServiceDelegate {
    func didDataLoaded() {
        activityIndicator.stopAnimating()
        refreshControl?.endRefreshing()
        collectionView.reloadData()
    }
}
