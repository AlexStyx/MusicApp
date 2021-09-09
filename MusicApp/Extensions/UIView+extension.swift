//
//  UIView+extension.swift
//  MusicApp
//
//  Created by Александр Бисеров on 8/26/21.
//

import UIKit

extension UIView {
    class func loadFromNib<View: UIView>() ->  View {
        guard let view = Bundle.main.loadNibNamed(String(describing: View.self), owner: nil, options: nil)?.first as? View else { fatalError("Cannot find nib named \(String(describing: View.self))") }
        return view
    }
}
