//
//  TableViewModel.swift
//  Example
//
//  Created by kojirof on 2018/12/16.
//  Copyright © 2018 Gumob. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Differentiator

class TableViewModel {
    var sections: BehaviorRelay<[SectionModel]> = BehaviorRelay<[SectionModel]>(value: [SectionModel(title: "Section 1", items: [RowModel]())])

    var canPrepend: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: true)
    var canAppend: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: true)

    var shouldFailLoad: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)

    var refreshDuration: TimeInterval = 5.0
    var initialCellCount: Int = 24

    var reloadCount: Int = 0
    var prependCount: Int = 0
    var appendCount: Int = 0

    var prependAlpha: CGFloat = 1.0
    var appendAlpha: CGFloat = 1.0

    func reload(shouldFailLoad: Bool,
                refreshDuration: TimeInterval,
                initialCellCount: Int,
                canPrepend: Bool,
                canAppend: Bool) -> Single<()> {

        self.shouldFailLoad.accept(shouldFailLoad)
        self.canPrepend.accept(canPrepend)
        self.canAppend.accept(canAppend)

        self.refreshDuration = refreshDuration
        self.initialCellCount = initialCellCount

        self.reloadCount = 0
        self.prependCount = 0
        self.appendCount = 0

        self.prependAlpha = 1.0
        self.appendAlpha = 1.0

        return Single.create { [weak self] (single) in
            guard let `self`: TableViewModel = self else {
                single(.error(ViewModelError.objectDisposed))
                return Disposables.create {}
            }
            var sectionModels: [SectionModel] = [SectionModel(title: "Section 1", items: [RowModel]())]
            Array(1...self.initialCellCount).forEach { [weak self] (_) in
                guard let `self`: TableViewModel = self else { return }
                let rowModel: RowModel = RowModel(title: "Reload \(self.reloadCount)",
                                                  color: UIColor(red: 33 / 255,
                                                                 green: 33 / 255,
                                                                 blue: 33 / 255,
                                                                 alpha: 1.0))
                sectionModels[0].items.append(rowModel)
                self.reloadCount += 1
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.sections.accept(sectionModels)
                single(.success(()))
            }
            return Disposables.create {}
        }
    }

    func prepend() -> Single<()> {
        return Single.create { [weak self] (single) in
            guard let `self`: TableViewModel = self else {
                single(.error(ViewModelError.objectDisposed))
                return Disposables.create {}
            }
            if self.shouldFailLoad.value {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + self.refreshDuration) {
                    single(.error(ViewModelError.loadFailed))
                }
                return Disposables.create {}
            }
            if self.canPrepend.value {
                var sectionModels: [SectionModel] = self.sections.value
                let start: Int = sectionModels[0].items.count + 1
                let end: Int = start + Int(arc4random_uniform(3)) + 1
                Array(start...end).forEach { [weak self] (_) in
                    guard let `self`: TableViewModel = self else { return }
                    let rowModel: RowModel = RowModel(title: "Prepend \(self.prependCount)",
                                                      color: UIColor(red: 245 / 255,
                                                                     green: 0 / 255,
                                                                     blue: 87 / 255,
                                                                     alpha: self.prependAlpha))
                    sectionModels[0].items.insert(rowModel, at: 0)
                    self.prependCount += 1
                }
                self.prependAlpha -= 0.4
                if self.prependAlpha <= 0.2 {
                    self.canPrepend.accept(false)
                }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + self.refreshDuration) { [weak self] in
                    guard let `self`: TableViewModel = self else {
                        single(.error(ViewModelError.objectDisposed))
                        return
                    }
                    self.sections.accept(sectionModels)
                    single(.success(()))
                }
            } else {
                single(.success(()))
            }
            return Disposables.create {}
        }
    }

    func append() -> Single<()> {
        return Single.create { [weak self] (single) in
            guard let `self`: TableViewModel = self else {
                single(.error(ViewModelError.objectDisposed))
                return Disposables.create {}
            }
            if self.shouldFailLoad.value {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + self.refreshDuration) {
                    single(.error(ViewModelError.loadFailed))
                }
                return Disposables.create {}
            }
            if self.canAppend.value {
                var sectionModels: [SectionModel] = self.sections.value
                let start: Int = sectionModels[0].items.count + 1
                let end: Int = start + Int(arc4random_uniform(3)) + 1
                Array(start...end).forEach { [weak self] (_) in
                    guard let `self`: TableViewModel = self else { return }
                    let rowModel: RowModel = RowModel(title: "Append \(self.appendCount)",
                                                      color: UIColor(red: 41 / 255,
                                                                     green: 121 / 255,
                                                                     blue: 255 / 255,
                                                                     alpha: self.appendAlpha))
                    sectionModels[0].items.append(rowModel)
                    self.appendCount += 1
                }
                self.appendAlpha -= 0.4
                if self.appendAlpha <= 0.2 {
                    self.canAppend.accept(false)
                }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + self.refreshDuration) { [weak self] in
                    guard let `self`: TableViewModel = self else {
                        single(.error(ViewModelError.objectDisposed))
                        return
                    }
                    self.sections.accept(sectionModels)
                    single(.success(()))
                }
            } else {
                single(.success(()))
            }
            return Disposables.create {}
        }
    }

}

struct SectionModel {
    var title: String
    var items: [Item]

    init(title: String, items: [Item]) {
        self.title = title
        self.items = items
    }
}

extension SectionModel: AnimatableSectionModelType {
    typealias Item = RowModel
    typealias Identity = String
    var identity: String { return self.title }

    init(original: SectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}

extension SectionModel: Equatable {
    public static func == (lhs: SectionModel, rhs: SectionModel) -> Bool {
        return lhs.title == rhs.title && lhs.items == rhs.items
    }
}

struct RowModel {
    var title: String
    var color: UIColor

    init(title: String, color: UIColor) {
        self.title = title
        self.color = color
    }
}

extension RowModel: IdentifiableType {
    typealias Identity = String
    var identity: String { return self.title }
}

extension RowModel: Equatable {
    public static func == (lhs: RowModel, rhs: RowModel) -> Bool {
        return lhs.title == rhs.title
    }
}

enum ViewModelError: Error {
    case objectDisposed
    case loadFailed
}

extension ViewModelError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .objectDisposed:
            return NSLocalizedString("The object is already disposed.", comment: "ViewModelError")
        case .loadFailed:
            return NSLocalizedString("Failed to load data.", comment: "ViewModelError")
        }
    }
}