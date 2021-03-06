# Add python3 & pip3 as default python & pip
if ! grep -q "alias python='python3'" ~/.bashrc; then
  echo "alias python='python3'" >> ~/.bashrc
fi
if ! grep -q "alias pip='pip3'" ~/.bashrc; then
  echo "alias pip='pip3'" >> ~/.bashrc
fi

# Install syntax checker and code-completion for vim
plugin_autocomplete="Plug 'davidhalter/jedi-vim'"
pip3 install flake8
if ! grep -q "$plugin_autocomplete" ~/.vimrc; then
  sed -i "s|call plug#end()|$plugin_autocomplete\ncall plug#end()|g" ~/.vimrc || exit
fi
vim +'PlugInstall --sync' +qa

# Reset shell session
bash
