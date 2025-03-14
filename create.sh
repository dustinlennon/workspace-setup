#!/bin/bash

source ${BFL}/process_args
process_args project_name -- "$@" || exit $?

sandbox_name="Sandbox/${project_name}"
journal_name="Journal/$(printf "%(%Y-%m)T").${project_name}"
active_name="Active/${project_name}"

git_auth() {
	GH_TOKEN=$(gh auth token)
	err_code=$?
	if [ $err_code -ne 0 ]; then
		gh auth login \
			--git-protocol ssh \
			--skip-ssh-key \
			--hostname github.com \
			--web \
			--insecure-storage
		GH_TOKEN=$(gh auth token)
	fi

	export GH_TOKEN
}

git_create_remote_repo() {
	IFS='' read -r -d '' json <<-EOF
	{
	  'name': '${project_name}',
	  'description': '${project_name} project repository',
	  'homepage': 'https://github.com',
	  'private' : false,
	  'is_template' : true
	}
	EOF

	json=$(echo $json | sed -e "s#'#\"#g")

	tmpfile=$(mktemp)
	curl -L \
		--silent \
		-X POST \
		-H "Accept: application/vnd.github+json" \
		-H "Authorization: Bearer ${GH_TOKEN}" \
		-H "X-GitHub-Api-Version: 2022-11-28" \
		https://api.github.com/user/repos \
		-d "$json" > "$tmpfile"	

	status=$(jq ".status" $tmpfile)
	unlink $tmpfile

	>&2 echo "curl HTTP status code: ${status}"
}

git_create_local_repo() {
	if [ -d .git ]; then
		echo "assertion error: .git exists"
		exit 1
	fi

	echo "# ${project_name}" >> README.md
	git init
	git add README.md
	git commit -m "first commit"
	git branch -M main
	git remote add origin git@github.com:dustinlennon/${project_name}.git
	git push -u origin main
}

if [ ! -d "$sandbox_name" ]; then
    echo creating directory $sandbox_name
    mkdir $sandbox_name
	pushd $sandbox_name
	git_auth
	git_create_remote_repo
	git_create_local_repo
	popd
fi

symlinks=("$journal_name" "$active_name")
for link in ${symlinks[@]}; do
    if [ -h "$link" ]; then
        :
    elif [ -e "$link" ]; then
        echo "assertion error: ${link} exists and is not a symlink"
        exit 1
    else
        echo linking $link
        ln -s $HOME/Workspace/$sandbox_name $link
    fi
done
