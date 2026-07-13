# dotfiles

Personal development environment configuration for **Windows + Git Bash + VS Code**, geared toward Salesforce Commerce Cloud (SFCC) work.

Anything machine- or project-specific (paths, names) lives in a local file that
is **not versioned** (`git-bash/env.local`), so the repository stays generic and
reusable.

## Contents

```
.
├── install.sh                          # Install/link the configuration
├── uninstall.sh                        # Revert the changes
├── git-bash/
│   ├── .bashrc                         # Loader: prompt + local config + aliases
│   ├── git-prompt.sh                   # Custom prompt (Nerd Fonts)
│   └── env.example                     # Local configuration template
└── vscode/
    ├── settings.json                   # VS Code user settings
    ├── snippets/
    │   └── sfcc.code-snippets          # Generic SFCC snippets
    └── workspaces/
        └── sfcc.code-workspace.template # Workspace template (generated on install)
```

## Requirements

- **Git Bash** (Git for Windows).
- **VS Code**.
- A **[Nerd Font](https://www.nerdfonts.com/)** for the prompt (e.g. *JetBrainsMono NF*).
  If you don't use Nerd Fonts, export `USE_NERD_FONTS=false` before loading the prompt for ASCII icons.

## Installation

```bash
git clone https://github.com/salva-sm/dotfiles.git
cd dotfiles
bash install.sh
```

The script:

1. Creates `git-bash/env.local` from `env.example` (if missing).
2. Creates a `~/.bashrc` that loads this repo's configuration.
3. Generates `vscode/workspaces/sfcc.code-workspace` from the template using your variables.
4. Symlinks `vscode/settings.json` and `vscode/snippets/` into your VS Code user folder.

Restart Git Bash when it finishes.

> ⚠️ **Warning:** `install.sh` overwrites your `~/.bashrc` and VS Code `settings.json`
> without creating a backup. Back them up manually if you have existing config to keep.

## Local configuration

Machine-specific values live in **`git-bash/env.local`** (gitignored). Edit it
after the first install:

```bash
# Label VS Code shows for the project folder
export SFCC_PROJECT_NAME="📦 My SFCC Project"

# Path to your project, RELATIVE to vscode/workspaces/
# e.g. project at ~/Github/my-project  ->  ../../../my-project
export SFCC_PROJECT_DIR="../../../my-project"
```

> A `.code-workspace` JSON **cannot** read environment variables in its folder
> `path`, which is why the workspace is **generated** from the template.
> Whenever you change `env.local`, run `bash install.sh` again to regenerate it.

Once generated, the `sfcc` alias (defined in `.bashrc`) opens the workspace:

```bash
sfcc
```

## Uninstallation

```bash
bash uninstall.sh
```

Removes the generated `~/.bashrc`, the VS Code symlinks and the generated
workspace. Your `env.local` is kept.

## Notes

- The SFCC snippets are generic and reusable in any SFRA project.
- `git-prompt.sh` renders a two-line prompt (date/time, user@host, path, branch).
