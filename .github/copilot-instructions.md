# Copilot Instructions for RoundTime SourceMod Plugin

## Repository Overview

This repository contains a SourceMod plugin called **RoundTime** that allows instant modification of round time limits in Source engine games (primarily CS:GO/CS2). The plugin removes the default round time limit and enables dynamic round time changes during gameplay.

### Key Plugin Functionality
- Removes the upper bound limit on `mp_roundtime` ConVar (normally capped at ~9 minutes)
- Dynamically updates game rules when `mp_roundtime` is changed
- Lightweight implementation with minimal performance impact
- No configuration files, translations, or complex features required

## Technical Environment & Build System

### Core Technologies
- **Language**: SourcePawn (.sp files)
- **Platform**: SourceMod 1.11+ (targeting 1.11.0-git6917)
- **Build Tool**: SourceKnight (modern SourceMod build system)
- **Compiler**: SourceMod spcomp (managed by SourceKnight)

### Build System (SourceKnight)
- Configuration file: `sourceknight.yaml`
- Build command: Uses GitHub Actions with `maxime1907/action-sourceknight@v1`
- Output directory: `/addons/sourcemod/plugins` (produces `.smx` files)
- Dependencies automatically downloaded (SourceMod itself)

### CI/CD Pipeline
- Automated builds on push/PR via GitHub Actions (`.github/workflows/ci.yml`)
- Automatic releases with version tagging
- Artifacts packaged as `.tar.gz` files

## Project Structure

```
├── addons/sourcemod/scripting/
│   └── RoundTime.sp                 # Main plugin source code
├── sourceknight.yaml               # Build configuration
├── .github/
│   ├── workflows/ci.yml            # CI/CD pipeline
│   └── dependabot.yml             # Dependency updates
└── .gitignore                      # Git ignore rules
```

## Code Style & Standards

### SourcePawn Conventions (STRICTLY ENFORCE)
```sourcepawn
#pragma semicolon 1                 // REQUIRED: Enforce semicolons
#pragma newdecls required          // REQUIRED: Use new declaration syntax
```

### Naming Conventions
- **Global variables**: Prefix with `g_` (e.g., `g_CVar_mp_roundtime`)
- **Function names**: PascalCase (e.g., `OnPluginStart`, `OnConVarChanged`)
- **Local variables/parameters**: camelCase (e.g., `convar`, `oldValue`, `newValue`)
- **Constants**: UPPER_SNAKE_CASE

### Code Quality Standards
- **Indentation**: 4-space tabs (configure editor accordingly)
- **Line endings**: LF (Unix-style)
- **Trailing spaces**: Remove all trailing whitespace
- **Comments**: Only add when necessary for complex logic (this plugin is simple enough to be self-documenting)

## Plugin-Specific Implementation Guidelines

### Core Plugin Structure
```sourcepawn
public Plugin myinfo = {
    name = "PluginName",
    author = "AuthorName", 
    description = "Brief description",
    version = "MAJOR.MINOR.PATCH",  // Use semantic versioning
    url = ""                        // Optional
}

ConVar g_CVar_variableName;         // Global ConVar references

public void OnPluginStart() {
    // Plugin initialization
    // ConVar hooks, command registration, etc.
}

public void OnPluginEnd() {
    // Cleanup (only if necessary)
    // This plugin doesn't need cleanup
}
```

### ConVar Handling (Critical for this plugin)
- Use `FindConVar()` to get existing game ConVars
- Use `SetBounds()` to modify ConVar limits (as done with mp_roundtime)
- Use `AddChangeHook()` for real-time value monitoring
- Always use proper ConVar methodmap syntax

### Game Rules Modification
- Use `GameRules_SetProp()` for immediate game state changes
- Convert time values appropriately (seconds to minutes, etc.)
- Ensure changes take effect immediately during active rounds

## Memory Management & Performance

### Best Practices for this Plugin
- **ConVar References**: Store as global variables for efficiency
- **Event Hooks**: Minimize overhead in frequently called functions
- **String Operations**: Avoid unnecessary string manipulations
- **Memory Leaks**: Not applicable to this simple plugin (no dynamic allocations)

### Performance Considerations
- ConVar change hooks are called frequently - keep `OnConVarChanged` lightweight
- `StringToInt()` is acceptable for ConVar value conversion
- `GameRules_SetProp()` has minimal performance impact

## Testing & Validation

### Local Testing (if SourceKnight is available)
```bash
# Install SourceKnight (may require specific Python version)
pip install sourceknight

# Build the plugin
sourceknight build

# Check output in .sourceknight/package/
```

### GitHub Actions Testing
- All builds are automatically tested on Ubuntu 24.04
- Failed builds will prevent merges
- Artifacts are generated for manual testing

### Game Server Testing
1. Copy `.smx` file to `addons/sourcemod/plugins/`
2. Load plugin: `sm plugins load RoundTime`
3. Test ConVar changes: `mp_roundtime 15` (should allow values > 9)
4. Verify round time updates immediately in-game

## Common Modification Patterns

### Adding New ConVar Hooks
```sourcepawn
ConVar g_CVar_newvar;

public void OnPluginStart() {
    g_CVar_newvar = FindConVar("cvar_name");
    g_CVar_newvar.AddChangeHook(OnNewVarChanged);
}

public void OnNewVarChanged(ConVar convar, const char[] oldValue, const char[] newValue) {
    // Handle the change
}
```

### Extending Plugin Functionality
- Keep the core round time functionality intact
- Add new features as separate functions
- Maintain the lightweight nature of the plugin
- Follow the same naming and structure conventions

## Version Control & Releases

### Semantic Versioning
- **MAJOR**: Breaking changes (rare for this plugin)
- **MINOR**: New features (e.g., additional ConVar support)  
- **PATCH**: Bug fixes, optimizations

### Git Workflow
- Main branch: `master` or `main`
- Feature branches: Use descriptive names
- Commit messages: Clear, descriptive, focused changes
- Releases: Automated via GitHub Actions on tag pushes

## Debugging & Troubleshooting

### Common Issues
1. **ConVar not found**: Check game/SourceMod version compatibility
2. **Changes not applying**: Verify `GameRules_SetProp` property name
3. **Build failures**: Check SourcePawn syntax and includes

### Debug Techniques
- Use `PrintToServer()` for debugging (remove before production)
- Check SourceMod error logs in `logs/errors_*.log`
- Verify ConVar exists with `sm_cvar` command

## Plugin-Specific Notes

### RoundTime Plugin Specifics
- **Primary ConVar**: `mp_roundtime` (game's round time in minutes)
- **Game Property**: `m_iRoundTime` (internal game rule in seconds)
- **Conversion**: Minutes to seconds (multiply by 60)
- **Empirical Limit**: 546.0 minutes (tested maximum value)

### Modification Guidelines
- Do NOT change the core ConVar hook logic without extensive testing
- Be careful with the empirical limit (546.0) - it's based on game engine limits
- Maintain immediate application of changes (don't defer to next round)
- Keep the plugin lightweight - avoid adding unnecessary features

This plugin serves as an excellent example of minimal, focused SourceMod development. When making changes, prioritize maintaining its simplicity and reliability.