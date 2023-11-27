# VSC-GIT-WSL

## Git - WSL - Visual Studio Code - fix for 'unable to write new index file'

Error in external git client (for example SourceTree, GitKraken):

```sh
Rename from 'C:/path/to/repository/.git/index.lock' to 'C:/path/to/repository/.git/index' failed. 
fatal: unable to write new index file
```

OS: Windows
Project opened in Visual Studio Code
Remote connection type: WSL
Visual Studio Code Extension: Remote - WSL
Here is the fix:

F1>”Open Remote Settings (WSL: Ubuntu) and add the following lines to your settings.json.

```sh
"remote.WSL.fileWatcher.polling": true,
"files.watcherExclude": {
    "**/.git/**": true
}
```

Ref.
[Git-WSL-Visual_Studio_Code-fixforunabletowritenewindexfile][unindexwsl]
[mounts3toec2][s3mountec2]
[unindexwsl]: <https://www.codeer.dev/blog/2020/05/20/vsc-git-wsl-index-error.html/>
[s3mountec2]: <https://linuxbeast.com/tutorials/aws/install-s3fs-and-mount-s3-bucket-on-ubuntu-18-04/>