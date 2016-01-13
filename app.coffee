webdriver = require('selenium-webdriver')

driver = (new (webdriver.Builder)).withCapabilities(webdriver.Capabilities.firefox()).build()
driver.manage().window().maximize()
driver.manage().window().setSize(1440, 900);

driver.get 'http://dev-lifelock.samsclub.com/'
driver.takeScreenshot().then (image, err) ->
  require('fs').writeFile 'out.png', image, 'base64', (err) ->
    console.log err

driver.quit()