path      = require 'path'
fs        = require 'fs'
{spawn}   = require 'child_process'
optimist  = require 'optimist'


args = optimist
  .usage('Usage: $0')
  .options('h',
    alias     : 'help'
    boolean   : true
    describe  : 'Show this help info and exit'
  )
  .options('h',
    alias     : 'input-html'
    describe  : 'Input HTML File'
  )
  .options('v',
    alias     : 'verbose'
    describe  : 'Verbose Output'
  )
  .options('o',
    alias     : 'output-html'
    describe  : 'Output HTML File'
  )
  .options('c',
    alias     : 'input-css'
    describe  : 'Input CSS (or LESS) File'
  )
  .options('x',
    alias     : 'output-css'
    describe  : 'Output CSS File (optional)'
  )

argv = args.argv


# Use local phantomjs
PHANTOMJS_BIN = path.join(__dirname, 'node_modules/.bin/phantomjs')
PHANTOMJS_HARNESS = path.join(__dirname, 'phantom-harness.coffee')


{c:inputCss, h:inputHtml, o:outputHtml, x:outputCss, v:verbose} = argv

unless inputCss and inputHtml and outputHtml
  console.log('Missing Required arg')
  console.log argv
  console.log inputCss, inputHtml, outputHtml
  args.showHelp()
  process.exit(1)

# Convert files to absolute path
inputCss = path.resolve(process.cwd(), inputCss)
inputHtml = path.resolve(process.cwd(), inputHtml)
outputHtml = path.resolve(process.cwd(), outputHtml)
outputCss = path.resolve(process.cwd(), outputCss) if outputCss

unless fs.existsSync(inputCss)
  console.log('Input CSS file not found')
  process.exit(1)

unless fs.existsSync(inputHtml)
  console.log('Input HTML file not found')
  process.exit(1)


options =
  cwd: __dirname
  stdio: 'ignore'

# Print the output of PhantomJS if verbose is set
options.stdio = 'inherit' if verbose


args = [PHANTOMJS_HARNESS, __dirname, inputCss, inputHtml, outputHtml, outputCss]
child = spawn(PHANTOMJS_BIN, args, options)

child.on 'close', (code) ->
  process.exit(code)
