#sh

export JWPLAYER_SRC_TAG=v7.2.0
export AIRSDK_ARCHIVE=AIRSDK_Compiler.tbz2
export AIRSDK_URL=http://airdownload.adobe.com/air/mac/download/latest/$AIRSDK_ARCHIVE
export AIRSDK_DIR=AIRSDK
export AIR_HOME=../$AIRSDK_DIR

export SWC_DIR=$AIRSDK_DIR/frameworks/libs/player/11.2
export SRC_REPO=https://github.com/jwplayer/jwplayer

export BIN_REPO=https://github.com/peterzen/jwplayer-release

if [ ! -f $AIRSDK_ARCHIVE ]; then
	wget $AIRSDK_URL
fi

if [ ! -d $AIRSDK_DIR ]; then
	mkdir $AIRSDK_DIR
	cd $AIRSDK_DIR
	tar xjf ../$AIRSDK_ARCHIVE
	cd ..

	rm -rf $SWC_DIR
	mkdir $SWC_DIR
	cp playerglobal11_2.swc $SWC_DIR/playerglobal.swc

fi


if [ ! -d jwplayer ]; then
	git clone $SRC_REPO;
fi

cd jwplayer

git checkout $JWPLAYER_SRC_TAG

npm install

grunt build:release

cp bower.json bin-release

cd ..

git clone $BIN_REPO
cp -rv jwplayer/bin-release/* jwplayer-release
cd jwplayer-release
find . -name \*.map | xargs rm -f
grep -sIrl sourceMappingURL . | xargs perl -pi -e 's/sourceMappingURL.*$//'


