do ->
  'use strict'

  angular.module 'app.core', [
    # Angular modules
    'ngAnimate'
    'ngTouch'

    # Our reusable cross app code modules

    # 3rd Party modules
    'ui.router'
    'ui.bootstrap'
    'btford.socket-io'
    'toastr'
    'lodash'
  ]
