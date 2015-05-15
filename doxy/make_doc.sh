#!/bin/bash

doxygen

IROOTDIR="../../../last-generated-doc"

#cp tabs.css "${IROOTDIR}/html"
cp doxygen.css "${IROOTDIR}/html"
#cp background_navigation.png "${IROOTDIR}/html"
#cp img_downArrow.png "${IROOTDIR}/html"

