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
        
    private var tracks: [TrackCellViewModelType]? {
        didSet {
            if tracks != nil {
                tableView.reloadData()
            }
        }
    }
    var interactor: SavedMusicBusinessLogic?
    var router: (NSObjectProtocol & SavedMusicRoutingLogic)?
    
    var navigationDelegate: SlideOutNavigationDelegate?
    
    
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
    
    // MARK: Routing
    
    
    
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
            tracks = trackViewModel.cells
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
        tracks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackCell.reuseId, for: indexPath) as? TrackCell,
              let track = tracks?[indexPath.row]
        else { fatalError() }
        cell.setup(viewModel: track)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
    }
    
    
}
