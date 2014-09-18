# Install Vim config
ln -s $PWD/.vim ~
mkdir -p ~/.vim/bundle
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/vundle

# Install things that aren't Vim config
find . -type f -name .\* -maxdepth 1 | xargs -I {} ln -s $PWD/{} ~

# Install Leiningen config
mkdir -p ~/.lein && ln -s $PWD/profiles.clj ~/.lein
