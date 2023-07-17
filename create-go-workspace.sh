#!/bin/bash

# Create the workspace directory
mkdir -p $HOME/projects/go/{src,pkg,bin}

# Set the GOPATH environment variable to point to the workspace
export GOPATH=$HOME/projects/go

# Add the workspace's bin subdirectory to your PATH
export PATH=$PATH:$GOPATH/bin

# Ask for the user input
echo "Enter your GitHub username:"
read username
echo "Enter your application name:"
read appname

# Define the base directory
basedir="$GOPATH/src/github.com/$username/$appname"

# Create the directories
mkdir -p "$basedir"/{cmd/api,cmd/web,scripts,build,deployments,test,internal/platform,pkg/api,pkg/db,vendor}

# Print out the tree of your new project (this assumes the tree command is available)
echo "Successfully created directories:"
tree "$basedir"

