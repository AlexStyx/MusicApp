//
//  MainTabBarController.swift
//  MusicApp
//
//  Created by Александр Бисеров on 8/22/21.
//

import UIKit
import SnapKit

class MainTabBarController: UITabBarController {
    private var topContraint: Constraint?
    private var bottomConstraint: Constraint?
    private var playerView: PlayerView = PlayerView.loadFromNib()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutPlayerView()
        let searchMusicViewContoller = SearchMusicViewController()
        searchMusicViewContoller.playerViewNavigationDelegate = self
        let savedMusicViewController = SavedMusicViewController()
        let searchViewController = generateNavigationController(rootViewController: searchMusicViewContoller, title: "Search", imageName: "magnifyingglass")
        let saveViewController = generateNavigationController(rootViewController: savedMusicViewController, title: "Saved", imageName: "square.and.arrow.down")
        viewControllers = [
            searchViewController,
            saveViewController
        ]
        playerView.delegate = searchMusicViewContoller
        playerView.navigationDelegate = self
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
            topContraint = make.top.equalTo(tabBar.snp.top).offset(tabBar.bounds.height).constraint
            bottomConstraint = make.bottom.equalToSuperview().constraint
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
}


extension MainTabBarController: SlideOutNavigationDelegate {
    func slideUp(viewModel: TrackCellViewModelType?) {
        if let viewModel = viewModel {
            playerView.setup(viewModel: viewModel)
        }
        let viewHeight =  UIScreen.main.bounds.height - tabBar.bounds.height
        topContraint?.update(offset: -viewHeight)
        bottomConstraint?.update(offset: 0)
        animatePlayerView()
        tabBar.isHidden = true
        playerView.showMiniPlayer(false)
    }
    
    
    func slideDown() {
        topContraint?.update(offset: -40)
        bottomConstraint?.update(offset: view.bounds.height)
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
