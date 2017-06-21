import Foundation

class ResponseToCollectionParser<T> {
    func parse(_ dictionary: [[String: AnyObject]]) -> [T] {
        fatalError("must be implemented by subclass")
    }
}

class ResponseToObjectParser<T> {
    func parse(_ dictionary: [String: Any]) throws -> T {
        fatalError("must be implemented by subclass")
    }
}


public enum ParsingError: Error {
    case field(String)
    case fields([String])
    case unknown
}

public protocol Decodable {
    static func decode(_ anyObject: Any) -> Self?
}

extension Decodable {
    public static func decode(_ anyObject: Any) -> Self? {
        return anyObject as? Self
    }
}


public protocol Parsable: Decodable {
    init(dict: [String: Any]) throws
}

extension NSDecimalNumber : Decodable {
    public static func decode(_ anyObject: Any) -> Self? {
        if let string = anyObject as? String {
            return self.init(string: string)
        }
        return nil
    }
}

precedencegroup ParsingPrecedence {
    associativity: left
    higherThan: AdditionPrecedence
}

infix operator <- : ParsingPrecedence
infix operator <~ : ParsingPrecedence

extension String : Decodable { }
extension Int : Decodable { }
extension Bool: Decodable { }
extension TimeInterval: Decodable { }

public func <- <T: Decodable> (key: String, dict: [String : Any]) throws -> T {
    
    guard let value: T = key <~ dict  else {
        throw ParsingError.field(key)
    }
    return value
}

public extension Decodable where Self: Parsable {
    public static func decode(_ anyObject: Any) -> Self? {
        guard let dict = anyObject as? [String : Any] else {
            return nil
        }
        
        do {
            return try Self.init(dict: dict)
        } catch {
            return nil
        }
    }
}

public func <- <T: Decodable> (keys: [String], dict: [String : Any]) throws -> T {
    guard let value: T = keys <~ dict else {
        throw ParsingError.fields(keys)
    }
    return value
}


public func <~ <T: Decodable> (key: String, dict: [String : Any]) -> T? {
    guard let anyObject = dict[key] else {
        return nil
    }
    return T.decode(anyObject)
}

public func <~ <T: Decodable> (keys: [String], dict: [String : Any]) -> T? {
    for key in keys {
        if let value: T = key <~ dict {
            return value
        }
    }
    return nil
}


public func <- (key: String, dict: [String : Any]) throws
    -> [String: Any] {
        guard let value: [String: Any] = key <~ dict else {
            throw ParsingError.field(key)
        }
        return value
}

public func <~ (key: String, dict: [String : Any]) -> [String: Any]? {
    guard let anyObject = dict[key] as? [String: Any] else {
        return nil
    }
    return anyObject
}

public func <- (key: String, dict: [String : Any]) throws
    -> [String: AnyObject] {
        guard let value: [String: AnyObject] = key <~ dict else {
            throw ParsingError.field(key)
        }
        return value
}

public func <~ (key: String, dict: [String : Any]) -> [String: AnyObject]? {
    guard let anyObject = dict[key] as? [String: AnyObject] else {
        return nil
    }
    return anyObject
}

public func <- <Value: Decodable> (key: String, dict: [String : Any]) throws
    -> [String: [String: Value]] {
        guard let value: [String: [String: Value]] = key <~ dict else {
            throw ParsingError.field(key)
        }
        return value
}

public func <~ <Value: Decodable> (key: String, dict: [String : Any])
    -> [String: [String: Value]]? {
        guard let outer = dict[key] as? [String: Any] else {
            return nil
        }
        var newDict = [String: [String: Value]]()
        for key1 in outer.keys {
            do {
                newDict[key1] = try key1 <- outer
            } catch {
                return nil
            }
        }
        return newDict
}

public func <- <Value: Decodable> (key: String, dict: [String : Any]) throws
    -> [String: Value] {
        guard let value: [String: Value] = key <~ dict else {
            throw ParsingError.field(key)
        }
        return value
}

public func <~ <Value: Decodable> (key: String, dict: [String : Any])
    -> [String: Value]? {
        guard let anyObject = dict[key] as? [String: Any] else {
            return nil
        }
        let values = try? anyObject.keys.map { (key) -> Value in
            guard let val = anyObject[key], let value = Value.decode(val) else {
                throw ParsingError.field(key)
            }
            return value
        }
        return values.map({ dictionary(fromKeys: Array(anyObject.keys), andValues:Array($0)) })
}

public func <- <T: Decodable> (key: String, dict: [String : Any]) throws -> [T] {
    guard let value: [T] = key <~ dict  else {
        throw ParsingError.field(key)
    }
    return value
}

public func <~ <T: Decodable> (key: String, dict: [String : Any]) -> [T]? {
    let array: [Any]
    
    if let object = dict[key] as? [Any] {
        array = object
    } else if let object = dict[key] {
        array = [object]
    } else {
        return nil
    }
    
    let parsedArray = array.map({ (anyObject) in
        return T.decode(anyObject)
    })
    
    if parsedArray.contains(where: { decodable in decodable == nil }) {
        return nil
    }
    
    return parsedArray.flatMap({ (decodable) -> T? in
        return decodable
    })
}

public func <- (key: String, dict: [String : Any]) throws -> [[String: Any]] {
    guard let value: [[String: Any]] = key <~ dict  else {
        throw ParsingError.field(key)
    }
    return value
}

public func <~ (key: String, dict: [String : Any]) -> [[String: Any]]? {
    let array: [Any]
    
    if let object = dict[key] as? [Any] {
        array = object
    } else if let object = dict[key] {
        array = [object]
    } else {
        return nil
    }
    
    let parsedArray = array.map({ (anyObject) in
        return anyObject as? [String: Any]
    })
    
    if parsedArray.contains(where: { decodable in decodable == nil }) {
        return nil
    }
    
    return parsedArray.flatMap({ (decodable) -> [String: Any]? in
        return decodable
    })
}

public func <- (key: String, dict: [String : Any]) throws -> [[String: AnyObject]] {
    guard let value: [[String: AnyObject]] = key <~ dict  else {
        throw ParsingError.field(key)
    }
    return value
}

public func <~ (key: String, dict: [String : Any]) -> [[String: AnyObject]]? {
    let array: [Any]
    
    if let object = dict[key] as? [Any] {
        array = object
    } else if let object = dict[key] {
        array = [object]
    } else {
        return nil
    }
    
    let parsedArray = array.map({ (anyObject) in
        return anyObject as? [String: AnyObject]
    })
    
    if parsedArray.contains(where: { decodable in decodable == nil }) {
        return nil
    }
    
    return parsedArray.flatMap({ (decodable) -> [String: AnyObject]? in
        return decodable
    })
}

fileprivate func dictionary<K: Hashable, V>(fromKeys keys: [K], andValues values: [V]) -> [K: V] {
    assert((keys.count == values.count), "number of elements odd")
    var result = [K: V]()
    for i in 0..<keys.count {
        result[keys[i]] = values[i]
    }
    return result
}
