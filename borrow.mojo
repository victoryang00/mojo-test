fn add(borrowed x: Int, borrowed y: Int) -> Int:
   return x + y

fn add_inout(inout x: Int, inout y: Int) -> Int:
   x += 1
   y += 1
   return x + y

fn main():
   let x = 1
   let y = 2
   let z = add(x, y)
   print("x = ", x)
   print("y = ", y)
   print("z = ", z)

   var a = 1
   var b = 2
   let c = add_inout(a, b)
   print("a = ", a)
   print("b = ", b)
   print("c = ", c)