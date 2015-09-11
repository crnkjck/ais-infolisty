#!/bin/bash
READLINK_CMD=readlink
DATE_CMD=date
if [ "$(uname)" = "Darwin" ]; then
    if which greadlink > /dev/null && which gdate  > /dev/null; then
        READLINK_CMD=greadlink
        DATE_CMD=gdate
    else
        echo "This script needs GNU readlink and GNU date."
        echo "Install coreutils, e.g., using http://brew.sh/"
        exit 7
    fi
fi

# nastavenia
if [[ -z "$FAKULTA" ]]
then
  FAKULTA="FMFI"
fi

SCRIPTS="$($READLINK_CMD -f "$(dirname $0)")"
TARGET_DIR="../infolist"

if [ `$DATE_CMD '+%m'` -gt 7 ]; then
    # zimny semester
    LAST_YEAR=$($DATE_CMD '+%Y')
    THIS_YEAR=$($DATE_CMD '+%Y' -d "next year")
else
    # letny semester
    LAST_YEAR=$($DATE_CMD '+%Y' -d "last year")
    THIS_YEAR=$($DATE_CMD '+%Y')
fi
SEASON="$LAST_YEAR-$THIS_YEAR"
URL="https://ais2.uniba.sk/repo2/repository/default/ais/informacnelisty"

download_data() {
    lang="$1"
    datadir="$SCRIPTS/$FAKULTA"
    filelist="$datadir/files_${lang,,}.txt"
    xmldir="$datadir/xml_files_${lang,,}"
    
    mkdir -p "$datadir"

    lynx --dump "$URL/$SEASON/$FAKULTA/${lang^^}/" | awk '/http/{print $2}' | grep xml > "$filelist";
    
    mkdir -p "$xmldir";
    wget -N -q -i "$filelist" -P "$xmldir";
}

download_data_py() {
    python "$SCRIPTS/update_infolists.py" --source $URL --faculty $FAKULTA --lang $1;
}


download_webpages() {
    urllist="$SCRIPTS/webpages.sources"
    webpagesdir="$SCRIPTS/webpages.d"

    wget -N -q -i "$urllist" -P "$webpagesdir"
}


process_data() {
    # Spracujeme stiahnute subory
    python "$SCRIPTS/AIS_XML2HTML.py" --webpages "$SCRIPTS/webpages.d" "$SCRIPTS/$FAKULTA/xml_files_sk" "$TARGET_DIR/public/SK" "templates/template_2015_sk.html";
    python "$SCRIPTS/AIS_XML2HTML.py" --lang en --webpages "$SCRIPTS/webpages.d" "$SCRIPTS/$FAKULTA/xml_files_en" "$TARGET_DIR/public/EN" "templates/template_2015_en.html";

    python "$SCRIPTS/AIS_XML2HTML.py" --mode statnice --webpages "$SCRIPTS/webpages.d" "$SCRIPTS/$FAKULTA/xml_files_sk" "$TARGET_DIR/public/SK" "templates/template_2015_sk.html";
    python "$SCRIPTS/AIS_XML2HTML.py" --mode statnice --lang en --webpages "$SCRIPTS/webpages.d" "$SCRIPTS/$FAKULTA/xml_files_en" "$TARGET_DIR/public/EN" "templates/template_2015_en.html";

    # statnice

    # predmety statnych skusok maju inu sablonu aj ine XML, preto sa spracuvaju samostatne
    # python "$SCRIPTS/AIS_XML2HTML_statne-skusky.py" "$SCRIPTS/$FAKULTA/xml_files_sk" "$TARGET_DIR/public/SK";
    # python "$SCRIPTS/AIS_XML2HTML_statne-skusky.py" --lang en "$SCRIPTS/$FAKULTA/xml_files_en" "$TARGET_DIR/public/EN";
}

download_data_py sk
download_data_py en

download_webpages

if [ "$1" != "--download-only" ]
then
    process_data
fi
