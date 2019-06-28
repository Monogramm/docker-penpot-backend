#!/bin/bash
set -eo pipefail

declare -A compose=(
	[8-jre]='debian'
	[8-jre-slim]='debian'
	[13-alpine]='alpine'
)

declare -A base=(
	[8-jre]='debian'
	[8-jre-slim]='debian'
	[13-alpine]='alpine'
)

# Only debian for now, later also 13-alpine
variants=(
	8-jre
	8-jre-slim
)

min_version='0.1'


# version_greater_or_equal A B returns whether A >= B
function version_greater_or_equal() {
	[[ "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1" || "$1" == "$2" ]];
}

dockerRepo="monogramm/docker-uxbox-backend"
# Retrieve automatically the latest versions (when release available)
#latests=( $( curl -fsSL 'https://api.github.com/repos/uxbox/uxbox/tags' |tac|tac| \
#	grep -oE '[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+' | \
#	sort -urV ) )

latests=(
	master
)

# Remove existing images
echo "reset docker images"
rm -rf ./images/
mkdir ./images/

echo "update docker images"
travisEnv=
for latest in "${latests[@]}"; do
	version=$(echo "$latest" | cut -d. -f1-2)

	if [ -d "$version" ]; then
		continue
	fi

	# Only add versions >= "$min_version"
	if version_greater_or_equal "$version" "$min_version"; then

		for variant in "${variants[@]}"; do
			echo "updating $latest [$version-$variant]"

			# Create the version directory with a Dockerfile.
			dir="images/$version/$variant"
			mkdir -p "$dir"

			template="Dockerfile-${base[$variant]}.template"
			cp "$template" "$dir/Dockerfile"

			# Replace the variables.
			sed -ri -e '
				s/%%VARIANT%%/'"$variant"'/g;
				s/%%VERSION%%/'"$latest"'/g;
			' "$dir/Dockerfile"

			cp ".dockerignore" "$dir/.dockerignore"
			cp "docker-entrypoint.sh" "$dir/entrypoint.sh"
			cp "docker-compose_${compose[$variant]}.yml" "$dir/docker-compose.yml"

			travisEnv='\n    - VERSION='"$version"' VARIANT='"$variant$travisEnv"

			if [[ $1 == 'build' ]]; then
				tag="$version-$variant"
				echo "Build Dockerfile for ${tag}"
				docker build -t ${dockerRepo}:${tag} $dir
			fi
		done
	fi

done

# update .travis.yml
travis="$(awk -v 'RS=\n\n' '$1 == "env:" && $2 == "#" && $3 == "Environments" { $0 = "env: # Environments'"$travisEnv"'" } { printf "%s%s", $0, RS }' .travis.yml)"
echo "$travis" > .travis.yml
