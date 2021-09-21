using GNU Stow to manage config files a la http://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html

# Usage
```bash
git clone --recursive https://github.com/LabNeuroCogDevel/dotfiles.git
cd dotfiles
rm ~/.bashrc; for p in vim Xdefaults Rprofile bash; do stow $p -t ~; done; vim -c BundleInstall
# permissions and ownership issues on ssh if dotfiles git is multiuser
cp -r ssh/.ssh ~/

```
