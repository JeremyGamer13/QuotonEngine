Plan:

1. Each Quoton release version comes with it's own engine version. When creating a project, you can use either the Bundled version, Latest version with updates (off GitHub), Latest Version without updates (basically it's never checked for updates) or a custom QuotonEngine (likely a fork) that is located on the computer.

    - Non-release versions wouldn't have a bundled engine and can only pull off GitHub or local computer path.
    - Likely the app can just have a `Versions/Engine` folder in AppData for all of the versions.
    - Each option will be handled as follows:
        - Bundled versions will not check for any updates, just clone the version to a temp directory when Quoton is opened and then open the project.
        - Latest Version will check GitHub for a new release, and download if there is one and it isn't already downloaded.
        - Latest Version without updates will only get the latest GitHub release upon project creation. Project settings will have a button to check for updates.
        - If a custom engine is chosen, just copy that folder to the temp directory.
    - QuotonEngine will have a `meta.json` file in the root dir to denote things the app should know about the engine version.
    - If the selected version's `meta.json` file has a different `appShouldHandleLike` number than the app does, then the app will warn that the engine is expecting itself to be ran differently than how the app does it.
    - The engine choice can be changed later, but it should give a warning that it can cause issues. Since Quoton just copies the engine folder to a temoporary directory, it should be easy to make the engine folder able to be changed later.

2. Quoton UI when loading projects, will clone the selected Quoton version to a temporary directory (likely within AppData Roaming) and empty out the scripts folder.
3. The `setup.lua` script in the original engine's scripts folder will be replaced by the one in the version under `src.patch.setup_ui.lua`.
4. When first creating a project, a `scripts` folder, `assets` folder, and `setup.lua` script will be added to the project folder. The `setup.lua` script will come from the specified version under `src.patch.setup_template.lua`.
4. On start-up & while editing the project, everything in the project folder will be cloned to `src.scripts._userspace` in the temporary directory. Only changed or new files will be re-cloned normally. Maybe have a setting where only on play the `src.scripts._userspace` folder is emptied and filled since it might be better for smaller projects.
5. On play + build, all .lua scripts within the userspace folder will have all of the Quoton services and modules imported at the top for use. Maybe if it somehow causes an issue it can be disabled for certain files via some project config.
6. Upon closing the editor, the `_userspace` directory can be destroyed. Maybe there can be a setting to keep it.