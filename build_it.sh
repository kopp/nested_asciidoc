#!/usr/bin/bash


# build documents and index.html with list of documents


# param: where to generate output to
outdir=$1

# list of files to process with path relative to here and without .adoc -- must
# have .adoc extension
files=(toplevel)

# options common to asciidoctor and asciidoctor-pdf
common_options=""

# options used by html only
# - use `data-uri` to embed the images as base64 -- you don't need to copy images
#   around then, but the html gets bloated...
#   alternatively, recursively copy all `images` folders and rely on the user to
#   only put data into the `images` folder
html_options="-a data-uri"


# header and footer for index file
INDEX_HEADER='<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Index of generated asciidoc documents.</title>
</head>
<body>'

INDEX_FOOTER='</body>
</html>'

# filepath for index.html
index_path=$outdir/index.html


# sanitize input
if [ -z $outdir ] || [ ! -d $outdir ]
then
    echo Error: Specify an output directory
    exit 1
fi


# start index.html
echo $INDEX_HEADER > $index_path


# start list of files
echo -e '<h1>List of files</h1>\n<ol>' >> $index_path

# generate files, add them to index.html
for file in ${files[@]}
do
    # generate
    asciidoctor     $common_options $html_options -o $outdir/$file.html $file.adoc
    asciidoctor-pdf $common_options $pdf_options  -o $outdir/$file.pdf  $file.adoc
    # add to index
    echo "<li>${file}; see <a href=\"$file.html\">html version</a> or <a href=\"$file.pdf\">pdf version</a></li>" >> $index_path
done

# end list of files
echo -e '</ol>' >> $index_path


# finish index.html
echo $INDEX_FOOTER >> $index_path
