#!/bin/sh

# This script clones all my Github repositories in a subfolder "Workspace".
# The only dependency is the git client.


# Check folder:

if [ -d "Workspace" ]; then
    echo The Workspace folder already exists. Delete it before running this script.
    exit 1
else
    mkdir Workspace
    cd Workspace
fi


# Clone a single repository (parameters are: repo, branch, branch...)
# and increase the number of repos/branches:

total_repos=0
total_branches=0

clone() {
    repo=$1
    branches=${@:2}

    for branch in $branches; do
        total_branches=$((total_branches + 1))
        echo -e "\e[1m$total_branches - $repo ($branch)...\e[0m"
        /usr/bin/git clone -b $branch https://github.com/Beluki/$repo.git "$repo ($branch)"
        echo
    done

    total_repos=$((total_repos + 1))
}


# Use the function above to clone all the repository branches now:

clone 4k master
clone 4k-Example master
clone 4kGL master
clone 4kGL-Example master
clone 404 master
clone beluki.github.io master source
clone dir master
clone EmbedDIBits master
clone Frozen-Blog master gh-pages
clone GaGa master
clone HexPaste master
clone License master
clone LowKey master
clone MetaFiles master
clone mINI master
clone Misc master
clone MovieWar master
clone MovieWarDBGen master
clone MQLite master
clone MultiHash master
clone Tileboard master
clone Yava master


# Print statistics:

echo -e "\e[1mRepositories: $total_repos\e[0m"
echo -e "\e[1mBranches: $total_branches\e[0m"

