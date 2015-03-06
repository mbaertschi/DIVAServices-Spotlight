angular.module('app').factory 'notificationService', [
  '$filter'

  ($filter) ->

    add: (options) ->
      return if not options

      type = options.type || 'info'
      unless type in ['success', 'info', 'warning', 'danger']
        type = 'info'

      box =
        title       : options.title || 'No title'
        content     : options.content || 'No description'
        type        : type
        color       : $filter('colorFilter')(type)
        icon        : $filter('iconFilter')(type)
        timeout     : options.timeout

      $.smallBox box

      return
]
