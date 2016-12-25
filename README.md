# backup


## Installation Instructions:
Run as *root*:
```bash
# install AWS CLI
pip install awscli
aws configure
# clone git repository
mkdir ~/git; cd ~/git
git clone https://github.com/tagadvance/Backup-Virtualmin-to-AWS.git
# configuration
cd backup
cp backup-database.config.example backup-database.config
# edit backup-database.config, e.g.
nano -w backup-database.config
# configure cron job
crontab -e
# append to the crontab:
@daily /root/git/backup/backup-database.bash
```
