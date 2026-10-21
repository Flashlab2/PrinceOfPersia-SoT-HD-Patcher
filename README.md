# Prince of Persia: The Sands of Time — HD Cutscenes EXE Patcher

This repository contains the **complete, human-readable source** for the Windows PowerShell patcher distributed with the HD Cutscenes mod. It does **not** contain Ubisoft's game executable or cutscene assets.

## Source files

- `Patch_HD_Video.ps1` — complete patch implementation (PowerShell).
- `Patch_HD_Video.bat` — Windows launcher for the PowerShell script.
- `Restore_POP_EXE.bat` — restores the backed-up game executable.

There is **no compiled application, build step, third-party dependency, package manager, or binary to reproduce**. The distributed patcher consists of these same text files. The launcher invokes the source script directly using Windows PowerShell.

## Reproducing the distributed patcher

1. Download or clone this repository (Git is optional; downloading the source ZIP also works).
2. On Windows, ensure Windows PowerShell 5.1 is available (`powershell.exe`).
3. Use the three unmodified script files from this repository as the patcher distribution. No compilation is necessary.
4. To run it, place `Patch_HD_Video.ps1` and `Patch_HD_Video.bat` in the game folder next to a compatible, legitimately obtained `POP.EXE`, then double-click `Patch_HD_Video.bat`.
5. To restore the executable, keep `Restore_POP_EXE.bat` in that same folder and run it after the patch has created `POP.EXE.bak`.

The `.bat` launcher executes:

```bat
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Patch_HD_Video.ps1"
```

`-ExecutionPolicy Bypass` applies to this launched PowerShell process; it is not a permanent system policy change.

## Exact modifications

Only the verified original executable is accepted. The patcher checks its SHA-256, validates the original bytes at each offset, creates a backup, modifies the bytes, and verifies the resulting SHA-256.

| File offset (hex) | Original bytes | Replacement bytes | Purpose |
| --- | --- | --- | --- |
| `0x00000156` | `0F` | `2F` | Set PE `IMAGE_FILE_LARGE_ADDRESS_AWARE` flag |
| `0x00274D45` | `2B C6` | `31 C0` | Tested HD-video compatibility change |

Original `POP.EXE` SHA-256:

`6587D499F4EA6D0895179F74487045BC2C82A9D4E08A0A5046C1FB88EE3B6EC9`

Patched `POP.EXE` SHA-256:

`A47848788CCC234DC65683B02D4277462854377684430A89CFB639DCF4E0635C`

The script refuses unknown executables and reports if the target is already patched. The backup is saved as `POP.EXE.bak`; an existing backup is preserved.

## Installation and rollback

1. Back up your game directory and original `Video` directory.
2. Put `Patch_HD_Video.ps1`, `Patch_HD_Video.bat`, and `Restore_POP_EXE.bat` next to `POP.EXE`.
3. Run `Patch_HD_Video.bat` and confirm it reports success.
4. Install the mod's HD `.int` cutscene files in the game's `Video` directory as instructed by the mod distribution. Those files are **not** part of this source repository.
5. To undo the executable patch, run `Restore_POP_EXE.bat`. Restore original video files separately.

## Security review notes

- The source is provided in full, without obfuscation.
- No network calls, downloads, telemetry, or persistence mechanisms are implemented.
- The script reads and writes the local `POP.EXE` only after a strict hash check; it creates a local backup.
- The restore script copies the local `POP.EXE.bak` over `POP.EXE`.
- No original game executable is distributed here.

This repository documents the existing v1.0 patcher; the script files have not been changed from the submitted archive.
