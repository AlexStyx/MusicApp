//
//  TrackCell.swift
//  MusicApp
//
//  Created by Александр Бисеров on 8/23/21.
//

import UIKit
import SnapKit
import SDWebImage

class TrackCell: UITableViewCell {
    static let reuseId = "trackCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let trackImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "nosign")
        return imageView
    }()
    
    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.text = "Track"
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.text = "Artist"
        return label
    }()
    
    func setup(viewModel: TrackCellViewModelType) {
        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.collectionName == nil ? viewModel.artistName :  viewModel.artistName + " • " + viewModel.collectionName!
        guard let imageUrl = URL(string: viewModel.imageURL ?? "") else { return }
        trackImageView.sd_setImage(with: imageUrl, completed: nil)
    }
    
    private func setupUI () {
        addSubviews()
        layout()
    }
    
    private func addSubviews() {
        addSubview(trackImageView)
        addSubview(trackNameLabel)
        addSubview(artistNameLabel)
    }
    
    //TODO:- Fix layout to be out of mistakes
    
    private func layout() {
        trackImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(60)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(trackImageView.snp.height)
        }
        
        trackNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalTo(trackImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        artistNameLabel.snp.makeConstraints { make in
            make.top.equalTo(trackNameLabel.snp.bottom).offset(5)
            make.leading.equalTo(trackImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
}
