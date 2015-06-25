# ###
# Factory diaProcessingQueue
#
# * maintains queue for algorithms to be processed
# * handles abort for submitted algorithms
# * exposes results and queue array as well as push method
# * once an algorithm has been processed successfully, it will be added to
#   results array which itself is handled by results page
# ###
do ->
  'use strict'

  diaProcessingQueue = ($rootScope, $http, $q, diaModelBuilder, toastr) ->
    queue = []
    results = []
    $rootScope.finished = 0

    factory = ->
      abort: abort
      getResults: getResults
      getQueue: getQueue
      push: push

    # handle aborted algorithms (from diaProcessingAlgrithm directive)
    abort = (entry) ->
      queue.splice queue.indexOf(entry), 1
      entry.item.aborted = true
      entry.defer.reject 'Canceled by user'

    # processes entry
    exec = (entry) ->
      task = queue[queue.indexOf entry]
      if task?
        task.item.start = new Date
        task.item.started = true
        url = '/api/algorithm'
        data = task.item

        $http.post(url, data).then (res) ->
          if not data.aborted
            queue.splice queue.indexOf(entry), 1
            task.defer.resolve res
        , (err) ->
          if not data.aborted
            queue.splice queue.indexOf(entry), 1
            task.defer.reject err

    # expose results array
    getResults = ->
      results

    # expose queue array
    getQueue = ->
      queue

    # add new algorithm to processing queue. We use promises in order to be able
    # to handle aborted algorithms
    push = (item) ->

      # guid generator
      guid = ->
        s4 = ->
          Math.floor((1 + Math.random()) * 0x10000).toString(16).substring 1
        s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4()

      defer = $q.defer()
      item.guid = guid()
      entry =
        item: item
        defer: defer
      queue.push entry
      exec entry
      defer.promise.then (res) ->
        end = new Date
        duration = end / 1000 - item.start / 1000
        item.start = moment(item.start).format 'HH:mm:ss'
        item.end = moment(end).format 'HH:mm:ss'
        item.duration = duration.toFixed(2)
        item.uuid = end.getTime()
        $rootScope.finished++
        toastr.info "Algorithm #{item.algorithm.name} is done", 'Info'
        results.push diaModelBuilder.prepareResultForDatatable(item, res.data).result
      , (err) ->
        if err.data? then code = err.data.code else code = 500
        if err.config? then toastr.error "Post request for #{err.config.data.algorithm.name} failed", code

    factory()

  angular.module('app.core')
    .factory 'diaProcessingQueue', diaProcessingQueue

  diaProcessingQueue.$inject = [
    '$rootScope'
    '$http'
    '$q'
    'diaModelBuilder'
    'toastr'
  ]
