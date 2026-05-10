# STANDARD PRACTICE
This document outlines how you should use QuotonEngine to keep best compatibility with future versions of the project.

## Engine Behaviour
1. Don't use private functions, properties, or just anything from the engine that starts with `_`.

    Quoton internally uses a lot of these to provide all of the APIs and features it currently has. These can act differently depending on which version of Quoton you are using, or which platform you are trying to deploy to. Using these properties directly is unsupported and future updates **will** break your project.

2. Don't import `raylib` or `raylua`.

    Use RenderingService, RuntimeService, or anything else really. The way Quoton runs games technically allows for this, but it's not supported. Quoton's services are meant to wrap around RayLib incase we have any reason to use something else, or a certain platform doesn't support RayLib-Lua well.

3. Don't delete `setup.lua`.

    Quoton will import `setup.lua` in its main scripts for getting your game's configurations. If you are able to run a project without this file, it is a bug and future updates **will** break your project.

4. Don't import anything outside of your project folder.

    In code editors these imports may work fine, but they **will** break when running your Quoton project. All imports become relative to a different directory when Quoton runs or builds your project, so you must keep things in your project folder.