
font_create_update(){
    local MYFONTS="$HOME/.fonts/fonts"
    local CURRENTDIR=`pwd`

    # Get/Update MyFonts
    if [ -d $MYFONTS ]; then
        cd $MYFONTS
        git pull
    else
        git clone git@github.com:chadit/fonts.git $MYFONTS
    fi

    fc-cache -f -v $HOME/.fonts
    cd $CURRENTDIR 
}

