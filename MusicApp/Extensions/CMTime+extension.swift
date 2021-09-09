//
//  CMTime+extension.swift
//  MusicApp
//
//  Created by Александр Бисеров on 8/25/21.
//

import Foundation
import CoreMedia

extension CMTime {
    func convertedToString() -> String {
        guard !CMTimeGetSeconds(self).isNaN else { return "" }
        var seconds = Int(CMTimeGetSeconds(self))
        let munites = seconds / 60
        seconds = seconds % 60
        return String(format: "%02d:%02d", munites, seconds)
    }
}
