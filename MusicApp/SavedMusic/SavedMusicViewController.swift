//
//  SavedMusicViewController.swift
//  MusicApp
//
//  Created by Александр Бисеров on 8/23/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SavedMusicDisplayLogic: AnyObject {
    func displayData(viewModel: SavedMusic.Model.ViewModel.ViewModelData)
}

class SavedMusicViewController: UIViewController, SavedMusicDisplayLogic {
    
    private var viewModel: TracksViewModel? {
        didSet {
            if viewModel != nil {
                tableView.reloadData()
            }
        }
    }
    var interactor: SavedMusicBusinessLogic?
    var router: (NSObjectProtocol & SavedMusicRoutingLogic)?
    
    var playerViewNavigationDelegate: SlideOutNavigationDelegate?
    
    
    // MARK: Setup
    
    private func setup() {
        let viewController        = self
        let interactor            = SavedMusicInteractor()
        let presenter             = SavedMusicPresenter()
        let router                = SavedMusicRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.makeRequest(request: .getTracks)
    }
    
    func displayData(viewModel: SavedMusic.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayTracks(let trackViewModel):
            self.viewModel = trackViewModel
        }
    }
    
    //MARK: - UI
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TrackCell.self, forCellReuseIdentifier: TrackCell.reuseId)
        return tableView
    }()
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func layout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupUI() {
        addSubviews()
        layout()
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension SavedMusicViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.cells.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackCell.reuseId, for: indexPath) as? TrackCell,
              let track = viewModel?.cells[indexPath.row]
        else { fatalError() }
        cell.setup(viewModel: track)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let trackViewModel = viewModel?.cells[indexPath.row]
        else { return }
        playerViewNavigationDelegate?.slideUp(viewModel: trackViewModel)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    
}

// MARK: -  Player delegate
extension SavedMusicViewController: PlayerDelegate {
    func goToNextTrack() -> TrackCellViewModelType? {
        getTrack(isNext: true)
    }
    
    func goToPreviousTrack() -> TrackCellViewModelType? {
        getTrack(isNext: false)
    }
    
    private func getTrack(isNext: Bool) -> TrackCellViewModelType? {
        guard let currentIndexPath = tableView.indexPathForSelectedRow else { return nil }
        tableView.deselectRow(at: currentIndexPath, animated: true)
        var nextIndexPath = currentIndexPath
        if isNext  {
            nextIndexPath.row += 1
            if nextIndexPath.row == viewModel?.cells.count {
                nextIndexPath.row = 0
            }
        } else {
            nextIndexPath.row -= 1
            if nextIndexPath.row == -1 {
                nextIndexPath.row = (viewModel?.cells.count ?? 1) - 1
            }
        }
        tableView.selectRow(at: nextIndexPath, animated: true, scrollPosition: .none)
        return viewModel?.cells[nextIndexPath.row]
    }

}
