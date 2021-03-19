//#-hidden-code
//
//  main.swift
//
//  Copyright © 2021 Hongyu Shi. All rights reserved.
//
//#-end-hidden-code
/*:
 
 */
/// A static demo MAZE for testing
let demoMaze: String = """
++++++++++++++++++++++
+   +   ++ ++     ++++
+ +   +       +++ + ++
+ + +  ++  ++++   + ++
+++ ++++++    +++ +  +
+          ++  ++    +
+++++ ++++++   +++++ +
+     +   +++++++  + +
+ +++++++        +   +
+      +   ++    + +++
+++++ ++     +++++++ +
+ ++ ++   ++++  ++ +++
++++ +++++++  + ++++++
++   +++    ++++++ + +
+++ ++ +++++    ++   +
+   +++++    ++++   ++
+ ++     ++++  +++ +++
+ ++ ++++++++++++ + ++
+ ++ ++          ++ ++
+ ++   +++ +++   +++++
+++ ++++++   ++++    +
++++++++++++++++++++++
"""

/// This function makes a random maze of given size.
///
/// The random maze may not have a solution.
///
/// - parameter rows: Number of rows in the maze.
/// - parameter columns: Number of columns in the maze.
/// - returns: A random maze of type `Matrix<Int>`.
///
/// ## Notes: ##
/// 1. For convenience, the maze must be surrounded by walls, so the actuall number of rows and columns in the matrix are `(rows + 2)` and `(columns + 2)`.
/// 2. The top left position (`[1, 1]`) is the entrance and the bottom right position (`[rows, columns]`) is the goal.
///
/// ## Example ##
/// ```
/// let randomMaze = makeMaze(of: 10, by: 10)
/// ```
func makeMaze(of rows: Int, by columns: Int) -> Maze {
    // Initiate an empty martix
    var maze = Maze(rows: rows + 2, columns: columns + 2,
                    defaultValue: 0)
    for i in 0 ... rows + 1 {
        for j in 0 ... columns + 1 {
            if i == 0 || j == 0 || i == rows + 1 || j == columns + 1 {
                maze[i, j] = 1
            } else if (i != 1 || j != 1) && (i != rows || j != columns) {
                maze[i, j] = Int.random(in: 0 ... 1)
            }
        }
    }
    return maze
}

/// This function makes a maze from a given string.
///
/// Here is an example of input maze:
/// ```
/// ++++++++
/// + ++ +++
/// ++   + +
/// + ++ +++
/// ++ ++  +
/// ++++++++
/// ```
/// - parameter mazeString: The `String` representation of a maze.
/// - returns: The `Matrix<Int>` representation of the given maze.
///
/// ## Notes: ##
/// 1. The input string must have lines with equal length, and it must consist of "`+`" representing walls and "` `" representing pathways.
/// 2. The input maze must be surrounded by walls. The top left position is the entrance and the bottom right position is the goal, thus they must be linked with empty pathways.
/// 3. Handle return type because it is optional.
///
/// ## Example ##
/// ```
/// if let maze = makeMaze(from: demoMaze) {
///     ** Do something here **
/// }
/// ```
func makeMaze(from mazeString: String) -> Maze? {
    // Get number of rows and columns from the input string
    let rows: [Substring] = mazeString.split(separator: "\n")
    let rowCount: Int = rows.count
    let columnCount: Int = rows[1].count
    
    // Construct the grid array from the input string
    var mazeGrid = [Int]()
    for character in mazeString {
        if character == "+" {
            mazeGrid.append(1)
        } else if character == " " {
            mazeGrid.append(0)
        }
    }
    
    // Check if the structure is correct, and return the maze
    guard mazeGrid.count == rowCount * columnCount else { return nil }
    return Maze(rows: rowCount, columns: columnCount, grid: mazeGrid)
}

// MARK: - Definition of Maze
struct Maze: Matrix {
    typealias Element = Int
    let rows: Int
    let columns: Int
    var grid: [Int]
    
    // MARK: Initializers
    /// Initialize a grid filled with default value
    public init(rows: Int, columns: Int, defaultValue: Element) {
        self.columns = columns
        self.rows = rows
        grid = Array(repeating: defaultValue, count: rows * columns)
    }
    /// Initialize from an existing grid
    public init(rows: Int, columns: Int, grid: [Element]) {
        self.columns = columns
        self.rows = rows
        self.grid = grid
    }
}

// MARK: - Subtypes and Methods of Maze
extension Maze {
    
    // MARK: Define subtypes used by Maze
    /// Coordinate of a position in the MAZE
    struct Coordinate: Equatable {
        let row: Int
        let col: Int
        
        mutating func move(to dir: Direction) {
            self = self + dir.delta()
        }
        
