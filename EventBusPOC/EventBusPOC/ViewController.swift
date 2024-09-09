//
//  ViewController.swift
//  EventBusPOC
//
//  Created by Pravin Tate on 05/09/24.
//

import UIKit
import Combine

class ViewController: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = .purple
        super.viewDidLoad()
        navigationController?.pushViewController(SecondVC(), animated: true)
    }
}

class SecondVC: UIViewController {
    var vm: EventBusFeatureTester?
    var vm3: EventBusFeatureTester3?
    override func viewDidLoad() {
        super.viewDidLoad()
        // busHandling()
        checkEventBusFunctionality()
        view.backgroundColor = .yellow
    }

    func busHandling() {
        EventBusContainer.shared.register(bus:
                                            EventBus<SectionType, EventBusEventImp>(),
                                          identifier: "superBill")
        guard let busObject = EventBusContainer.shared.getBus(for: "superBill") as?
        EventBus<SectionType, EventBusEventImp> else {
            print("but not found")
            return
        }
        vm = EventBusFeatureTester(eventBus: busObject)
        guard let vm = vm else {
            return
        }
        vm.registerEventBusEvents()
        print("🔮 first fire")
        vm.pubishEventBus()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            print("🔮 second fire")
            self?.vm?.pubishEventBus(.success)
        }

        vm3 = EventBusFeatureTester3(eventBus: busObject)
        guard let vm3 = vm3 else {
            return
        }
        print("🔮 3 test class 🔮")
        vm3.sink()
        vm.pubishEventBus()
        print("🔮 Bus removed 🔮")
        vm.pubishEventBus()
        // appEvents()
        view.backgroundColor = .yellow
    }
    var eventBusViewModel: EventBusFeatureTester?
    let eventBus = EventBus<SectionType, EventBusEventImp>()
    func checkEventBusFunctionality() {
        eventBusViewModel = EventBusFeatureTester(eventBus: eventBus)
        guard let eventBusViewModel = eventBusViewModel else {
            print("view model not created")
            return
        }
        eventBusViewModel.registerEventBusEvents()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.eventBusViewModel?.pubishEventBus(.success)

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.eventBusViewModel?.cancelEventBusListListner()

                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                    self?.eventBusViewModel?.pubishEventBus(.failed)
                }
            }
        }
    }
    let secondVM = EventBusFeatureTester2()
    func appEvents() {
        secondVM.sink()
        secondVM.fireEvent()
       // DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            // self?.secondVM.fireEvent()
        // }
    }
    deinit {
        EventBusContainer.shared.cleanBus(for: "superBill")
    }
}

/*
 class EventBusPublisher : Subject {
     typealias Output = Bool
     typealias Failure = Never
     var output: Output

     init(output: Output) {
         self.output = output
     }

     func send(_ value: Bool) {
     }

     func send(completion: Subscribers.Completion<Never>) {
     }

     func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Bool == S.Input {
         let subscription = EventBusSubscription(output: output, subscriber: subscriber)
         subscriber.receive(subscription: subscription)
     }

     func send(subscription: Subscription) {
     }
 }
 class EventBusSubscription<S: Subscriber>: Subscription where Bool == S.Input {
     var subscriber: S?
     var output: S.Input

     init(output: S.Input, subscriber: S) {
         self.output = output
         self.subscriber = subscriber
     }
     func request(_ demand: Subscribers.Demand) {
         _ = subscriber?
             .receive(output)
     }

     func cancel() {
         subscriber = nil
      }
 }
 */
