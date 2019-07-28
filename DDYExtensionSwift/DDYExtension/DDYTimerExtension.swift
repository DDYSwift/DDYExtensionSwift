import UIKit

extension Timer {

    public static func ddyScheduledTimer(withTimeInterval interval: TimeInterval, repeats: Bool, block: @escaping (Timer) -> Void) -> Timer {
        if #available(iOS 10, *) {
            return scheduledTimer(withTimeInterval: interval, repeats: repeats, block: { block($0) })
        } else {
            return scheduledTimer(timeInterval: interval, target: self, selector: #selector(ddyTimerInvoke(_:)), userInfo: block, repeats: repeats)
        }
    }

    public class func ddyInit(timeInterval interval: TimeInterval, repeats: Bool, block: @escaping (Timer) -> Void)  -> Timer {
        if #available(iOS 10, *) {
            return self.init(timeInterval: interval, repeats: repeats, block: { block($0) })
        } else {
            return self.init(timeInterval: interval, target: self, selector: #selector(ddyTimerInvoke(_:)), userInfo: block, repeats: repeats)
        }
    }

    @objc static func ddyTimerInvoke(_ timer: Timer) {
        if let block = timer.userInfo as? (Timer) -> Void {
            block(timer)
        }
    }
}

class DDYTimer {
    // 单例 let timer = DDYTimer.defaultTimer
    static let `defaultTimer` = DDYTimer()
    private init() { }

    lazy var timerContainer: Dictionary = [String: DispatchSourceTimer]()

    /// GCD定时器
    ///
    /// - Parameters:
    ///   - name: 定时器名字
    ///   - timeInterval: 时间间隔
    ///   - queue: 队列
    ///   - repeats: 是否重复
    ///   - action: 执行任务的闭包
    func ddyTimer(name: String?, timeInterval: Double, queue: DispatchQueue, repeats: Bool, action: @escaping () -> Void) {

        if name == nil {
            return
        }

        var timer = timerContainer[name!]
        if timer == nil {
            timer = DispatchSource.makeTimerSource(flags: [], queue: queue)
            timer?.resume()
            timerContainer[name!] = timer
        }
        //精度0.1秒
        timer?.schedule(deadline: .now(), repeating: timeInterval, leeway: DispatchTimeInterval.milliseconds(100))
        timer?.setEventHandler(handler: { [weak self] in
            action()
            if repeats == false {
                self?.cancleTimer(WithTimerName: name)
            }
        })
    }

    /// 取消定时器
    ///
    /// - Parameter name: 定时器名字
    func cancleTimer(WithTimerName name: String?) {
        let timer = timerContainer[name!]
        if timer == nil {
            return
        }
        timerContainer.removeValue(forKey: name!)
        timer?.cancel()
    }


    /// 检查定时器是否已存在
    ///
    /// - Parameter name: 定时器名字
    /// - Returns: 是否已经存在定时器
    func isExistTimer(WithTimerName name: String?) -> Bool {
        if timerContainer[name!] != nil {
            return true
        }
        return false
    }

}
