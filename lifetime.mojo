#https://github.com/modularml/mojo/blob/7e667e951008ade31621dbd37217a562ae82472f/proposals/lifetimes-and-provenance.md
fn example[life: Lifetime](cond: Bool,
                           x: borrowed[life] String,
                           y: borrowed[life] String):
    # Late initialized local borrow with explicit lifetime
    borrowed[life] str_ref : String

    if cond:
        str_ref = x
    else:
      	str_ref = y
    print(str_ref)

fn example1(cond: Bool):
    var str1 = String("hello")
    var str2 = String("goodbye")

    # Defines an immutable reference with inferred lifetime.
    borrowed str_ref = str1 if cond else str2
    print(str_ref)

    # Defines a mutable reference.
    inout mut_ref = str1 if cond else str2
    mut_ref = "a new look"

    # One of these will have changed.
    print(str1)
    print(str2)

# Doesn't require a lifetime param because it owns its data.
struct Array[type: AnyType]:
    var ptr: MutablePointer[type, Self_lifetime]
    var size: Int
    var capacity: Int

    fn __getitem__[life: Lifetime](self: inout[life], start: Int,
                        stop: Int) -> MutableArraySlice[type, life]:
        return MutableArraySlice(ptr, size)


    @value
    @register_passable("trivial")
    struct MutableArraySlice[type: AnyType, life: Lifetime]:
        var ptr: MutablePointer[type, life]
        var size: Int

    	fn __init__() -> Self:
        fn __init__(ptr: MutablePointer[type, life], size: Int) -> Self:

        # All the normal slicing operations etc, with bounds checks.
        fn __getitem__(self, offset: Int) -> inout[life] type:
    	    assert(offset < size)
    	    return ptr[offset]

    @value
    @register_passable("trivial")
    struct MutablePointer[type: AnyType, life: Lifetime]:
        alias pointer_type = __mlir_type[...]
        var address: pointer_type

   	    fn __init__() -> Self: ...
        fn __init__(address: pointer_type) -> Self: ...

        # Should this be an __init__ to allow implicit conversions?
        @static_method
        fn address_of(inout[life] arg: type) -> Self:
            ...

        fn __getitem__(self, offset: Int) -> inout[life] type:
   	        ...

        @staticmethod
        fn alloc(count: Int) -> Self: ...
        fn free(self): ...

    fn exercise_pointer():
    	# Allocated untracked data with static/immortal lifetime.
    	let ptr = MutablePointer[Int, __static_lifetime].alloc(42)

    	# Use extended getitem through reference to support setter.
    	ptr[4] = 7

    	var localInt = 19
    	let ptr2 = MutablePointer.address_of(localInt)
    	ptr2[0] += 1  # increment localInt

        # ERROR: Cannot mutate localInt while ptr2 lifetime is live
        localInt += 1
    	use(ptr2)