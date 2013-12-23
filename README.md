This projects uses https://github.com/philschatz/css-polyfills to generate an HTML and a CSS file from a HTML file and CSS file that contains CSS Rules that are not supported by browsers or reading systems.

# Install and Run

    npm install

    phantomjs phantom-harness.coffee $(pwd) $(pwd)/test/test.css $(pwd)/test/test.html ./out.html ./out.css


# Generate a Diff

To do this, you will need to:

1. generate the **old** HTML file
2. make some CSS/HTML changes
3. regenerate the **new** HTML file
4. generate the diff'd HTML file
5. Open the diff'd HTML in a browser to see the changes

Let's use the example test file in `./test/test.html`


    # Generate the **old** HTML file (the file extension is important)
    phantomjs phantom-harness.coffee $(pwd) $(pwd)/test/test.css $(pwd)/test/test.xhtml ./old.html ./old.css

    # Change `./test/test.css` by commenting out a line or two and save
    # ...

    # Generate the **new** HTML file
    phantomjs phantom-harness.coffee $(pwd) $(pwd)/test/test.css $(pwd)/test/test.xhtml ./new.html ./new.css

    # Generate the diff'd HTML file
    # (the file extension on diff.xhtml is important if opened in a browser)
    xsltproc --stringparam oldPath ./old.html ./compare.xsl ./new.html > ./diff.xhtml

    # **Note:** The location of old.html in the previous line is
    # relative to compare.xsl and **not** the current working directory.

