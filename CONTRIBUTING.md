# CONTRIBUTING
Contributing to QuotonEngine isn't recommended in it's current state. There's *some* explanations of *some* code but if you're willing to work on it anyway then at least keep this style:

1. Avoid requiring users to refactor large amounts of their scripts. If you want to just remake a whole terrible part of the engine then this might be forgivable.
2. Define regular, public functions with `function` at the start, not making something equal a function.
3. Use Pascal case for public functions and properties. Anything else is fine for private use, but start them with an `_` if not local and keep it readable to edit later.
4. Avoid importing a bunch of Lua modules from other sources. RayLib should suffice, and what you are adding is probably too niche to put into the core engine if it doesn't. 
    - Exceptions for things I think should be core eventually:
      - Web requests
      - Better file system handler

5. When creating general utility modules like `libset`, you should probably give them a lower-case name to match Lua's default libraries.
    - Fun fact: `libset` stands for Library Set. It's a standard set of functions that I wish were in the Lua libraries.