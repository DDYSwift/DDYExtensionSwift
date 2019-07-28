// String扩展


import UIKit

extension String: DDYNameSpaceProtocol { }

extension DDYWrapperProtocol where DDYT == String {

    /// 去掉两端空格和换行符
    public func trimWhiteispaceAndNewline() -> String {
        return ddyValue.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    /// 去掉指定字符集中字符
    public func trimPerCharacter(in characterStr: String) -> String {
        return ddyValue.trimmingCharacters(in: CharacterSet.init(charactersIn: characterStr))
    }
    /// json字符串格式化输出
    public func jsonFormat() -> String {

        if (ddyValue.starts(with: "{") || ddyValue.starts(with: "[")) {
            var level = 0
            var jsonFormatString = String()
            func getLevelStr(level:Int) -> String {
                var string = ""
                for _ in 0..<level {
                    string.append("\t")
                }
                return string
            }

            for char in ddyValue {

                if level > 0 && "\n" == jsonFormatString.last {
                    jsonFormatString.append(getLevelStr(level: level))
                }

                switch char {
                case "{":
                    fallthrough
                case "[":
                    level += 1
                    jsonFormatString.append(char)
                    jsonFormatString.append("\n")
                case ",":
                    jsonFormatString.append(char)
                    jsonFormatString.append("\n")
                case "}":
                    fallthrough
                case "]":
                    level -= 1;
                    jsonFormatString.append("\n")
                    jsonFormatString.append(getLevelStr(level: level));
                    jsonFormatString.append(char);
                    break;
                default:
                    jsonFormatString.append(char)
                }
            }
            return jsonFormatString;
        }
        return ddyValue
    }
}

// 下标截取任意位置的便捷方法
extension String {

    private var length: Int {
        return self.count
    }

    public func ddySubstring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    public func ddySubstring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    /// 通过下标范围取值和赋值 如 let subStr = str1[0..<10] str2[0..<2] = "NB"
    subscript (range: Range<Int>) -> String {
        get {
            let newRange = Range(uncheckedBounds: (lower: max(0, min(self.count, range.lowerBound)), upper: min(self.count, max(0, range.upperBound))))
            let start = index(startIndex, offsetBy: newRange.lowerBound)
            let end = index(start, offsetBy: newRange.upperBound - newRange.lowerBound)
            return String(self[start ..< end])
        }
        set {
            let newRange = Range(uncheckedBounds: (lower: max(0, min(self.count, range.lowerBound)), upper: min(self.count, max(0, range.upperBound))))
            let tmp = self
            var preStr = ""
            var sufStr = ""
            for (idx, item) in tmp.enumerated() {
                if (idx < newRange.startIndex) {
                    preStr += "\(item)"
                } else if (idx >= newRange.endIndex) {
                    sufStr += "\(item)"
                }
            }
            self = preStr + newValue + sufStr
        }
    }
    /// 通过起始下标和长度取值与赋值 如 let subStr = str1[0, 10] str2[0, 2] = "NB"
    subscript(location:Int, length:Int) -> String {
        get {
            return self[location..<location+length]
        }
        set {
            self[location..<location+length] = newValue
        }
    }
    /// 通过索引下标取值与赋值
    subscript(index: Int) -> String {
        get {
            return self[index ..< index + 1]
        }
        set {
            self[index..<index+1] = newValue
        }
    }
}

/// 判断字符串是否为空或nil 
public func ddyEmptyString(_ value: AnyObject?) -> Bool {
    if nil == value { //首先判断是否为nil
        return true
    } else {
        if let myValue = value as? String { //然后是否可以转化为String
            return myValue == "" || myValue == "(null)" || 0 == myValue.count
        } else { //字符串都不是，直接认为是空串
            return true
        }
    }
}
