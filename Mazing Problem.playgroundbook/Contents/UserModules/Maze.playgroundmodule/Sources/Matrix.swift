/// An abstract type of Matrix,
/// modified from docs.swift.org - "Subscripts".
public protocol Matrix: CustomStringConvertible {
    associatedtype Element
    var rows: Int { get }
    var columns: Int { get }
    var grid: [Element] { get set }
}

// MARK: Default implementations of methods of Matrix
extension Matrix {
    /// Method to check correctness of the given indexes
    private func indexIsValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    /// Subscript method to visit & modify elements in the matrix
    public subscript(row: Int, column: Int) -> Element {
        get {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            return grid[row * columns + column]
        }
        set {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            grid[row * columns + column] = newValue
        }
    }
}

// MARK: CustomStringConvertible
extension Matrix {
    public var description: String {
        var text = ""
        for i in 0 ..< grid.count {
            if i % columns == columns - 1 && i != grid.count - 1 {
                text += "\(grid[i])\n"
            } else {
                text += "\(grid[i])\t"
            }
        }
        return text
    }
}
