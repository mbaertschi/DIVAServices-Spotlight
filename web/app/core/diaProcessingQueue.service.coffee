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

  diaProcessingQueue = ($rootScope, $http, $q, toastr) ->
    queue = []
    results = []
    $rootScope.finished = 0

    factory = ->
      abort: abort
      createResult: createResult
      execNext: execNext
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
          if index is 0 and queue.length > 0
            execNext()

    # add finished algorithm to results array
    createResult = (input, output) ->
      # add html format for result so it can be displayed in a nicely way in results table
      result =
        algorithm:
          name: '<span class="text-capitalize">' + input.algorithm.name + '</span>'
          description: input.algorithm.description
        image:
          path: input.image.url
          thumbPath: '<div class="project-members"><img src=\"' + input.image.thumbUrl + '\"></div>'
        submit:
          start: input.start
          end: input.end
          duration: input.duration
        input:
          inputs: input.inputs
          highlighter: input.highlighter
        output: output

      if angular.equals {}, result.input.inputs then result.input.inputs = null
      if angular.equals {}, result.input.highlighter then result.input.highlighter = null
      result

    # processes the next entry in queue as long as there is one
    execNext = ->
      task = queue[0]
      url = '/api/algorithm'
      data = task.item

      $http.post(url, data).then (res) ->
        queue.shift()
        task.defer.resolve res
        if queue.length > 0
          execNext()
      , (err) ->
        queue.shift()
        task.defer.reject err
        if queue.length > 0
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
        results.push createResult(item, res.data)
      , (err) ->
        if err.config? then toastr.error "Post request for #{err.config.data.algorithm.name} failed", err.data.code

    factory()

  angular.module('app.core')
    .factory 'diaProcessingQueue', diaProcessingQueue

  diaProcessingQueue.$inject = [
    '$rootScope'
    '$http'
    '$q'
    'toastr'
  ]
