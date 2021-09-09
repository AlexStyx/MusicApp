//
//  MiniPlayerView.swift
//  MusicApp
//
//  Created by Александр Бисеров on 9/1/21.
//

import UIKit

class MiniPlayerView: UIView {
    
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var isFavouriteLabel: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        playPauseButton.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(11)
        }
    }
    
}


