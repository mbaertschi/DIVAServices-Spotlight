# Base class for all page objects
class PageObject

  # Alias for a collection of element locators
  by: protractor.By

  # Locates the first element containing `label` text
  byLabel: (label, tag = "a") ->
    @by.xpath ".//#{tag}[contains(text(), '#{label}')]"

  # Waits until all animations stop
  waitForAnimations: ->
    browser.wait =>
      animated = browser.findElement @By.css(".ng-animate")
      animated.then (animated) -> animated.length is 0

  # Define element on the page
  @has: (name, getter) ->
    Object.defineProperty @::, name, get: getter

  url: null

  @has 'breadcrumbs', ->
    $('#ribbon .breadcrumb').all(@by.css('li')).map (item)->
      item.getText()

  @has 'title', ->
    $('.page-title').getText()

  visitPage: ->
    # this is more stable and faster than browser.get() because it
    # doesn't reload the page. does't reset the apps state, though.
    $("*[href='#{@url}']").click()

module.exports = PageObject
