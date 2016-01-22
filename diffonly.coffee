fs = require('fs')
resemble = require('node-resemble.js')

resemble(fs.readFileSync('dev-lifelock.png').compareTo(fs.readFileSync('prod.png').onComplete (data) ->
  console.log 'Percentage of Difference: ', data.misMatchPercentage + "%"
  png = data.getDiffImage()
  png.pack().pipe fs.createWriteStream('out.png')
  png.on 'parsed', ->
    png.pack().pipe fs.createWriteStream('out.png')