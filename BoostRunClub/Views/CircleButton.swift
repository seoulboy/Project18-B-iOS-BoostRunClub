//
//  CircleButton.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/02.
//

import UIKit

class CircleButton: UIButton {
    enum Style {
        case start, stop, pause, resume
    }

    init(with buttonStyle: Style) {
        super.init(frame: .zero)
        commonInit(with: buttonStyle)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit(with buttonStyle: Style = .start) {
        switch buttonStyle {
        case .start:
            backgroundColor = #colorLiteral(red: 0.9763557315, green: 0.9324046969, blue: 0, alpha: 1)
            setTitle("시작", for: .normal)
        case .stop:
            setSFSymbol(iconName: "stop.fill", size: 25, tintColor: .systemBackground, backgroundColor: .label)
        case .pause:
            setSFSymbol(iconName: "pause.fill", size: 25, tintColor: .systemBackground, backgroundColor: .label)
        case .resume:
            setSFSymbol(iconName: "play.fill", size: 25, tintColor: .label, backgroundColor: #colorLiteral(red: 0.9763557315, green: 0.9324046969, blue: 0, alpha: 1))
        }

        setTitleColor(.label, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        imageView?.contentMode = .scaleAspectFill
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
}
