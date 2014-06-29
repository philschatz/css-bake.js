This projects uses [css-polyfills.js](http://philschatz.com/css-polyfills.js/) to generate an HTML and a CSS file from a HTML file and CSS file that contains CSS Rules not supported by browsers or reading systems.

# Install and Run

You can install locally or globally (`npm install -g css-bake`). Installing globally will give you access to `css-bake` from the commandline.

# Usage

Required args:

- `--input-html`    : existing HTML file to convert
- `--input-css`     : existing CSS file to convert
- `--output-html`   : new converted HTML file
- `--output-css`    : new converted CSS file (*optional*)

# Example

given the following HTML:

    <html>
      <body>
        <div class="wrapped">Hello World</div>
      </body>
    </html>

and CSS files:

    .wrapped          { border: 10px solid black; }
    .wrapped::outside { border: 10px solid green; }

Run the following:

    css-bake --input-html ./test/test.html --input-css ./test/test.css --output-html ./output.html

and you should get the following `output.html`:

    <html xmlns="http://www.w3.org/1999/xhtml">
      <body>
        <span style="border:10px solid green;">
          <div class="wrapped" style="border:10px solid black;">Hello World</div>
        </span>
      </body>
    </html>


You may also add an optional `--output-css ./output.css` which will place the styles in a CSS file instead of "baking" them into the `style="..."` attribute.


# Bonus! Generate a Diff

To do this, you will need to:

1. generate the **old** HTML file
2. make some CSS/HTML changes
3. regenerate the **new** HTML file
4. generate the diff'd HTML file
5. Open the diff'd HTML in a browser to see the changes

Let's use the example test file in `./test/test.html`:


    # Generate the **old** HTML file (the file extension is important)
    css-bake -i ./test/test.html -c ./test/test.css -o ./old.xhtml

    # Change `./test/test.css` by commenting out a line or two and save
    # ...

    # Generate the **new** HTML file
    css-bake -i ./test/test.html -c ./test/test.css -o ./new.xhtml

    # Generate the diff'd HTML file
    # (the file extension on diff.xhtml is important if opened in a browser)
    xsltproc --stringparam oldPath ./old.xhtml ./compare.xsl ./new.xhtml > ./diff.xhtml

    # **Note:** The location of old.xhtml in the previous line is
    # relative to compare.xsl and **not** the current working directory.
