//
//  AudioPlayer.swift
//  TiktokDownload
//
//  Created by vulcanlabs-hai on 29/10/2022.
//

import Foundation
import AVFoundation

class AudioPlayer {
    static let share = AudioPlayer()
    var player: AVPlayer?
    private (set) var curentURL: URL?
    private var audioQueueStatusObserver: Any?
    private var audioQueueStallObserver: Any?
    private var timeStatus: AVPlayer.TimeControlStatus = .paused
    
    var playbackUpdateHandler: (()->())?
    var isPlaying: Bool {
        return player?.rate != 0
    }
    
    func playAudio(path: String) {
        guard let url = URL(string: path) else { return }
        guard curentURL != url else { return }
        
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        
        
        
        let player = AVPlayer(playerItem: playerItem)
        
        
        player.play()
        self.player = player
        curentURL = url
        
        self.audioQueueStatusObserver = self.player?.currentItem?.observe(\.status, options:  [.new, .old], changeHandler: {
            (playerItem, change) in
            if playerItem.status == .readyToPlay {
                print("current item status is ready")
                self.player?.play()
            }
        })
        
        // listening for event about the status of the playback
        self.audioQueueStallObserver = self.player?.observe(\.timeControlStatus, options: [.new, .old], changeHandler: {
            [weak self](playerItem, change) in
            switch (playerItem.timeControlStatus) {
            case AVPlayer.TimeControlStatus.paused:
                print("Media Paused")
            case AVPlayer.TimeControlStatus.playing:
                print("Media Playing")
            case AVPlayer.TimeControlStatus.waitingToPlayAtSpecifiedRate:
                print("Media Waiting to play at specific rate!")
            }
            if self?.timeStatus != playerItem.timeControlStatus {
                self?.timeStatus = playerItem.timeControlStatus
                self?.playbackUpdateHandler?()
            }
           
        })
        
    }
    
    func pause() {
        player?.pause()
    }
    
    func stop() {
    }
    
}
