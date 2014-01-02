#!/bin/bash

# To run this file you will need:
#
# - python
# - phantomjs
# - xsltproc
# - genhtml (or `brew install lcov`): Optional

# Example books:

#sh ./do-coverage.sh sociology   ~/Downloads/col-sociology-11407_1.7_complete       new
#sh ./do-coverage.sh statistics  ~/Downloads/col-statistics-11562_1.11_complete     new
#sh ./do-coverage.sh anatomy     ~/Downloads/col-anatomy-11496-1.6_complete         new
#sh ./do-coverage.sh biology     ~/Downloads/col-biology-11448_1.9_complete         new
#sh ./do-coverage.sh physics     ~/Downloads/col-physics-11406_1.7_complete         new
#sh ./do-coverage.sh precalculus ~/Downloads/precalc-test-data                      new


PRINCE_BIN=~/Downloads/prince-9.0-macosx/lib/prince/bin/prince
OER_EXPORTS_PATH=~/oer.exports
CSS_DIFF_PATH=~/Sites/css-diff
CWD=$(pwd)


LESS_FILE=${OER_EXPORTS_PATH}/css/ccap-${1}.less
TEMPDIR=${CWD}/tempdir-${1}-${3}
BAKED_XHTML_FILE=${CWD}/ccap-${1}-${3}.xhtml


# 1. Generate HTML into ${TEMPDIR}
python ${OER_EXPORTS_PATH}/collectiondbk2pdf.py -p ${PRINCE_BIN} -d ${2} -s ccap-${1} -t ${TEMPDIR} > ccap-${1}-${3}.pdf

# 2. Generate HTML Coverage Report (optional)
# 2a. Generate LCOV file
phantomjs ${CSS_DIFF_PATH}/phantom-coverage.coffee ${CSS_DIFF_PATH} ${LESS_FILE} ${TEMPDIR}/collection.xhtml ${CWD}/ccap-${1}-${3}.lcov
# 2b. Generate HTML Report from LCOV file
genhtml ./ccap-${1}-${3}.lcov --output-directory ./ccap-${1}-${3}-coverage

# 3. Generate HTML For Later Diffing
phantomjs ${CSS_DIFF_PATH}/phantom-harness.coffee ${CSS_DIFF_PATH} ${LESS_FILE} ${TEMPDIR}/collection.xhtml ${BAKED_XHTML_FILE}

# 4. Generate Diff if the last argument is not 'old'
if [ "${3}" != 'old' ]; then
  echo "Generating HTML Diff! ${CWD}/ccap-${1}-diff.xhtml"
  xsltproc --stringparam oldPath ${CWD}/ccap-${1}-old.xhtml ${CSS_DIFF_PATH}/compare.xsl ${BAKED_XHTML_FILE} > ${CWD}/ccap-${1}-diff.xhtml
fi
