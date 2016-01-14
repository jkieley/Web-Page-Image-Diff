webdriver = require('selenium-webdriver')
fsp = require('fs-promise')


driver = (new (webdriver.Builder)).withCapabilities(webdriver.Capabilities.firefox()).build()
driver.manage().window().maximize()
driver.manage().window().setSize(1440, 900);

files = []

takeScreenshot = (url,imageName)->
  driver.get url
  return driver.takeScreenshot().then((image, err) ->
    console.log 'write file! ',imageName
    return fsp.writeFile("#{imageName}.png", image, 'base64').then((err)->
      console.log 'done writing: ', imageName
    )
  )

takeScreenshot('http://dev-lifelock.samsclub.com/', 'dev-lifelock').then(->
  takeScreenshot('http://lifelock.samsclub.com/', 'prod')
).then(->
  console.log 'both are done'
)


driver.quit()