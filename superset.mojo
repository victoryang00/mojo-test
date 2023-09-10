from python import Python

fn main():
   try:
      let np = Python.import_module("numpy")
      print(np.array([1, 2, 3]))
      print("Yes, it's fun!")
   except:
      print("No numpy")
