# backup


## Installation Instructions:
Run as *root*:
```bash
# install AWS CLI
pip install awscli
aws configure
# clone git repository
mkdir ~/git; cd ~/git
git clone https://github.com/tagadvance/backup.git
# configuration
cd backup
cp backup.config.example backup.config
# edit backup.config, e.g.
nano -w backup.config
# configure cron job
crontab -e
# append to the crontab:
@daily /root/git/backup/backup-database.bash
```