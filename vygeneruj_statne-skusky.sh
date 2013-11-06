#!/bin/bash

DIR="/var/www/sluzby/infolist"

# sk
python "$DIR/scripts/AIS_XML2HTML_statne-skusky.py" "$DIR/scripts/xml_files_statne-skusky_sk/mgr/" "$DIR/public/SK";
python "$DIR/scripts/AIS_XML2HTML_statne-skusky.py" "$DIR/scripts/xml_files_statne-skusky_sk/bc/" "$DIR/public/SK";

# en
python "$DIR/scripts/AIS_XML2HTML_statne-skusky.py" "$DIR/scripts/xml_files_statne-skusky_en/mgr/" --lang en "$DIR/public/EN";
python "$DIR/scripts/AIS_XML2HTML_statne-skusky.py" "$DIR/scripts/xml_files_statne-skusky_en/bc/" --lang en "$DIR/public/EN";
