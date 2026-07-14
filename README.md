# PSToolbox

**PSToolbox** is a collection of reusable PowerShell utilities for Windows development and system administration. It provides small, focused commands for common tasks such as file system operations, environment management, package installation, and developer workflow automation.

The module is designed to follow PowerShell best practices, support the pipeline where appropriate, and provide a consistent command-line experience.

## Features

* File and directory utilities.
* PATH environment variable management.
* Package installation helpers.
* Symbolic link creation.
* Developer productivity commands.
* Pipeline-friendly cmdlets.
* Supports `-WhatIf` and `-Confirm` where applicable.

## Usage

List all available commands:

```powershell
Get-Command -Module PSToolbox
```

Get help for a command:

```powershell
Get-Help <Command-Name> -Full
```

## Testing

The test suite is written using Pester 5. Ensure Pester 5.0 or later is installed before running the tests.

Install or update Pester:

```powershell
Install-Module Pester -Scope CurrentUser -MinimumVersion 5.0 -Force
```

Run the test suite from the project root:

```powershell
Invoke-Pester
```

## Project Structure

```
PSToolbox/
├── Public/          # Exported cmdlets
├── Private/         # Internal helper functions
├── PSToolbox.psm1   # Module entry point
├── PSToolbox.psd1   # Module manifest
└── README.md
```

Functions inside the `Private` directory are dot-sourced for internal use, while functions in the `Public` directory are exported automatically by the module.

## Requirements

* PowerShell 5.1+ (recommended)
* Windows

Some commands may require administrator privileges depending on the operation being performed.

## Contributing

Contributions are welcome. Feel free to open an issue to report bugs, request features, or discuss improvements before submitting a pull request.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.
