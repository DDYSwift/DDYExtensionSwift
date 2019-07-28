import Foundation

extension DispatchQueue {

    fileprivate static var currentQueueLabel: String? {
        let cString = __dispatch_queue_get_label(nil)
        return String(cString: cString)
    }
    // "com.apple.main-thread"
    fileprivate static var isMainQueue: Bool {
        return currentQueueLabel == self.main.label
    }
}

func ddyMainAsyncSafe(_ execute: @escaping () -> Void) {
    DispatchQueue.isMainQueue ? execute() : DispatchQueue.main.async(execute: execute)
}
