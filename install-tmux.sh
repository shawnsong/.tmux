# check number of arguments
if [ $# != 1 ]; then
    echo "error: Wrong number of arguments. Only version number should be provided."
    echo "Script stopped..."
    exit
fi

TMUX_VER=$1
VER_REGEX='^[0-9]+([.][0-9]+)?$'
if ! [[ $TMUX_VER =~ $VER_REGEX ]] ; then
    echo "error: please provide a valid version number (character is not accepted)." >&2; exit 1
fi

echo "tmux v$TMUX_VER is going to be installed..."
#: <<'END'  # this is used to comment out below code to debug above logic"

# install deps
yum install gcc kernel-devel make ncurses-devel

# DOWNLOAD SOURCES FOR LIBEVENT AND MAKE AND INSTALL
wget https://github.com/downloads/libevent/libevent/libevent-2.0.21-stable.tar.gz
tar -xvzf libevent-2.0.21-stable.tar.gz
cd libevent-2.0.21-stable
./configure --prefix=/usr/local
make
sudo make install

# DOWNLOAD SOURCES FOR TMUX AND MAKE AND INSTALL
wget https://github.com/tmux/tmux/releases/download/2.6/tmux-2.6.tar.gz
tar -xvzf tmux-2.6.tar.gz
cd tmux-2.6
LDFLAGS="-L/usr/local/lib -Wl,-rpath=/usr/local/lib" ./configure --prefix=/usr/local
make
sudo make install

# pkill tmux
# close your terminal window (flushes cached tmux executable)
# open new shell and check tmux version
tmux -V

#END
