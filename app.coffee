webdriver = require('selenium-webdriver')
fsp = require('fs-promise')
fs = require('fs')
resemble = require('node-resemble.js')

driver = (new (webdriver.Builder)).withCapabilities(webdriver.Capabilities.firefox()).build()
driver.manage().window().maximize()
driver.manage().window().setSize(1440, 900);

files = []

takeScreenshot = (url,imageName)->
  driver.get url
  return driver.takeScreenshot().then((image, err) ->
    console.log 'write file! ',imageName
    return fsp.writeFile(imageName, image, 'base64').then((err)->
      console.log 'done writing: ', imageName
      files.push(imageName)
    )
  )

takeScreenshot('http://dev-lifelock.samsclub.com/', 'dev-lifelock.png').then(->
  takeScreenshot('http://lifelock.samsclub.com/', 'prod.png')
).then(->
  resemble(fs.readFileSync(files[0])).compareTo(fs.readFileSync(files[1])).ignoreColors().onComplete (data) ->
    console.log data
)


driver.quit()