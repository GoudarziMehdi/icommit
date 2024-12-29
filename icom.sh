
# # 1. Clone a Git repository from GitHub
# git_repo=$1
# clone_dir=$2
# backer="/_the_master"

# git clone "$git_repo" "$clone_dir$backer"
# cd "$clone_dir$backer" || exit 1

# # counter=1
# # for commit in $(git rev-list --all); do
# #     a=$(git log --format=%s -n 1 "$commit" | tr ' ' '_' | tr -cd '[:alnum:]_')
# #     branch_counter=1
# #     new_branch_name="${counter}_${a}"
# #     while git rev-parse --verify $new_branch_name >/dev/null 2>&1; do
# #         new_branch_name="${counter}_${a}_${branch_counter}"
# #         branch_counter=$((branch_counter + 1))
# #     done
# #     git checkout -b $new_branch_name $commit
# #     counter=$((counter + 1))
# # done

# counter=$(git rev-list --all | wc -l)
# for commit in $(git rev-list --all); do
#     a=$(git log --format=%s -n 1 "$commit" | tr ' ' '_' | tr -cd '[:alnum:]_')
#     branch_counter=1
#     new_branch_name="${counter}_${a}"
#     while git rev-parse --verify $new_branch_name >/dev/null 2>&1; do
#         new_branch_name="${counter}_${a}_${branch_counter}"
#         branch_counter=$((branch_counter + 1))
#     done
#     git checkout -b $new_branch_name $commit
#     counter=$((counter - 1))
# done

# # 4. Copy the contents of each branch into a directory with the same name as the branch
# for branch in $(git for-each-ref --format='%(refname:short)' refs/heads/); do
#     echo $branch >> commitenames.txt
#     git checkout $branch
#     mkdir ../$branch
#     cp -r . ../$branch/
# done


#!/bin/bash

# Arguments:
# $1: Git repository URL
# $2: Clone directory path

git_repo=$1
clone_dir=$2
backer="/_the_master"

# Clone the repository
git clone "$git_repo" "$clone_dir$backer"
cd "$clone_dir$backer" || exit 1

# Get total number of commits
total_commits=$(git rev-list --count --all)
counter=$total_commits

# Loop through each commit
for commit in $(git rev-list --all); do
    # Sanitize commit message for directory name
    a=$(git log --format=%s -n 1 "$commit" | tr ' ' '_' | tr -cd '[:alnum:]_')
    branch_counter=1
    new_branch_name="${counter}_${a}"
    
    # Handle naming conflicts
    while [ -d "../$new_branch_name" ]; do
        new_branch_name="${counter}_${a}_${branch_counter}"
        branch_counter=$((branch_counter + 1))
    done
    
    # Export commit contents using git archive
    git archive --format=tar --prefix="$new_branch_name/" $commit | tar -x -C ..
    
    # Decrement counter
    counter=$((counter - 1))
done