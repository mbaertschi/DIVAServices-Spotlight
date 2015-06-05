do ->
  'use strict'

  diaCaptchaService = ($http) ->

    factory = ->
      checkCaptcha: checkCaptcha

    checkCaptcha = (params) ->
      data = {}
      data[params.name] = params.value
      name: data.value
      $http.post('/captcha/try/', data).then (res) ->
        res

    factory()

  angular.module('app.core')
    .factory 'diaCaptchaService', diaCaptchaService

  diaCaptchaService.$inject = [
    '$http'
  ]
