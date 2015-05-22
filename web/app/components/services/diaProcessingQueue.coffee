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

    createResult = (input, output) ->
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

      return result

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
      item.start = new Date
      queue.push
        item: item
        defer: defer
      if queue.length is 1
        execNext()
      $rootScope.tasks++
      defer.promise.then (res) ->
        end = new Date
        duration = end / 1000 - item.start / 1000
        item.start = moment(item.start).format 'HH:mm:ss'
        item.end = moment(end).format 'HH:mm:ss'
        item.duration = duration.toFixed(2)
        $rootScope.tasks--
        $rootScope.finished++
        toastr.info "Algorithm #{item.algorithm.name} is done", 'Info'
        results.push createResult(item, res.data)
      , (err) ->
        $rootScope.tasks--
        if err.config? then toastr.error "Post request for #{err.config.data.algorithm.name} failed", err.data.code
]
