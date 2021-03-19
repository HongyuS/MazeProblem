// This implements a Stack type based on Array
public struct Stack<T> {
    private(set) var array = [T]()
    
    // Provide a public initializer to initialize an empty stack
    public init() {}
    
    public mutating func add(_ element: T) {
        array.append(element)
    }
    
    public mutating func pop() -> T? {
        array.popLast()
    }
    
    public var isEmpty: Bool {
        array.isEmpty
    }
    
    public var top: T? {
        if array.isEmpty {
            return nil
        } else {
            return array[array.endIndex - 1]
        }
    }
    
    public var rawData: [T] {
        array
    }
}

