# Go Workspace and Project Generator Script

This is a bash script that creates a new Go workspace and a new Go project within that workspace. The workspace and project are set up according to the Go community's suggested layout.

## Directory Structure

The script creates the following directory structure under a projects folder:

myapp
├── bin
├── pkg
├── src
│ └── github.com
│ └── yourusername
│ └── myapp
│ ├── cmd
│ │ ├── api
│ │ └── web
│ ├── scripts
│ ├── build
│ ├── deployments
│ ├── test
│ ├── internal
│ │ └── platform
│ ├── pkg
│ │ ├── api
│ │ └── db
│ └── vendor


Here's what each directory is for:

- `bin/`: This folder holds compiled output.
- `pkg/`: This folder holds installed package objects.
- `src/`: This folder holds Go source files.
- `src/github.com/yourusername/myapp`: This is your Go application directory.
- `cmd/api/` and `cmd/web/`: These directories contain your application's command-line interfaces.
- `scripts/`: This directory contains scripts related to your application, like build scripts and CI scripts.
- `build/`: This directory contains build output.
- `deployments/`: This directory contains deployment scripts or configuration files.
- `test/`: This directory contains test scripts, test data, or other testing-related code.
- `internal/`: This directory contains private application and library code.
- `internal/platform/`: This directory contains shared packages that are used in multiple places in your application but are not intended for use by others outside of your app.
- `pkg/`: This directory contains library code that's safe for others to use.
- `pkg/api/` and `pkg/db/`: These directories contain specific parts of your library code.
- `vendor/`: This directory contains application dependencies. It contains Go packages that have been vendored.


## Dependencies

The script requires `bash` and `tree`. It assumes you're using a Unix-like environment with these tools installed.

## Usage

1. Save the script to a file, e.g. `create-go-workspace.sh`.
2. Make the script executable with the command `chmod +x setup.sh`.
3. Run the script with `./create-go-workspace.sh`.
4. When prompted, enter your GitHub username and the name of the application.

The script will create the directory structure, set up the `GOPATH` environment variable, and update your `PATH`.

## Contributing

Contributions to this script are welcome. Please fork the repository and create a pull request with your changes.

## License

*Your project's license.*

