# Example script to generate AppStream catalogue metadata from the mirrors

REPODIR=$(dirname $0)/repo


RELEASE=41
BASENAME="terra-$RELEASE"

appstream-builder --verbose --include-failed --log-dir=./logs/ \
    --packages-dir=$REPODIR --temp-dir=./tmp/ --output-dir=./appstream-data/ \
    --basename="$BASENAME" --origin="$BASENAME" \
    --veto-ignore=missing-parents