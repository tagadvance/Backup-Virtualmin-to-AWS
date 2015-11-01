#!/bin/bash

##
## @author Tag <tagadvance@gmail.com>
## @see https://github.com/tagadvance/scripts
##
## @deprecated use Virtualmin > Backup and Restore > Scheduled Backups instead
##

SOURCE_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONFIGURATION_FILE=backup-domains.config
CONFIG="$SOURCE_DIRECTORY/$CONFIGURATION_FILE"

if [ ! -f $CONFIG ]; then
    echo "$CONFIGURATION_FILE could not be read" >&2
    exit 1
fi
source $CONFIG

# http://redsymbol.net/articles/bash-exit-traps/
function collect_garbage {
    /bin/rm --recursive --force $DIRECTORY
}
trap collect_garbage EXIT

/bin/mkdir -p $DIRECTORY
/usr/sbin/virtualmin backup-domain --dest $DIRECTORY/ --all-domains --all-features --except-feature mysql --newformat --all-virtualmin --ignore-errors
/usr/bin/aws s3 sync $DIRECTORY/ s3://$BUCKET_PATH/