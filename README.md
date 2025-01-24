# Rclone Config Wizard
Rclone Config Wizard simplifies mounting cloud storage as drives on Windows. It can install Rclone and WinFsp, generate mount commands in `.bat` and `.vbs`, place shortcuts in Start Menu's App List, and even enable automatic mounting on startup.

RCW makes it easy for people to reap the benefits of Rclone without spending time learning what it is all about. That makes it suitable for tech-dummies, while also being a useful tool if these features are all you need out of Rclone.

## Features
- CMD based User Interface.
- Mounting and Unmounting Shortcuts in Start Menu.
- Optional automatic Mounting on Startup.

## Get Started
- Open PowerShell, copy-paste the code below, and press Enter:
```
irm https://naeembolchhi.github.io/rclone-wizard/wiz.ps1 | iex
```
- It creates and stores all its files in `C:\ProgramData\TmFlZW1Cb2xjaGhp`. Drive letter may be different depending on where your Windows is installed.

## License
This project is licensed under the [GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.en.html).