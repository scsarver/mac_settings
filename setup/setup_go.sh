#!/usr/bin/env bash
#
# Created By: Stephan Sarver
# Created Date: 2017.09.11.16.06.12
#

go_dir="/Users/$(whoami)/go"
declare -a go_workspace_dirs=(
  src
  pkg
  bin
)


if [[ -d "$go_dir" ]]; then
  echo "The workspace directory $go_dir exists, skipping."
else
  echo "Created the $go_dir."
  mkdir -p "$go_dir"
fi

for dir in "${go_workspace_dirs[@]}"
do
  if [[ -d "$go_dir/$dir" ]]; then
    echo "The workspace directory $go_dir/$dir exists, skipping."
  else
    echo "Created the $go_dir/$dir."
    mkdir -p "$go_dir/$dir"
  fi
done

echo "Be sure to set go on the PATH in your bash profile example:"
cat <<EOM
if [ ! "" == "$(which go)" ]; then
  export PATH=$PATH:$(go env GOPATH)/bin
  export GOPATH=$(go env GOPATH)
fi
EOM

echo "More go questions start here:  https://golang.org/doc/code.html"
