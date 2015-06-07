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
      # remove algorithm with given index from processing queue
      angular.forEach queue, (queueEntry, index) ->
        if entry.item.index is queueEntry.item.index
          queue.splice index, 1
          entry.defer.reject 'Canceled by user'
          if index is 0 and queue.length
            execNext()

    # processes the next entry in queue as long as there is one
    execNext = ->
      task = queue[0]
      url = '/api/algorithm'
      data = task.item

      $http.post(url, data).then (res) ->
        queue.shift()
        task.defer.resolve res
        if queue.length
          execNext()
      , (err) ->
        queue.shift()
        task.defer.reject err
        if queue.length
          execNext()

    # expose results array
    getResults = ->
      results

    # expose queue array
    getQueue = ->
      queue

    # add new algorithm to processing queue. We use promises in order to be able
    # to handle aborted algorithms
    push = (item) ->
      defer = $q.defer()
      # store a reference to index in queue
      item.index = queue.length
      item.start = new Date
      queue.push
        item: item
        defer: defer
      if queue.length is 1
        execNext()
      defer.promise.then (res) ->
        end = new Date
        duration = end / 1000 - item.start / 1000
        item.start = moment(item.start).format 'HH:mm:ss'
        item.end = moment(end).format 'HH:mm:ss'
        item.duration = duration.toFixed(2)
        $rootScope.finished++
        toastr.info "Algorithm #{item.algorithm.name} is done", 'Info'
        results.push diaModelBuilder.prepareResultForDatatable item, res.data
      , (err) ->
        if err.config? then toastr.error "Post request for #{err.config.data.algorithm.name} failed", err.data.code

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
