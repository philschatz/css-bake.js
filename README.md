This projects uses https://github.com/philschatz/css-polyfills to generate an HTML and a CSS file from a HTML file and CSS file that contains CSS Rules that are not supported by browsers or reading systems.

# Install and Run

    npm install

    phantomjs phantom-harness.coffee $(pwd) $(pwd)/test/test.css $(pwd)/test/test.xhtml ./out.html ./out.css