        // Define Operator Methods
        static func + (left: Coordinate, right: Coordinate) -> Coordinate {
            return Coordinate(row: left.row + right.row,
                              col: left.col + right.col)
        }
        static func - (left: Coordinate, right: Coordinate) -> Coordinate {
            return Coordinate(row: left.row - right.row,
                              col: left.col - right.col)
        }
        // Compound Assignment Operators
        static func += (left: inout Coordinate, right: Coordinate) {
            left = left + right
        }
        static func -= (left: inout Coordinate, right: Coordinate) {
            left = left - right
        }
        // Equivalence Operator
        static func == (left: Coordinate, right: Coordinate) -> Bool {
            return (left.row == right.row) && (left.col == right.col)
        }
    }
    
    /// Directions which the player may move in the MAZE
    enum Direction: String, CaseIterable {
        case north, northEast, east, southEast
        case south, southWest, west, northWest
        /// Get coordinate change after the movement
        func delta() -> Coordinate {
            switch self {
            case .north: return Coordinate(row: -1, col: 0)
            case .northEast: return Coordinate(row: -1, col: 1)
            case .east: return Coordinate(row: 0, col: 1)
            case .southEast: return Coordinate(row: 1, col: 1)
            case .south: return Coordinate(row: 1, col: 0)
            case .southWest: return Coordinate(row: 1, col: -1)
            case .west: return Coordinate(row: 0, col: -1)
            case .northWest: return Coordinate(row: -1, col: -1)
            }
        }
        /// Get the opposite direction
        func opposite() -> Direction {
            switch self {
            case .north: return .south
            case .northEast: return .southWest
            case .east: return .west
            case .southEast: return .northWest
            case .south: return .north
            case .southWest: return .northEast
            case .west: return .east
            case .northWest: return .southEast
            }
        }
    }
    
    /// Status of a position on the path
    enum PathStatus {
        case new
        case visited
    }
    
    /// Matrix to record visited positions on the path
    struct PathMark: Matrix {
        typealias Element = PathStatus
        let rows: Int
        let columns: Int
        var grid: [Element]
        public init(rows: Int, columns: Int, defaultValue: Element) {
            self.columns = columns
            self.rows = rows
            grid = Array(repeating: defaultValue, count: rows * columns)
        }
    }
    
    // MARK: Define coordinates of start & goal
    /// Coordinate of the starting position
    var start: Coordinate { Coordinate(row: 1, col: 1) }
    /// Coordinate of the goal of the MAZE
    var goal: Coordinate { Coordinate(row: rows - 2,
                                      col: columns - 2) }
    
    // MARK: Functions to solve the MAZE
    /// Method to check whether the movement is valid
    /// - parameter dir: Direction of the movement
    /// - parameter coord: Starting coordinate
    /// - parameter mark: Reference to the marker matrix
    private func isMoveValid(_ dir: Direction,
                             _ coord: Coordinate,
                             _ mark: PathMark) -> Bool {
        let next = coord + dir.delta()
        guard mark[next.row, next.col] == .new else {
            return false
        }
        switch self[next.row, next.col] {
        case 0: return true
        default: return false
        }
    }
    
    /// Method to mark visited positions along the path
    /// - parameter coord: The coordinate visited
    /// - parameter mark: Reference to the marker matrix
    private func markVisited(at coord: Coordinate,
                             _ mark: inout PathMark) {
        mark[coord.row, coord.col] = .visited
    }
    
    
    /// Main function to solve the MAZE
    public func findPath() {
        // Initiate the marker matrix
        var mark = PathMark(rows: rows, columns: columns,
                            defaultValue: .new)
        // Initiate an empty stack to store the path visited
        var stack = Stack<(Coordinate, Direction)>()
        // Initiate the current coordinate to the starting position
        var coord = start
        // var direction: Direction
        self.markVisited(at: start, &mark)
        repeat {
            // Check whether the MAZE is solved
            if coord == goal {
                print("Success!")
                break
            } else { // Solve the MAZE here
                var moved = false
                for dir in Direction.allCases {
                    if isMoveValid(dir, coord, mark) {
                        stack.add((coord, dir))
                        coord.move(to: dir)
                        // direction = dir
                        markVisited(at: coord, &mark)
                        print("Coordinate (\(coord.row), \(coord.col)) is visited.")
                        moved = true
                        break
                    }
                }
                if !moved {
                    if let (c, dir) = stack.pop() {
                        coord = c
                        // direction = dir.opposite()
                    } else {
                        print("No solution found!")
                    }
                }
            }
        } while !stack.isEmpty
        
    }
}

//  let randomMaze = makeMaze(of: 20, by: 20)
//  print(randomMaze)
if let maze = makeMaze(from: demoMaze) {
//      print(maze)
//      maze.test()
    maze.findPath()
}
