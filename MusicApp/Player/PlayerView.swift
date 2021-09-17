//
//  PlayerView.swift
//  MusicApp
//
//  Created by Александр Бисеров on 8/24/21.
//

import UIKit
import SnapKit
import AVKit

protocol PlayerDelegate {
    func goToNextTrack() -> TrackCellViewModelType?
    func goToPreviousTrack() -> TrackCellViewModelType?
}

protocol SlideOutNavigationDelegate {
    func slideDown()
    func slideUp(viewModel: TrackCellViewModelType?)
}
class PlayerView: UIView {
    
    @IBOutlet weak private var miniPlayerView: UIView!
    @IBOutlet weak private var mainPlayerView: UIStackView!
    @IBOutlet weak private var trackImageView: UIImageView!
    @IBOutlet weak private var trackNameLabel: UILabel!
    @IBOutlet weak private var artinstNameLabel: UILabel!
    @IBOutlet weak private var currentTimeLabel: UILabel!
    @IBOutlet weak private var durationLabel: UILabel!
    
    @IBOutlet weak private var currentTimeSlider: UISlider!
    @IBOutlet weak private var soundSlider: UISlider!
    @IBOutlet weak private var playPauseButton: UIButton!
    @IBOutlet weak private var saveButton: UIButton!
    
    
    @IBOutlet weak var timestepProgressView: UIProgressView!
    
    @IBOutlet weak var isFavouriteButton: UIButton!
    @IBOutlet weak var miniTrackLabel: UILabel!
    @IBOutlet weak var miniPlayPauseButton: UIButton!
    
    private let player = AVPlayer()
    private var trackViewModel: TrackCellViewModelType?
    
    var delegate: PlayerDelegate?
    var navigationDelegate: SlideOutNavigationDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addGestures()
        saveButton.snp.makeConstraints { make in
            make.width.equalTo(saveButton.snp.height)
        }
    }
    
    func showMiniPlayer(_ show: Bool) {
        miniPlayerView.isHidden = !show
        mainPlayerView.isHidden = show
    }
    
    @IBAction func closePlayerTapped(_ sender: UIButton) {
        navigationDelegate?.slideDown()    
    }
    
    @IBAction func nextTrackTapped(_ sender: UIButton) {
        guard let trackViewModel = delegate?.goToNextTrack() else { return }
        setup(viewModel: trackViewModel)
    }
    
    @IBAction func previousTrackTapped(_ sender: UIButton) {
        guard let trackViewModel = delegate?.goToPreviousTrack() else { return }
        setup(viewModel: trackViewModel)
    }
    
    @IBAction func timeSliderMoved(_ sender: UISlider) {
        guard let cmTimeDuration = player.currentItem?.duration else { return }
        let duration = CMTimeGetSeconds(cmTimeDuration)
        let currentValue = sender.value
        let seekTimeInSeconds = Float64(currentValue) * duration
        let time = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 600)
        player.seek(to: time)
    }
    
    @IBAction func soundSliderMoved(_ sender: UISlider) {
        player.volume = sender.value
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        let archivator = DataArchivator()
        if let viewModel = trackViewModel {
            archivator.add(track: viewModel)
        }
    }
    
    @IBAction func playPauseTapped(_ sender: UIButton) {
        if player.timeControlStatus == .paused {
            player.play()
            animateTrackImageView(increase: true)
            sender.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            miniPlayPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            player.pause()
            animateTrackImageView(increase: false)
            sender.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            miniPlayPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
    
    func setup(viewModel: TrackCellViewModelType) {
        trackViewModel = viewModel
        trackNameLabel.text = viewModel.trackName
        artinstNameLabel.text = viewModel.artistName
        miniTrackLabel.text = viewModel.trackName
        let urlFor600x600Image = viewModel.imageURL?.replacingOccurrences(of: "60x60", with: "600x600")
        guard let imageUrl = URL(string: urlFor600x600Image ?? "") else { return }
        trackImageView.sd_setImage(with: imageUrl, completed: nil)
        trackImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        playTrack(urlStirng: viewModel.trackPreviewURL)
        listenPlayerStart()
        observeTrackTime()
    }
    
    private func playTrack(urlStirng: String?) {
        guard let trackUrl = URL(string: urlStirng ?? "") else { return }
        let playerItem = AVPlayerItem(url: trackUrl)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    private func listenPlayerStart() {
        let time = CMTimeMake(value: 1, timescale: 600)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.animateTrackImageView(increase: true)
            self?.playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            self?.miniPlayPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    
    private func observeTrackTime() {
        let interval = CMTimeMake(value: 1, timescale: 600)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.currentTimeLabel.text = time.convertedToString()
            guard let duration = self?.player.currentItem?.duration else { return }
            let playBack = duration - time
            self?.durationLabel.text = "-\(playBack.convertedToString())"
            self?.updateTimeSliderAndProgressView()
        }
    }
    
    private func updateTimeSliderAndProgressView() {
        guard let cmTimeDuration = player.currentItem?.duration else { return }
        let duration = CMTimeGetSeconds(cmTimeDuration)
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let percentage = Float(currentTime / duration)
        currentTimeSlider.setValue(percentage, animated: true)
        timestepProgressView.setProgress(percentage, animated: true)
    }
    
    private func animateTrackImageView(increase: Bool) {
        let scale: CGFloat = 0.8
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 3, initialSpringVelocity: 5, options: .curveEaseInOut, animations: { [weak self] in
            self?.trackImageView.transform = increase ? .identity : CGAffineTransform(scaleX: scale, y: scale)
        }, completion: nil)
    }
    
    private func addGestures() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        miniPlayerView.addGestureRecognizer(gestureRecognizer)
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        mainPlayerView.addGestureRecognizer(swipeGestureRecognizer)
    }
    
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .down:
            navigationDelegate?.slideDown()
        case .up:
            if mainPlayerView.isHidden {
                navigationDelegate?.slideUp(viewModel: nil)
            }
        default: break
        }
    }
    
    @IBAction func swipedDown(_ sender: Any) {
        navigationDelegate?.slideDown() 
    }
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        navigationDelegate?.slideUp(viewModel: nil)
    }
    
}
