//
//  EventBus.swift
//  EventBusPOC
//
//  Created by Pravin Tate on 06/09/24.
//

import Foundation
import Combine
final class EventBus<ComponentType: BusComponent, EventType: BusEvent>: EventBusInterface {
    typealias Event = EventType
    typealias Component = ComponentType
    typealias Failure = Never

    private var store: [ComponentType: PassthroughSubject<EventType, Failure>] = [:]
    private var disposeBag = Set<AnyCancellable>()

    func cancelAllSubscription() {
        print("Event bus canceled for \(store.keys.map({ $0 }))")
        disposeBag.removeAll()
        store.removeAll()
    }

    func publish(event: EventType, for component: ComponentType) {
        if let publisher = store[component] {
            publisher.send(event)
        } else {
            debugPrint("publisher not created for \(component)")
        }
    }

    @discardableResult
    func subscribe(for component: ComponentType, 
                   _ event: @escaping (EventType) -> Void) -> AnyPublisher<EventType, Never> {
        var publisher = PassthroughSubject<EventType, Failure>()

        if let currentPublisher = store[component] {
            publisher = currentPublisher
        } else {
            let newPublisher = PassthroughSubject<EventType, Failure>()
            store[component] = newPublisher
            publisher = newPublisher
        }
        publisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: event)
            .store(in: &disposeBag)
        return publisher.eraseToAnyPublisher()
    }
}

