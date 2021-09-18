//
//  MainTabBarController.swift
//  MusicApp
//
//  Created by Александр Бисеров on 8/22/21.
//

import UIKit
import SnapKit

class MainTabBarController: UITabBarController {
    private var topConstraint: Constraint?
    private var playerView: PlayerView = PlayerView.loadFromNib()
    private let savedMusicViewController = SavedMusicViewController()
    private let searchMusicViewContoller = SearchMusicViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutPlayerView()
        searchMusicViewContoller.playerViewNavigationDelegate = self
        savedMusicViewController.navigationDelegate = self
        let searchViewController = generateNavigationController(rootViewController: searchMusicViewContoller, title: "Search", imageName: "magnifyingglass")
        let saveViewController = generateNavigationController(rootViewController: savedMusicViewController, title: "Saved", imageName: "square.and.arrow.down")
        viewControllers = [
            searchViewController,
            saveViewController
        ]
        playerView.delegate = searchMusicViewContoller
        playerView.navigationDelegate = self
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.title {
        case "Search": playerView.delegate = searchMusicViewContoller
        case "Saved": playerView.delegate = savedMusicViewController
        default: break
        }
    }
    
    private func generateNavigationController(rootViewController: UIViewController, title: String, imageName: String) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.image = UIImage(systemName: imageName)
        navigationController.tabBarItem.title = title
        navigationController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        return navigationController
    }
    
    private func layoutPlayerView() {
        view.insertSubview(playerView, belowSubview: tabBar)
        playerView.snp.makeConstraints { make in
            topConstraint = make.top.equalTo(tabBar.snp.top).constraint
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(view.snp.height)
        }
    }
}



extension MainTabBarController: SlideOutNavigationDelegate {
    func slideUp(viewModel: TrackCellViewModelType?) {
        if let viewModel = viewModel {
            playerView.setup(viewModel: viewModel)
        }
        let playerViewHeight =  UIScreen.main.bounds.height - tabBar.bounds.height
        topConstraint?.update(offset: -playerViewHeight)
        animatePlayerView()
        tabBar.isHidden = true
        playerView.showMiniPlayer(false)
    }
    
    
    func slideDown() {
        topConstraint?.update(offset: -40)
        animatePlayerView()
        tabBar.isHidden = false
        playerView.showMiniPlayer(true)
    }
    
    private func animatePlayerView() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        }, completion: nil)
    }
}
