do ->
  'use strict'

  diaModelBuilder = ->

    factory = ->
      prepareAlgorithmInputModel: prepareAlgorithmInputModel
      prepareAlgorithmSendModel: prepareAlgorithmSendModel
      prepareResultForDatatable: prepareResultForDatatable

    # prepare algorithm from backend to be displayed on algorithm page
    #
    # highlighter: <rectangle, polygon, circle, null>
    # inputs: algorithms input (as defined in schemas.json)
    # model: prepare input data for dynamic form
    # algorithm: copy over all default settings
    prepareAlgorithmInputModel = (id, algorithm) ->
      data =
        highlighter: null
        inputs: []
        model: {}
        algorithm: algorithm

      data.algorithm.id = id

      # prepare input information
      angular.forEach algorithm.input, (entry) ->
        key = Object.keys(entry)[0]
        if key is 'highlighter'
          # setup highlighter if there is one
          data.highlighter = entry.highlighter
        else
          # setup inputs
          data.inputs.push entry
          if key is 'select'
            data.model[entry[key].name] = entry[key].options.values[entry[key].options.default]
          else
            data.model[entry[key].name] = entry[key].options.default or null

      data: data

    # prepare algorithm information to be send to backend
    #
    # algorithm: just copy over algorithm information
    # image: path to the selected image
    # inputs: model submitted by dynamic form
    # highlighter: path information of paperJS highlighter (if any)
    prepareAlgorithmSendModel = (algorithm, selectedImage, model, path) ->
      item =
        algorithm: algorithm
        image: selectedImage
        inputs: model
        highlighter: {}

      if path?.view?
        item.highlighter =
          closed: path.closed
          segments: []
        angular.forEach path.segments, (segment) ->
          x = segment.point.x
          y = segment.point.y
          @.push [x, y]
        , item.highlighter.segments

      item: item

    # prepare algorithm input and output data to be displayed in datatable under results page
    prepareResultForDatatable = (input, output) ->
      # add html format for result so it can be displayed in a nicely way in results table
      result =
        algorithm:
          name: '<span class="text-capitalize">' + input.algorithm.name + '</span>'
          description: input.algorithm.description
        submit:
          start: input.start
          end: input.end
          duration: input.duration
        input:
          inputs: input.inputs
          highlighter: input.highlighter
          image:
            path: input.image.url
            thumbPath: '<div class="project-members"><img src=\"' + input.image.thumbUrl + '\"></div>'
        output: output

      if angular.equals {}, result.input.inputs then result.input.inputs = null
      if angular.equals {}, result.input.highlighter then result.input.highlighter = null

      result: result


    factory()

  angular.module('app.core')
    .factory 'diaModelBuilder', diaModelBuilder
