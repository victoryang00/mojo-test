struct MyPair:
   var first: Int
   var second: Int

   fn __init__(inout self, first: Int, second: Int):
      self.first = first
      self.second = second

   fn dump(inout self):
      print(self.first, self.second)

fn main():
   var mine = MyPair(1, 2)
   mine.dump()
