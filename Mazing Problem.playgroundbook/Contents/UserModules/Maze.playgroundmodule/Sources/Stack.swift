// This implements a Stack type based on Array
public struct Stack<T> {
    private var stack = [T]()
    
    // Provide a public initializer to initialize an empty stack
    public init() {}
    
    public mutating func add(_ element: T) {
        stack.append(element)
    }
    
    public mutating func pop() -> T? {
        stack.popLast()
    }
    
    public var isEmpty: Bool {
        stack.isEmpty
    }
}

