import UIKit

class DDYConvertTool: NSObject {
    /** 时间date转字符串 */
    public class func ddyDateToString(_ date: Date) -> String {
        return ddyDateToString(date, "yyyy-MM-dd HH:mm:ss zzz")
    }
    /** 时间date转字符串 自定义格式 */
    public class func ddyDateToString(_ date: Date,_ format: String) -> String {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    /** 数据data转字符串 GBK编码啥的重新写 */
    public class func ddyDataToString(_ data: Data) -> String {
        return String(data:data, encoding: String.Encoding.utf8) ?? ""
    }
    /** 字符串转数据data */
    public class func ddyStringToData(_ str: String) -> Data {
        return str.data(using: String.Encoding.utf8)!
    }
    /** json字符串转object https://www.jianshu.com/p/210254495d57 */
    public class func ddyParseJSONString(jsonString: String?) -> Any? {
        guard let data = jsonString?.data(using: String.Encoding.utf8, allowLossyConversion: true) else {
            return nil
        }
        guard let parsedJson = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else {
            return nil
        }
        return parsedJson
    }
    /** json字符串转字典 */
    public class func ddyJsonStringToDictionary(_ jsonString: String?) -> Dictionary<String, Any>? {
        guard let jsonData:Data = jsonString?.data(using: .utf8) else {
            return nil
        }
        guard let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) else {
            return nil
        }
        return dict as? Dictionary<String, Any>
    }
    /** json字符串转数组 */
    public class func ddyJsonStringToArray(_ jsonString: String?) -> Array<Any>? {
        guard let jsonData:Data = jsonString?.data(using: .utf8) else {
            return nil
        }
        guard let array = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) else {
            return nil
        }
        return array as? Array<Any>
    }
    /** 字典转json字符串 */
    public func ddyDictionaryToJsonString(_ dictionary: Dictionary<String, Any>) -> String? {
        if JSONSerialization.isValidJSONObject(dictionary) == false {
            return nil
        }
        guard let strData = try? JSONSerialization.data(withJSONObject: dictionary, options: []) else {
            return nil
        }
        guard let jsonStr = NSString(data:strData as Data, encoding: String.Encoding.utf8.rawValue) else {
            return nil
        }
        return jsonStr as String
    }
    /** 数组转json字符串 */
    public func ddyArrayToJsonString(_ array: Array<Any>) -> String? {
        if JSONSerialization.isValidJSONObject(array) == false {
            return nil
        }
        guard let strData = try? JSONSerialization.data(withJSONObject: array, options: []) else {
            return nil
        }
        guard let jsonStr = NSString(data:strData as Data, encoding: String.Encoding.utf8.rawValue) else {
            return nil
        }
        return jsonStr as String
    }
}
