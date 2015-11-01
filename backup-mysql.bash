#!/bin/bash

## 
## @author Tag <tagadvance@gmail.com>
## @see https://github.com/tagadvance/scripts
##
## loosely based on script by Daniel Dvorkin
## http://danieldvork.in/script-for-mysql-backup-to-dropbox/
##

SOURCE_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONFIGURATION_FILE=backup.config
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
databases=`/usr/bin/mysql --user=$USER --password=$PASSWORD -e "SHOW DATABASES;" | tail -n +2 | grep -v _schema$ | grep -v ^mysql$ | grep -v ^test$`
for database in $databases; do
    echo "dumping database: $database"
    /usr/bin/mysqldump --user=$USER --password=$PASSWORD --databases $database | /usr/bin/gzip -9 > $DIRECTORY/$database.sql.gz
done

# http://docs.aws.amazon.com/cli/latest/userguide/using-s3-commands.html
/usr/bin/aws s3 sync $DIRECTORY/ s3://$BUCKET_PATH/