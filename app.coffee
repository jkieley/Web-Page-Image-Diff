webdriver = require('selenium-webdriver')
fsp = require('fs-promise')
fs = require('fs')
resemble = require('node-resemble.js')

driver = (new (webdriver.Builder)).withCapabilities(webdriver.Capabilities.firefox()).build()
driver.manage().window().maximize()
driver.manage().window().setSize(1440, 900);

files = []
diffCount = 0

takeScreenshot = (url,imageName)->
  driver.get url
  return driver.takeScreenshot().then((image, err) ->
    console.log 'write file! ',imageName
    return fsp.writeFile(imageName, image, 'base64').then((err)->
      console.log 'done writing: ', imageName
      files.push(imageName)
    )
  )

generateImageDiff = (url1,url2)->
  image1 = "img-#{files.length}.png"
  takeScreenshot(url1, image1).then(->
    image2 = "img-#{files.length}.png"
    takeScreenshot(url2, image2)
  ).then(->
    resemble(fs.readFileSync(files[0])).compareTo(fs.readFileSync(files[1])).onComplete (data) ->
      console.log 'Percentage of Difference: ', data.misMatchPercentage + "%"
      png = data.getDiffImage()
      imageName = "out-#{diffCount++}.png"
      png.pack().pipe fs.createWriteStream(imageName)
      png.on 'parsed', ->
        png.pack().pipe fs.createWriteStream(imageName)

  )

generateImageDiff('http://localhost:8080/','http://lifelock.samsclub.com/')






driver.quit()