define = True

class C:
    print("hello") # prints 'hello'
    if define:
        def f(self): print(10)
    else:
        def f(self): print(20)


C().f() # prints '10'

@dynamic
class C:
    def foo(): print("warming up")
    foo() # prints 'warming up'
    del foo
    def foo(): print("huzzah")
    foo() # prints 'huzzah'
