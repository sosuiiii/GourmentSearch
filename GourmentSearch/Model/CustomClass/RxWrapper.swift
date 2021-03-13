//
//  RxWrapper.swift
//  GourmentSearch
//
//  Created by TanakaSoushi on 2021/03/13.
//

import Foundation
import RxSwift
import RxCocoa

@propertyWrapper
struct BehaviorRelayWrapper<T> {
    private let relay: BehaviorRelay<T>
    private let observable: Observable<T>
    init(value: T) {
        relay = BehaviorRelay(value: value)
        observable = relay.asObservable()
    }
    var wrappedValue: Observable<T> {
        observable
    }
    var projectedValue: BehaviorRelay<T> {
        relay
    }
}

@propertyWrapper
struct PublishRelayWrapper<T> {
    private let relay: PublishRelay<T>
    private let observable: Observable<T>
    init() {
        relay = PublishRelay<T>()
        observable = relay.asObservable()
    }
    var wrappedValue: Observable<T> {
        observable
    }
    var projectedValue: PublishRelay<T> {
        relay
    }
}

@propertyWrapper
struct AnyObserverWrapper<T> {
    private let relay = PublishRelay<T>()
    private let observer: AnyObserver<T>
    private let observable: Observable<T>
    init() {
        observer = .create(relay)
        observable = relay.asObservable()
    }
    var wrappedValue: AnyObserver<T> {
        observer
    }
    var projectedValue: Observable<T> {
        observable
    }
}

extension AnyObserver {
    static func create<E>(_ relay: PublishRelay<E>) -> AnyObserver<E> {
        return .init { event in
            guard case let .next(value) = event else { return }
            relay.accept(value)
        }
    }

    static func create<E>(_ relay: BehaviorRelay<E>) -> AnyObserver<E> {
        return .init { event in
            guard case let .next(value) = event else { return }
            relay.accept(value)
        }
    }
}
