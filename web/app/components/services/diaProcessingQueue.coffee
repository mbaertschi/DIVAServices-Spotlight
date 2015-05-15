angular.module('app').factory 'diaProcessingQueue', [
  '$rootScope'
  '$http'
  '$q'
  'toastr'

  ($rootScope, $http, $q, toastr) ->
    queue = []
    results = []
    $rootScope.tasks = 0
    $rootScope.finished = 0

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

    results: ->
      return results

    queue: ->
      return queue

    abort: (entry) ->
      angular.forEach queue, (queueEntry, index) ->
        if entry.item.index is queueEntry.item.index
          queue.splice index, 1
          entry.defer.reject 'Canceled by user'
          if index is 0 and queue.length > 0
            execNext()

    push: (item) ->
      defer = $q.defer()
      item.index = queue.length
      queue.push
        item: item
        defer: defer
      if queue.length is 1
        execNext()
      $rootScope.tasks++
      defer.promise.then (res) ->
        $rootScope.tasks--
        $rootScope.finished++
        toastr.info "Algorithm #{res.data.algorithm.name} is done", 'Info'
        results.push res.data
      , (err) ->
        $rootScope.tasks--
        if err.config? then toastr.error "Post request for #{err.config.data.algorithm.name} failed", err.data.code
]
