//
//  DefaultRefreshView.swift
//  RxPullToRefresh
//
//  Created by kojirof on 2018/12/15.
//  Copyright © 2018 Gumob. All rights reserved.
//

import UIKit

internal class DefaultRefreshView: RxPullToRefreshView {

    lazy var activityIndicator: UIActivityIndicatorView! = {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        self.addSubview(activityIndicator)
        return activityIndicator
    }()

    lazy var failureLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: UIFont.smallSystemFontSize)
        label.text = "Load Failed"
        label.sizeToFit()
        self.addSubview(label)
        return label
    }()

    lazy var noContentLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: UIFont.smallSystemFontSize)
        label.text = "No Content"
        label.sizeToFit()
        self.addSubview(label)
        return label
    }()

    private var state: RxPullToRefreshState = .initial {
        didSet {
            switch self.state {
            case .initial:
                self.activityIndicator.stopAnimating()
                self.isHidden = true
                self.failureLabel.isHidden = true
                self.noContentLabel.isHidden = true
                self.activityIndicator.isHidden = true
                self.failureLabel.alpha = 0.0
                self.noContentLabel.alpha = 0.0
                self.activityIndicator.alpha = 0.0
            case .pulling where oldValue == .initial:
                if self.canLoadMore { self.activityIndicator.startAnimating() }
                self.isHidden = false
                self.failureLabel.isHidden = true
                self.noContentLabel.isHidden = self.canLoadMore
                self.activityIndicator.isHidden = !self.canLoadMore
                self.failureLabel.alpha = 0.0
                self.noContentLabel.alpha = self.canLoadMore ? 0.0 : 1.0
                self.activityIndicator.alpha = self.canLoadMore ? 1.0 : 0.0
            case .loading where oldValue == .overThreshold:
                self.activityIndicator.startAnimating()
            case .finished:
                self.activityIndicator.stopAnimating()
            case .failed:
                self.activityIndicator.stopAnimating()
                self.failureLabel.isHidden = false
                UIView.animate(withDuration: 0.2, animations: { [weak self] in
                    self?.failureLabel.alpha = 1.0
                    self?.noContentLabel.alpha = 0.0
                    self?.activityIndicator.alpha = 0.0
                }, completion: { [weak self] (_) in
                    self?.noContentLabel.isHidden = true
                    self?.activityIndicator.isHidden = true
                })
            case .backing:
                self.activityIndicator.stopAnimating()
            default:
                break
            }
        }
    }

    var progressRate: CGFloat = 0.0 {
        didSet {
            self.alpha = max(0, self.progressRate - 0.5) * 2
            if self.state == .pulling && self.canLoadMore {
                var transform: CGAffineTransform = CGAffineTransform.identity
                transform = transform.scaledBy(x: self.progressRate, y: self.progressRate)
                transform = transform.rotated(by: CGFloat(Double.pi) * self.progressRate * 2)
                self.activityIndicator.transform = transform
            }
        }
    }

    override func action(state: RxPullToRefreshState, progress: CGFloat, scroll: CGFloat) {
        self.state = state
        self.progressRate = progress
    }

    override func layoutSubviews() {
        self.failureLabel.center = self.convert(center, from: superview)
        self.noContentLabel.center = self.convert(center, from: superview)
        self.activityIndicator?.center = self.convert(center, from: superview)
        super.layoutSubviews()
    }

    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard let superview: UIView = newSuperview else { return }
        self.frame = CGRect(x: frame.origin.x,
                            y: frame.origin.y,
                            width: superview.frame.width,
                            height: frame.height)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init() {
        super.init(frame: CGRect.zero.replaced(height: 64))
        self.clipsToBounds = true
        self.isHidden = true
        self.alpha = 0
        self.backgroundColor = .clear
        self.backgroundColor = .lightGray /* Debug color */
    }
}
