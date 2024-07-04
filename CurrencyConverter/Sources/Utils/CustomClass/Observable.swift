//
//  Observable.swift
//  CurrencyConverter
//
//  Created by Vikas Salian on 14/05/23.
//

import Foundation
/// Observables emit events. An `Observer` subscribes to an `Observable` and reacts to an item the observable emits.
class Observable<T> {
    private var observer: ((T) -> Void)?

    var value: T {
        didSet {
            notify()
        }
    }

    private func notify() {
        observer?(value)
    }

    /// `Init` the observable with a default value and an optional observer
    required init(element: T, observer: ((T) -> Void)? = nil) {
        self.observer = observer
        value = element
    }

    /// Use this method to subscribe for event(s) from the observable.
    /// As of now, only single observer is permitted. Any subsequent call to this method would invalidate previous observer.
    /// - Parameters:
    ///   - observer: Observation block to be called on an event
    func observe(observer: @escaping (T) -> Void) {
        self.observer = observer
        notify()
    }
}
