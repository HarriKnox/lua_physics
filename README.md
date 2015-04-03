# Physics
Physics-related modules written in Lua. This is mostly a test for me to learn how to use Git with the Linux terminal. Documentation will be coming soon.

Objects created by the `new` functions are technically mutable: you have the ability to change the values yourself by referencing the fields directly; however, the modules will treat the objects as immutables: they will not affect the values after returning the object to you. For example, if you translated a point or added two vectors, the resulting point or vector will be a new object.
