import Foundation

public func dLog(@autoclosure message:  () -> String, filename: String = #file, function: String = #function, line: Int = #line) {
#if DEBUG
    NSLog("[\(NSURL(string: filename)?.lastPathComponent):\(line)] \(function) - %@", message())
#else
#endif
}
public func aLog(@autoclosure message:  () -> String, filename: String = #file, function: String = #function, line: Int = #line) {
    NSLog("[\(NSURL(string: filename)?.lastPathComponent):\(line)] \(function) - %@", message())
}