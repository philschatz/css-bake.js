This projects uses https://github.com/philschatz/css-polyfills to generate an HTML and a CSS file from a HTML file and CSS file that contains CSS Rules that are not supported by browsers or reading systems.

# Install and Run

You can install locally or globally (`npm install -g .`). Installing globally will give you access to `css-coverage` from the commandline.

    npm install

    # Run CSS Coverage
    node ./bin/css-coverage -s ./test/test.css -h ./test/test.html

# Generate CSS Coverage

This project can generate CSS coverage, given a CSS file and an HTML file.

Let's use the example test file in `./test/test.html`:

    # Run CSS Coverage
    node ./bin/css-coverage -s ./test/test.css -h ./test/test.html

You can also generate LCOV data for use in services like <http://coveralls.io>:

    # Run CSS Coverage and generate a LCOV report (with verbose output)
    node ./bin/css-coverage -v -s ./test/test.css -h ./test/test.html -l ./css.lcov

    # Optionally Generate an HTML report
    genhtml ./css.lcov --output-directory ./coverage


# Generate a Diff

To do this, you will need to:

1. generate the **old** HTML file
2. make some CSS/HTML changes
3. regenerate the **new** HTML file
4. generate the diff'd HTML file
5. Open the diff'd HTML in a browser to see the changes

Let's use the example test file in `./test/test.html`:


    # Generate the **old** HTML file (the file extension is important)
    phantomjs phantom-harness.coffee $(pwd) $(pwd)/test/test.css $(pwd)/test/test.html ./old.xhtml

    # Change `./test/test.css` by commenting out a line or two and save
    # ...

    # Generate the **new** HTML file
    phantomjs phantom-harness.coffee $(pwd) $(pwd)/test/test.css $(pwd)/test/test.html ./new.xhtml

    # Generate the diff'd HTML file
    # (the file extension on diff.xhtml is important if opened in a browser)
    xsltproc --stringparam oldPath ./old.xhtml ./compare.xsl ./new.xhtml > ./diff.xhtml

    # **Note:** The location of old.xhtml in the previous line is
    # relative to compare.xsl and **not** the current working directory.

    # Alternatively, you can print out counts of all the changes by running:
    xsltproc --stringparam oldPath ./old.xhtml --output ./diff.xhtml ./compare.xsl ./new.xhtml 2>&1 | sort | uniq -c | sort -n -r
