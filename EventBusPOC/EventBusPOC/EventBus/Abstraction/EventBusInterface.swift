//
//  EventBusInterface.swift
//  EventBusPOC
//
//  Created by Pravin Tate on 06/09/24.
//

import Foundation
import Combine
// Component on which we need to listen events - screen
protocol BusComponent: Hashable, Equatable {
}
// Events which we need to get on the component - loading, unload
protocol BusEvent: Hashable, Equatable {
}

protocol EventBusInterface {
    associatedtype Event
    associatedtype Component
    associatedtype Failure: Error

    func publish(event: Event, for component: Component)
    func subscribe(for component: Component,
                   _ event: @escaping (Event) -> Void) -> AnyPublisher<Event, Failure>
    func cancelAllSubscription()
}
