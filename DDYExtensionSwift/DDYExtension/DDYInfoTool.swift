import UIKit
import AdSupport //IDFA .ASIdentifierManager
import SystemConfiguration.CaptiveNetwork // WifiSSID .CaptiveNetwork
import CoreTelephony // 网络制式 .CTTelephonyNetworkInfo .CTCarrier

public enum DDYDeviceUTSNameType: String {
    case sysname
    case nodename
    case release
    case version
    case machine
}

class DDYInfoTool: NSObject {
    /** 沙盒document路径 */
    public class func ddyDocumentPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
    /** 沙盒cache路径 */
    public class func ddyCachePath() -> String {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
    }
    /** 沙盒library路径 */
    public class func ddyLibraryPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
    }

    /** bundleName (show in SpringBoard) */
    public class func ddyAppBundleName() -> String {
        return Bundle.main.infoDictionary!["CFBundleName"] as! String
    }
    /** bundleID com.**.app */
    public class func ddyAppBundleID() -> String {
        return Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
    }
    /** 版本号 1.1.1 */
    public class func ddyAppVersion() -> String {
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }
    /** build 号 111 */
    public class func ddyAppBuildNumber() -> String {
        return Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    }

    /** 获取IDFA */
    public class func ddyIDFA() -> String {
        return ASIdentifierManager.shared().isAdvertisingTrackingEnabled ? ASIdentifierManager.shared().advertisingIdentifier.uuidString : ""
    }
    /** 获取IDFV */
    public class func ddyIDFV() -> String {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
    /** 获取UUID */
    public class func ddyUUID() -> String {
        return NSUUID().uuidString
    }
    /** 系统版本 */
    public class func ddySystemVersion() -> String {
        return UIDevice.current.systemVersion
    }

    /** 系统信息 */
    public class func ddySystemInfo(type: DDYDeviceUTSNameType) -> String {

        let ddyDeviceBasicInfo:(DDYDeviceUTSNameType) -> Mirror = {
            (type: DDYDeviceUTSNameType) -> Mirror in
            var systemInfo = utsname()
            uname(&systemInfo)
            switch type {
            case .sysname:  return  Mirror(reflecting: systemInfo.sysname)
            case .nodename: return  Mirror(reflecting: systemInfo.nodename)
            case .release:  return  Mirror(reflecting: systemInfo.release)
            case .version:  return  Mirror(reflecting: systemInfo.version)
            case .machine:  return  Mirror(reflecting: systemInfo.machine)
            }
        }

        let machineMirror = ddyDeviceBasicInfo(type)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 , value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }

    /** 获取设备型号 */
    public class func ddyDeviceModel() -> String {
        let identifier = ddySystemInfo(type: .machine)
        switch identifier {
        case "iPhone3,1":   return "iPhone 4"
        case "iPhone3,2":   return "iPhone 4"
        case "iPhone3,3":   return "iPhone 4"
        case "iPhone4,1":   return "iPhone 4S"
        case "iPhone5,1":   return "iPhone 5"
        case "iPhone5,2":   return "iPhone 5 (GSM+CDMA)"
        case "iPhone5,3":   return "iPhone 5c (GSM)"
        case "iPhone5,4":   return "iPhone 5c (GSM+CDMA)"
        case "iPhone6,1":   return "iPhone 5s (GSM)"
        case "iPhone6,2":   return "iPhone 5s (GSM+CDMA)"
        case "iPhone7,1":   return "iPhone 6 Plus"
        case "iPhone7,2":   return "iPhone 6"
        case "iPhone8,1":   return "iPhone 6s"
        case "iPhone8,2":   return "iPhone 6s Plus"
        case "iPhone8,4":   return "iPhone SE"
        // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
        case "iPhone9,1":   return "国行、日版、港行iPhone 7"
        case "iPhone9,2":   return "港行、国行iPhone 7 Plus"
        case "iPhone9,3":   return "美版、台版iPhone 7"
        case "iPhone9,4":   return "美版、台版iPhone 7 Plus"
        case "iPhone10,1":  return "iPhone 8"
        case "iPhone10,4":  return "iPhone 8"
        case "iPhone10,2":  return "iPhone 8 Plus"
        case "iPhone10,5":  return "iPhone 8 Plus"
        case "iPhone10,3":  return "iPhone X"
        case "iPhone10,6":  return "iPhone X"
        case "iPhone11,2":  return "iPhone XS"
        case "iPhone11,4":  return "iPhone XS Max"
        case "iPhone11,6":  return "iPhone XS Max"
        case "iPhone11,8":  return "iPhone XR"
        case "iPhone12,1":  return "iPhone 11"
        case "iPhone12,3":  return "iPhone 11Pro"
        case "iPhone12,5":  return "iPhone 11 ProMax"
        case "iPhone12,8":  return "iPhone SE2"
        case "iPhone13,1":  return "iPhone 12 Mini"
        case "iPhone13,2":  return "iPhone 12"
        case "iPhone13,3":  return "iPhone 12 Pro"
        case "iPhone13,4":  return "iPhone 12 ProMax"


        case "iPod1,1":     return "iPod Touch 1G"
        case "iPod2,1":     return "iPod Touch 2G"
        case "iPod3,1":     return "iPod Touch 3G"
        case "iPod4,1":     return "iPod Touch 4G"
        case "iPod5,1":     return "iPod Touch (5 Gen)"
        case "iPod7,1":     return "iPod touch 6"

        case "iPad1,1":     return "iPad"
        case "iPad1,2":     return "iPad 3G"
        case "iPad2,1":     return "iPad 2 (WiFi)"
        case "iPad2,2":     return "iPad 2"
        case "iPad2,3":     return "iPad 2 (CDMA)"
        case "iPad2,4":     return "iPad 2"
        case "iPad2,5":     return "iPad Mini (WiFi)"
        case "iPad2,6":     return "iPad Mini"
        case "iPad2,7":     return "iPad Mini (GSM+CDMA)"
        case "iPad3,1":     return "iPad 3 (WiFi)"
        case "iPad3,2":     return "iPad 3 (GSM+CDMA)"
        case "iPad3,3":     return "iPad 3"
        case "iPad3,4":     return "iPad 4 (WiFi)"
        case "iPad3,5":     return "iPad 4"
        case "iPad3,6":     return "iPad 4 (GSM+CDMA)"
        case "iPad4,1":     return "iPad Air (WiFi)"
        case "iPad4,2":     return "iPad Air (Cellular)"
        case "iPad4,4":     return "iPad Mini 2 (WiFi)"
        case "iPad4,5":     return "iPad Mini 2 (4G/Cellular)"
        case "iPad4,6":     return "iPad Mini 2 (CDMA EV-DO)"
        case "iPad4,7":     return "iPad Mini 3 (WiFi)"
        case "iPad4,8":     return "iPad Mini 3 (4G)"
        case "iPad4,9":     return "iPad Mini 3 (4G)"
        case "iPad5,1":     return "iPad Mini 4 (WiFi)"
        case "iPad5,2":     return "iPad Mini 4 (4G/LTE)"
        case "iPad5,3":     return "iPad Air 2 (WiFi)"
        case "iPad5,4":     return "iPad Air 2 (4G)"
        case "iPad6,3":     return "iPad Pro (9.7-inch-WiFi)"
        case "iPad6,4":     return "iPad Pro (9.7-inch-4G)"
        case "iPad6,7":     return "iPad Pro (12.9-inch-WiFi)"
        case "iPad6,8":     return "iPad Pro (12.9-inch-4G)"
        case "iPad6,11":    return "iPad 5 (WiFi)"
        case "iPad6,12":    return "iPad 5 (4G)"
        case "iPad7,1":     return "iPad Pro 2 (12.9-inch-WiFi)"
        case "iPad7,2":     return "iPad Pro 2 (12.9-inch-4G)"
        case "iPad7,3":     return "iPad Pro (10.5-inch-WiFi)"
        case "iPad7,4":     return "iPad Pro (10.5-inch-4G)"
        case "iPad7,5":     return "iPad 6 (WiFi)"
        case "iPad7,6":     return "iPad 6 (4G)"

        case "i386":        return "Simulator"
        case "x86_64":      return "Simulator"
        default:
            return identifier
        }
    }

    /** 获取设备名字 */
    public class func ddyDeviceName() -> String {
        return UIDevice.current.name
    }
    /** 获取磁盘大小 */
    public class func ddyTotalDiskSpaceInBytes() -> Int64 {
        guard let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String),
            let space = (systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value else { return 0 }
        return space
    }
    /** 还未使用空间 */
    public class func ddyFreeDiskSpaceInBytes() -> Int64 {
        if #available(iOS 11.0, *) {
            // iOS 11中增加了volumeAvailableCapacityForImportantUsageKey、volumeAvailableCapacityForOpportunisticUsageKey。
            if let space = try? URL(fileURLWithPath: NSHomeDirectory() as String).resourceValues(forKeys: [URLResourceKey.volumeAvailableCapacityForImportantUsageKey]).volumeAvailableCapacityForImportantUsage {
                return Int64(space)
            } else {
                return 0
            }
        } else {
            if let space = try? URL(fileURLWithPath: NSHomeDirectory() as String).resourceValues(forKeys: [URLResourceKey.volumeAvailableCapacityKey]).volumeAvailableCapacity {
                return Int64(space)
            } else {
                return 0
            }
        }
    }
    /** 已使用空间 **/
    public class func ddyUsedDiskSpaceInBytes() -> Int64 {
        return ddyTotalDiskSpaceInBytes() - ddyFreeDiskSpaceInBytes()
    }
    /** wifi名称 */
    public class func ddyWifiSSID() -> String {
        let interfaces = CNCopySupportedInterfaces()
        var ssid = ""
        if interfaces != nil {
            let interfacesArray = CFBridgingRetain(interfaces) as! Array<AnyObject>
            if interfacesArray.count > 0 {
                let interfaceName = interfacesArray[0] as! CFString
                let ussafeInterfaceData = CNCopyCurrentNetworkInfo(interfaceName)
                if (ussafeInterfaceData != nil) {
                    let interfaceData = ussafeInterfaceData as! Dictionary<String, Any>
                    ssid = interfaceData["SSID"]! as! String
                }
            }
        }
        return ssid
    }
    /** 网络制式 */
    func myOpreation(_ a: Int , _ b: Int, operation: (Int , Int) -> Int) -> Int {
        let res = operation(a, b)
        return res
    }
    /** 网络制式
     参考:http://www.hangge.com/blog/cache/detail_1607.html
     字典为nil表示获取失败或者无sim卡
     "carrier" 获取原始运营商呢信息 info.subscriberCellularProvider
     "radioTech" 获取原始数据业务信息 info.currentRadioAccessTechnology
     "carrierName" 获取运营商名字
     "mobileCountryCode" 电信国家码
     "mobileCountryCode" 电信网络码
     "isoCountryCode" ISO国家代码
     "allowsVOIP" 是否允许VOIP
     "netType" 获取制式，如LTE-4G
     */
    public class func ddyNetCarrier() -> Dictionary<String, Any>? {
        let info = CTTelephonyNetworkInfo()
        if let carrier = info.subscriberCellularProvider {
            if let radioTech = info.currentRadioAccessTechnology {
                var dictionary = Dictionary<String, Any>()
                dictionary.updateValue(carrier, forKey: "carrier")
                dictionary.updateValue(radioTech, forKey: "radioTech")
                dictionary.updateValue(carrier.carrierName ?? "Unknown", forKey: "carrierName")
                dictionary.updateValue(carrier.mobileCountryCode ?? "Unknown", forKey: "mobileCountryCode")
                dictionary.updateValue(carrier.mobileNetworkCode ?? "Unknown", forKey: "mobileCountryCode")
                dictionary.updateValue(carrier.isoCountryCode ?? "Unknown", forKey: "isoCountryCode")
                dictionary.updateValue(carrier.allowsVOIP, forKey: "allowsVOIP")
                switch radioTech {
                case CTRadioAccessTechnologyLTE:            dictionary.updateValue("LTE-4G", forKey: "allowsVOIP")
                case CTRadioAccessTechnologyWCDMA:          dictionary.updateValue("WCDMA-3G", forKey: "allowsVOIP")
                case CTRadioAccessTechnologyEdge:           dictionary.updateValue("EDGE-2G", forKey: "allowsVOIP")
                case CTRadioAccessTechnologyeHRPD:          dictionary.updateValue("eHRPD-3G", forKey: "allowsVOIP")
                case CTRadioAccessTechnologyCDMA1x:         dictionary.updateValue("CDMA-1x", forKey: "allowsVOIP")
                case CTRadioAccessTechnologyCDMAEVDORev0:   dictionary.updateValue("EVDO-3G", forKey: "allowsVOIP")
                case CTRadioAccessTechnologyCDMAEVDORevA:   dictionary.updateValue("EVDO-3G", forKey: "allowsVOIP")
                case CTRadioAccessTechnologyCDMAEVDORevB:   dictionary.updateValue("EVDO-3G", forKey: "allowsVOIP")
                case CTRadioAccessTechnologyGPRS:           dictionary.updateValue("GPRS-2G/3G", forKey: "allowsVOIP")
                case CTRadioAccessTechnologyHSDPA:          dictionary.updateValue("HSDPA-3G+", forKey: "allowsVOIP")
                case CTRadioAccessTechnologyHSUPA:          dictionary.updateValue("HSUPA-3G+", forKey: "allowsVOIP")
                default:                                    dictionary.updateValue("Unknown-Unknown", forKey: "allowsVOIP")
                return dictionary
                }
            }
        }
        return nil;
    }

    /*** 设备运营商IP https://www.cnblogs.com/qingzZ/p/11045795.html */
    public class func ddyDeviceIP() -> String {
        var addresses = [String]()
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while (ptr != nil) {
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String(validatingUTF8:hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        return addresses.first ?? "0.0.0.0"
    }
}
/** 信息打印 https://github.com/starainDou/DDYKnowledge/blob/master/Files/BuildConfiguration.md */
func ddyInfoLog<T>(_ message: T, fileName: String = #file, methodName: String = #function, lineNumber: Int = #line) {
    #if DEBUG
    print("\nDebug\nFileName:\(fileName as NSString)\nMethodName:\(methodName)\nLineNumber:\(lineNumber)\n\(message)")
    #elseif ONLINEDEBUG
    print("\nOnlineDebug\nFileName:\(fileName as NSString)\nMethodName:\(methodName)\nLineNumber:\(lineNumber)\n\(message)")
    #else
    print("\nRelease\nFileName:\(fileName as NSString)\nMethodName:\(methodName)\nLineNumber:\(lineNumber)\n\(message)")
    #endif
}

func ddyLog<N>(_ message: N) {
    #if DEBUG
    print("\(message)")
    #elseif ONLINEDEBUG
    print("\(message)")
    #endif
}

func DDYPrint<M>(_ message: M) {
    if _isDebugAssertConfiguration() {
        print("\(message)")
    }
}

func requestHost() -> String {
    #if DEBUG
    return "http://10.10.8.22:9214"
    #elseif ONLINEDEBUG
    return "http://online.imaicai.baobaoaichi.com"
    #else
    return "http://imaicai.baobaoaichi.com"
    #endif
}
