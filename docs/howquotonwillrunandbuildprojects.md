Plan:

1. Each Quoton release version comes with it's own engine version. When creating a project, you can use either the Bundled version, Latest version (off GitHub), or a custom QuotonEngine (likely a fork) that is located on the computer.
2. Quoton UI when creating projects, will clone the selected Quoton version to `.quoton/engine` within the project folder and remove any unnecessary files from it.

    - Non-release versions wouldn't have a bundled engine and can only pull off GitHub or local computer path.
    - Likely the app can just have a `Versions/Engine` folder in AppData for all of the versions.
    - Each option will be handled as follows:
        - Bundled versions will just clone the version to `.quoton/engine` directory when the project is opened.
        - Latest Version will check GitHub for a new release, and download if there is one and it isn't already downloaded.
        - If a custom engine is chosen, just copy that folder to the `.quoton/engine` directory.
    - QuotonEngine will have a `meta.json` file in the root dir to denote things the app should know about the engine version.
    - If the selected version's `meta.json` file has a different `schema` value than the app does, then the app will warn that the engine is expecting itself to be ran differently than how the app does it.
    - The unnecessary files of the engine will be denoted in `meta.json` as `download-ignore`.
    - The engine choice can be changed later, but it should give a warning that it can cause issues. Since Quoton just copies the engine folder to `.quoton/engine`, it should be easy to make the engine folder able to be changed later.

3. When first creating a project, the project folder will be based on `defaults/project-folder`. `defaults/default-map.json` is used to remap defaults to their expected names. A blank path is used to delete the file for the user.
4. A `.quoton/userspace` folder is made/cleared upon loading any project. It is intended for playing projects. The `.quoton/engine` folder will be cloned to this folder on project load, however the difference is that it will be added along with any extra files needed for the current Lua library settings. For example, `raylib-tsnake41` requires `raylua` exe files to run. This folder is also regenerated upon switching environments.
5. In play mode, the engine will resolve all imports and directory paths to the project folder. Any paths that resolve to the specific `.quoton` directory found in the project folder should be denied. Folders named `.quoton` are allowed to be used on runtime, just specifically not the one in the project folder during play mode.
6. Upon closing the editor, the `.quoton/userspace` directory can be destroyed.