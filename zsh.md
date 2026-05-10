# How to install zsh + Powerlevel10k

## install zsh
```
sudo apt install zsh -y
```

## make zsh your defaulst shell
```
chsh -s /usr/bin/zsh
```

## verify zsh is your default shell
```
getent passwd <youruser>
```

## you should see something like: <youruser>:x:0:0:<youruser>:/<youruser>:/usr/bin/zsh

## install framework for zsh
```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## clone git
```
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
```

# install fonts adn dconf
```
apt-get install fonts-powerline -y
apt-get install dconf-cli -y
```
## edit zshrc
```
nano ~/.zshrc
```

```
Find a line which says ZSH_THEME="<theme_name>" and replace it with ZSH_THEME="powerlevel10k/powerlevel10k"
Find a line which says plugins=(git) and replace it with plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search)
```

## reload zsh
```
source ~/.zshrc
```

## configure powerlevel10K
```
p10k configure
```