# Physics
Physics-related modules written in Lua.

This is mostly a test for me to learn how to use Git with the Linux terminal. Documentation will be coming soon.

Objects created by the `new` functions are technically mutable: you have the ability to change the values yourself by referencing the fields directly. However, the modules will treat the objects as immutables: they will not affect the values after returning the object to you. For example, if you translated a point or added two vectors, the resulting point or vector will be an entirely new object.

Due to the nature of how Lua's `require` works, the modules cannot check the existence of other necessary modules until runtime. You could have only the `Vector` and `Common` modules installed and run Lua with both, but the program will error when it can't find the `Quantity` or `Units` modules. Because of this, it is important to install all module files (for safety), or follow the list below to see what modules are dependents.