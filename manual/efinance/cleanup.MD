# cleanup efinance

## remove empty Folder

```sh
find /home/efinance/documents/tmp -empty -type d |wc -l
find /home/efinance/documents/tmp -empty -type d -delete
```

## reduce image size

```sh
find /home/efinance/documents/prod/ -name "*.jpg" -print0 | xargs -0 jpegoptim -m 80
```
