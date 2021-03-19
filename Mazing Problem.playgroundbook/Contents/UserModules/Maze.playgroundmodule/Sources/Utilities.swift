//
//  Utilities.swift
//  
//
//  Created by Hongyu Shi on 2021/3/19.
//

import Foundation

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
public func makeMaze(of rows: Int, by columns: Int) -> Maze {
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
public func makeMaze(from mazeString: String) -> Maze? {
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
