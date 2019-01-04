//
//  Debug.swift
//  RxPullToRefresh
//
//  Created by kojirof on 2018/12/22.
//  Copyright © 2018 Gumob. All rights reserved.
//

import Foundation

/**
 CustomStringConvertible
 */

internal protocol Debuggable {
    var debug: String { get }
}

extension CGFloat: Debuggable {
    internal var debug: String {
        return "\(self.decimal(1))"
    }
}

extension CGPoint: Debuggable {
    internal var debug: String {
        return "(x: \(self.x.decimal(1)), y: \(self.y.decimal(1)))"
    }
}

extension CGSize: Debuggable {
    internal var debug: String {
        return "(w: \(self.width.decimal(1)), h: \(self.height.decimal(1)))"
    }
}

extension CGRect: Debuggable {
    internal var debug: String {
        return "(x: \(self.origin.x.decimal(1)), y: \(self.origin.y.decimal(1)), w: \(self.width.decimal(1)), h: \(self.height.decimal(1)))"
    }
}

extension UIEdgeInsets: Debuggable {
    internal var debug: String {
        return "(t: \(self.top.decimal(1)), b: \(self.bottom.decimal(1)), l: \(self.left.decimal(1)), r: \(self.right.decimal(1)))"
    }
}

/**
 Debugger
 */

internal extension String {
    func lpad() -> String {
        return self.padding(toLength: 36, withPad: " ", startingAt: 0)
    }
}

private func extractFileName(_ file: String) -> String {
    let str: NSString = (file as NSString)
    return str.lastPathComponent.replacingOccurrences(of: ".\(str.pathExtension)", with: "")
}

internal class Debug {
    enum Level {
        case none, simple, info, verbose
    }

    weak var refresher: RxPullToRefresh?

    init?(_ refresher: RxPullToRefresh?) {
        let isFramework: Bool = {
            guard let schemeName: String = Bundle.main.infoDictionary?["CFBundleName"] as? String else { return false }
            return schemeName.contains("RxPullToRefresh")
        }()
        if !isFramework { return nil }
        self.refresher = refresher
    }

    static func format(name: String, prop: Any?) -> String {
        guard let prop: Any = prop else {
            return "\(name):".lpad() + "nil"
        }
        return "\(name):".lpad() + String(describing: prop)
    }

    func log(_ enabled: Bool, _ level: Level, _ div: String?, _ messages: [String]? = nil,
             _ function: String = #function, _ file: String = #file, _ line: Int = #line) {
        guard let obj: RxPullToRefresh = refresher, let sv: UIScrollView = obj.scrollView, enabled else { return }

        let br: String = "\n"
        let position: String = obj.position == .top ? "🔺" : "🔽"
        let file: String = extractFileName(file)
        let line: String = String(format: "%03d", arguments: [line])
        let fileInfo: String = " \(file):\(line):\(function)"
        let div: String = {
            guard let s: String = div else { return "" }
            return String(repeating: s, count: 30)
        }()
        let defaultMsg: String = {
            var msg: String = ""
            if level != .none { msg += "\(position) file: \(fileInfo)\(br)" }
            msg += "\(position) state: \(obj.state), isVisible: \(obj.isVisible), isDragging: \(obj.isDragging), canLoadMore: \(obj.canLoadMore), progressRate: \(obj.progressRate.debug), scrollRate: \(obj.scrollRate.debug)"
            return msg
        }()

        var out: String = ""
        if !div.isEmpty { out += div + br }
        switch level {
        case .none:
            break
        case .simple:
            out += defaultMsg + br
        case .info:
            out += defaultMsg + br
            out += position + " " + Debug.format(name: "scrollView.contentInset", prop: sv.contentInset.debug) + br
            out += position + " " + Debug.format(name: "scrollView.effectiveContentInset", prop: sv.effectiveContentInset.debug) + br
            out += position + " " + Debug.format(name: "scrollView.contentOffset", prop: sv.contentOffset.debug) + br
            out += position + " " + Debug.format(name: "normalizedContentOffset", prop: sv.normalizedContentOffset.debug) + br
            out += position + " " + Debug.format(name: "relativeContentOffset", prop: sv.relativeContentOffset(for: obj.position)) + br
        case .verbose:
            out += defaultMsg + br
            out += br
            out += position + " " + Debug.format(name: "UIScreen.main.bounds", prop: (UIScreen.main.bounds).debug) + br
            out += position + " " + Debug.format(name: "scrollView.frame", prop: (sv.frame).debug) + br
            out += position + " " + Debug.format(name: "scrollView.contentSize", prop: sv.contentSize.debug) + br
            out += position + " " + Debug.format(name: "scrollView.scrollableHeight", prop: sv.scrollableHeight) + br
            out += position + " " + Debug.format(name: "refreshView.frame.size", prop: (obj.refreshView.frame.size).debug) + br
            out += br
            out += position + " " + Debug.format(name: "scrollViewInitialInsets", prop: obj.scrollViewInitialInsets.debug) + br
            out += position + " " + Debug.format(name: "scrollViewInitialEffectiveInsets", prop: obj.scrollViewInitialEffectiveInsets.debug) + br
            out += position + " " + Debug.format(name: "scrollViewLoadingInsets", prop: obj.scrollViewLoadingInsets.debug) + br
            out += br
            out += position + " " + Debug.format(name: "scrollView.contentInset", prop: sv.contentInset.debug) + br
            out += position + " " + Debug.format(name: "scrollView.effectiveContentInset", prop: sv.effectiveContentInset.debug) + br
            out += br
            out += position + " " + Debug.format(name: "scrollView.contentOffset", prop: sv.contentOffset.debug) + br
            out += position + " " + Debug.format(name: "normalizedContentOffset", prop: sv.normalizedContentOffset.debug) + br
            out += position + " " + Debug.format(name: "relativeContentOffset", prop: sv.relativeContentOffset(for: obj.position)) + br
        }
        if let messages: [String] = messages {
            messages.forEach {
                if $0.isEmpty {
                    out += br
                } else {
                    out += position + " " + $0 + br
                }
            }
        }
        if !div.isEmpty { out += div + br }
        if !out.isEmpty { print(out) }
    }

}
