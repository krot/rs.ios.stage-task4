import Foundation

final class FillWithColor {
  
  func fillWithColor(_ image: [[Int]], _ row: Int, _ column: Int, _ newColor: Int) -> [[Int]] {
    //check isEmpty
    if image.isEmpty || image.first!.isEmpty  {
      return image //[[]]
    }
    
    let m = image.count - 1
    let n = image.first!.count - 1
    
    //check limits
    if row > m || column > n || m > 50 || n > 50 || newColor > 65536 || row < 0 || column < 0{
      return image //[[]]
    }
    
    var result = image
    var queue : [(Int,Int)] = []
    //добавляем массив проверенных
    var checkedCoordinates  : [(Int,Int)] = []
    
    let oldColor = result[row][column]
    queue.append((row,column))
    
    while !queue.isEmpty {
      //точно есть значение, поэтому смело unwrap
      let i = queue.first!.0
      let j = queue.first!.1
      if result[i][j] == oldColor {
        result[i][j] = newColor
        queue.removeFirst()
        //check neighbors cell

        //готовим массив соседних индексов
        var indices : [(Int, Int)] = []
        
        //проверяем существуют ли индексы
        if result.index(i, offsetBy: 1, limitedBy: m) != nil  {
          if !checkedCoordinates.contains(where: { (ii,jj) -> Bool in
            (ii,jj) == (i + 1, j)
          }) {
            checkedCoordinates.append((i + 1, j))
            indices.append((i + 1, j))
          }
          
          
          // indices.append((i + 1, j))
          
        }
        if result.index(i, offsetBy: -1, limitedBy: 0) != nil  {
          if !checkedCoordinates.contains(where: { (ii,jj) -> Bool in
            (ii,jj) == (i - 1, j)
          }) {
            checkedCoordinates.append((i - 1, j))
            indices.append((i - 1, j))
          }
          
          
         // indices.append((i - 1, j))
        }
        if result.index(j, offsetBy: 1, limitedBy: n) != nil  {
          if !checkedCoordinates.contains(where: { (ii,jj) -> Bool in
            (ii,jj) == (i , j + 1)
          }) {
            checkedCoordinates.append((i, j + 1))
            indices.append((i , j + 1))
          }

          //indices.append((i , j + 1))
        }
        if result.index(j, offsetBy: -1, limitedBy: 0) != nil  {
          if !checkedCoordinates.contains(where: { (ii,jj) -> Bool in
            (ii,jj) == (i, j - 1)
          }) {
            checkedCoordinates.append((i, j - 1))
            indices.append((i , j - 1))
          }
          
          
          //indices.append((i, j - 1))
        }
        
        indices.forEach {
          if result[$0.0][$0.1] == oldColor {
            queue.append(($0.0, $0.1))
          }
        }
      } else {
        queue.removeFirst()
      }
    }
    
    return result
    
  }
}
