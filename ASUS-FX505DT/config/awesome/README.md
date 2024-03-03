# Installation
> To reduce the size of my dotfiles, instead of including the applied themeing directly to the repository i have opted to just provide download instructions.

### First:

```
git clone --recurse-submodules --remote-submodules --depth 1 -j 2 https://github.com/lcpz/awesome-copycats.git

```
### Then:
```
mv -bv awesome-copycats/{*,.[^.]*} ~/.config/awesome; rm -rf awesome-copycats

```

### OR 
#### In case you do not want the Git files, use the following as the second command:

```
mv -bv awesome-copycats/* ~/.config/awesome; rm -rf awesome-copycats
```
