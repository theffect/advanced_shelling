

Installation:

```bash
cd advanced_shelling/
sudo make install
```

Add the following to you ~/.bashrc file for loading 'advanced_shelling' on every login shell.
```bash
if [ -f /usr/sbin/advanced_shelling/load.sh ]; then
        source /usr/sbin/advanced_shelling/load.sh
fi
```

edit the file /etc/advanced_shelling/config.inc
change BASE_ITEM=base to your filename requirements

for example, the use of BASE_ITME=.base will hide every base file.

Use 'mode_make' for automatically creating a 'base' file in the current directory.

A complete example for below.

Example Use:

```bash
devops@localhost:~$ source /usr/sbin/advanced_shelling/load.sh 
devops@localhost:~$ cd workspace/
devops@localhost:~/workspace$ mkdir project
devops@localhost:~/workspace$ cd project/
devops@localhost:~/workspace/project$ mode_make 
Adding /home/devops/workspace/project/sbin to PATH
Adding /home/devops/workspace/project/bin to PATH
devops@localhost:/project$ ls -l
total 4
-rw-r--r-- 1 devops devops 78 Feb  6 09:38 base
devops@localhost:/project$ mkdir try0
devops@localhost:/project$ cd try0/
devops@localhost:/project/try0$ git init
Initialized empty Git repository in /home/devops/workspace/project/try0/.git/
devops@localhost:/project/try0--$ touch README
devops@localhost:/project/try0--M$ git add README 
devops@localhost:/project/try0--M$ git commit -m "adding README"
[master (root-commit) ad7ce35] adding README
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 README
devops@localhost:/project/try0--$ git remote add origin http://repos.server.org/try0
devops@localhost:/project/try0-try0-$ echo "change" >> README 
devops@localhost:/project/try0-try0-M$ git add README 
devops@localhost:/project/try0-try0-M$ git commit -m "update"
[master 134c727] update
 1 file changed, 1 insertion(+)
devops@localhost:/project/try0-try0-$ cd ..
devops@localhost:/project$ cd ..
Restoring prompt
Removing paths
devops@localhost:~/workspace$
```


Trying before installation:

Modify the load.sh, config.inc, installation.inc for the correct path of you current directory for 'advanced_shelling'.
Running 'source load.sh' will load advanced shelling goodies and you are ready to go.

