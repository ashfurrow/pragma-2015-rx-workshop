//
//  ConcurrentDispatchQueueScheduler.swift
//  RxSwift
//
//  Created by Krunoslav Zaher on 7/5/15.
//  Copyright (c) 2015 Krunoslav Zaher. All rights reserved.
//

import Foundation

/**
Abstracts the work that needs to be peformed on a specific `dispatch_queue_t`. You can also pass a serial dispatch queue, it shouldn't cause any problems.

This scheduler is suitable when some work needs to be performed in background.
*/
public class ConcurrentDispatchQueueScheduler: SchedulerType {
    public typealias TimeInterval = NSTimeInterval
    public typealias Time = NSDate
    
    private let queue : dispatch_queue_t
    
    public var now : NSDate {
        get {
            return NSDate()
        }
    }
    
    // leeway for scheduling timers
    var leeway: Int64 = 0
    
    /**
    Constructs new `ConcurrentDispatchQueueScheduler` that wraps `queue`.
    
    - parameter queue: Target dispatch queue.
    */
    public init(queue: dispatch_queue_t) {
        self.queue = queue
    }
    
    /**
    Convenience init for scheduler that wraps one of the global concurrent dispatch queues.
    
    - parameter globalConcurrentQueuePriority: Target global dispatch queue.
    */
    public convenience init(globalConcurrentQueuePriority: DispatchQueueSchedulerPriority) {
        var priority: Int = 0
        switch globalConcurrentQueuePriority {
        case .High:
            priority = DISPATCH_QUEUE_PRIORITY_HIGH
        case .Default:
            priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        case .Low:
            priority = DISPATCH_QUEUE_PRIORITY_LOW
        }
        self.init(queue: dispatch_get_global_queue(priority, UInt(0)))
    }
    
    class func convertTimeIntervalToDispatchInterval(timeInterval: NSTimeInterval) -> Int64 {
        return Int64(timeInterval * Double(NSEC_PER_SEC))
    }
    
    class func convertTimeIntervalToDispatchTime(timeInterval: NSTimeInterval) -> dispatch_time_t {
        return dispatch_time(DISPATCH_TIME_NOW, convertTimeIntervalToDispatchInterval(timeInterval))
    }
    
    /**
    Schedules an action to be executed immediatelly.
    
    - parameter state: State passed to the action to be executed.
    - parameter action: Action to be executed.
    - returns: The disposable object used to cancel the scheduled action (best effort).
    */
    public final func schedule<StateType>(state: StateType, action: StateType -> Disposable) -> Disposable {
        return self.scheduleInternal(state, action: action)
    }
    
    func scheduleInternal<StateType>(state: StateType, action: StateType -> Disposable) -> Disposable {
        let cancel = SingleAssignmentDisposable()
        
        dispatch_async(self.queue) {
            if cancel.disposed {
                return
            }
            
            cancel.disposable = action(state)
        }
        
        return cancel
    }
    
    /**
    Schedules an action to be executed.
    
    - parameter state: State passed to the action to be executed.
    - parameter dueTime: Relative time after which to execute the action.
    - parameter action: Action to be executed.
    - returns: The disposable object used to cancel the scheduled action (best effort).
    */
    public final func scheduleRelative<StateType>(state: StateType, dueTime: NSTimeInterval, action: (StateType) -> Disposable) -> Disposable {
        let timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.queue)
        
        let dispatchInterval = MainScheduler.convertTimeIntervalToDispatchTime(dueTime)
        
        let compositeDisposable = CompositeDisposable()
        
        dispatch_source_set_timer(timer, dispatchInterval, DISPATCH_TIME_FOREVER, 0)
        dispatch_source_set_event_handler(timer, {
            if compositeDisposable.disposed {
                return
            }
           compositeDisposable.addDisposable(action(state))
        })
        dispatch_resume(timer)
        
        compositeDisposable.addDisposable(AnonymousDisposable {
            dispatch_source_cancel(timer)
            })
        
        return compositeDisposable
    }
    
    /**
    Schedules a periodic piece of work.
    
    - parameter state: State passed to the action to be executed.
    - parameter startAfter: Period after which initial work should be run.
    - parameter period: Period for running the work periodically.
    - parameter action: Action to be executed.
    - returns: The disposable object used to cancel the scheduled action (best effort).
    */
    public func schedulePeriodic<StateType>(state: StateType, startAfter: TimeInterval, period: TimeInterval, action: (StateType) -> StateType) -> Disposable {
        let timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.queue)
        
        let initial = MainScheduler.convertTimeIntervalToDispatchTime(startAfter)
        let dispatchInterval = MainScheduler.convertTimeIntervalToDispatchInterval(period)
        
        var timerState = state
        
        let validDispatchInterval = dispatchInterval < 0 ? 0 : UInt64(dispatchInterval)
        
        dispatch_source_set_timer(timer, initial, validDispatchInterval, 0)
        let cancel = AnonymousDisposable {
            dispatch_source_cancel(timer)
        }
        dispatch_source_set_event_handler(timer, {
            if cancel.disposed {
                return
            }
            timerState = action(timerState)
        })
        dispatch_resume(timer)
        
        return cancel
    }
}