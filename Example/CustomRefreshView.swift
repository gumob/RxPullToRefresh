//
//  CustomRefreshView.swift
//  Example
//
//  Created by kojirof on 2018/12/16.
//  Copyright © 2018 Gumob. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxPullToRefresh

class CustomPullToRefresh: RxPullToRefresh {
    public convenience init(position: RxPullToRefreshPosition = .top,
                            shouldStartLoadingWhileDragging: Bool = true) {
        let frame: CGRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 96)
        let refreshView: CustomRefreshView = CustomRefreshView(frame: frame)
        self.init(refreshView: refreshView,
                  position: position,
                  shouldStartLoadingWhileDragging: shouldStartLoadingWhileDragging,
                  loadAnimationType: .linear(duration: 0.3),
                  backAnimationType: .linear(duration: 1.0))
    }
}

class CustomRefreshView: RxPullToRefreshView {
    fileprivate(set) lazy var activityIndicator: CustomRefreshIndicator! = {
        let activityIndicator: CustomRefreshIndicator! = CustomRefreshIndicator()
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
                self.activityIndicator.stop()
                self.isHidden = true
                self.failureLabel.isHidden = true
                self.noContentLabel.isHidden = true
                self.activityIndicator.isHidden = true
                self.failureLabel.alpha = 0.0
                self.noContentLabel.alpha = 0.0
                self.activityIndicator.alpha = 0.0
            case .pulling where oldValue == .initial:
                if self.canLoadMore { self.activityIndicator.start() }
                self.isHidden = false
                self.failureLabel.isHidden = true
                self.noContentLabel.isHidden = self.canLoadMore
                self.activityIndicator.isHidden = !self.canLoadMore
                self.failureLabel.alpha = 0.0
                self.noContentLabel.alpha = self.canLoadMore ? 0.0 : 1.0
                self.activityIndicator.alpha = self.canLoadMore ? 1.0 : 0.0
            case .loading:
                break
            case .failed:
                self.activityIndicator.stop()
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
                break
            default:
                break
            }
        }
    }

    private var progressRate: CGFloat = 0.0 {
        didSet {
            self.alpha = max(0, progressRate - 0.5) * 2
        }
    }

    override func layoutSubviews() {
        self.failureLabel.center = self.convert(center, from: superview)
        self.noContentLabel.center = self.convert(center, from: superview)
        self.activityIndicator.frame = {
            var frame: CGRect = self.activityIndicator.frame
            frame.size.width = self.frame.width
            frame.size.height = self.frame.height
            return frame
        }()
        super.layoutSubviews()
    }

    override func action(state: RxPullToRefreshState, progress: CGFloat, scroll: CGFloat) {
        self.state = state
        self.progressRate = progress
        self.activityIndicator.state = state
        self.activityIndicator.progressRate = progress
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        self.isHidden = true
        self.alpha = 0
        self.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
    }
}

class CustomRefreshDot {
    var coord: CGPoint = CGPoint.zero
    var radius: CGFloat = 2
    var rot: CGFloat = (CGFloat.pi / 3) * 0
    var range: CGFloat = 6
    var diff: CGFloat

    init(radius: CGFloat = 2, rot: CGFloat = 0) {
        self.radius = radius
        self.rot = rot
        self.diff = radius * sin(rot)
    }
}

class CustomRefreshIndicator: UIView {
    fileprivate var state: RxPullToRefreshState = .initial
    fileprivate var progressRate: CGFloat = 0

    private var dots: [CustomRefreshDot] = [
        CustomRefreshDot(rot: (CGFloat.pi / 3) * 0),
        CustomRefreshDot(rot: (CGFloat.pi / 3) * 1),
        CustomRefreshDot(rot: (CGFloat.pi / 3) * 2)
    ]

    private var displayLink: CADisplayLink?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }

    convenience init() {
        self.init(frame: .zero)
        self.backgroundColor = .clear
    }

    deinit {
        self.stop()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if let context: CGContext = UIGraphicsGetCurrentContext() { context.clear(bounds) }
        UIColor.black.setFill()
        for dot: CustomRefreshDot in self.dots {
            let circlePath: UIBezierPath = UIBezierPath(arcCenter: dot.coord,
                                                        radius: dot.radius,
                                                        startAngle: 0,
                                                        endAngle: CGFloat.pi * 2,
                                                        clockwise: true)
            circlePath.fill()
        }
    }

    fileprivate func start() {
        if self.displayLink != nil { return }
        for dot: CustomRefreshDot in dots {
            dot.coord.x = frame.midX
            dot.coord.y = frame.midY
        }
        let mode: RunLoop.Mode = RunLoop.Mode.common
        self.displayLink = CADisplayLink(target: self, selector: #selector(CustomRefreshIndicator.update))
        if #available(iOS 10.0, *) {
            self.displayLink?.preferredFramesPerSecond = 60
        } else {
            let framePerSecond: TimeInterval = 60.0
            self.displayLink?.frameInterval = Int(60.0 / framePerSecond)
        }
        self.displayLink?.add(to: RunLoop.current, forMode: mode)
        self.setNeedsDisplay()
    }

    @objc private func update(displayLink: CADisplayLink) {
        switch self.state {
        case .initial:
            for dot: CustomRefreshDot in self.dots {
                let toX: CGFloat = frame.midX
                let toY: CGFloat = frame.midY
                dot.coord.x += (toX - dot.coord.x) / 4
                dot.coord.y += (toY - dot.coord.y) / 4
            }
        case .pulling, .overThreshold:
            var i: CGFloat = 0
            let scaleRate: CGFloat = max(0, self.progressRate - 0.5) * 2
            let targetHeight: CGFloat = min(frame.height - 16 * 2, 48) * scaleRate
            let startY: CGFloat = (self.frame.height - targetHeight) / 2
            let stepY: CGFloat = targetHeight / (CGFloat(self.dots.count) - 1)
            for dot: CustomRefreshDot in self.dots {
                let toX: CGFloat = self.frame.midX
                let toY: CGFloat = startY + stepY * i
                dot.coord.x += (toX - dot.coord.x) / 4
                dot.coord.y += (toY - dot.coord.y) / 4
                i += 1
            }
        case .loading:
            var i: CGFloat = 0
            let targetWidth: CGFloat = 48
            let stepX: CGFloat = targetWidth / (CGFloat(self.dots.count) - 1)
            let startX: CGFloat = self.frame.midX - targetWidth / 2
            for dot: CustomRefreshDot in self.dots {
                let toX: CGFloat = startX + stepX * i
                dot.rot += 0.2
                dot.diff = dot.range * sin(dot.rot)
                let toY: CGFloat = self.frame.height / 2 + dot.diff
                dot.coord.x += (toX - dot.coord.x) / 4
                dot.coord.y += (toY - dot.coord.y) / 4
                i += 1
            }
        case .finished:
            break
        case .failed:
            break
        case .backing:
            break
        }
        self.setNeedsDisplay()
    }

    fileprivate func stop() {
        if self.displayLink != nil {
            self.displayLink?.invalidate()
            self.displayLink = nil
        }
        self.setNeedsDisplay()
    }
}
