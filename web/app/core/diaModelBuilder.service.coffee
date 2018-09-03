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
        infos: []

      data.algorithm.id = id

      if algorithm.description? then data.infos.push description: algorithm.description
      angular.forEach algorithm.general, (value, key) ->
        obj = {}
        if key is 'expectedRuntime' and not isNaN(parseFloat(value))
          runtime = parseFloat value
          if runtime is 1 then runtime += ' second' else runtime += ' seconds'
          obj[key] = runtime
        else
          obj[key] = value
        data.infos.push obj
      # prepare input information
      angular.forEach algorithm.input, (entry) ->
        key = Object.keys(entry)[0]
        if key is 'highlighter'
          # setup highlighter if there is one
          data.highlighter = entry.highlighter.type
        else
          # setup inputs
          if(entry[key].userdefined)
            data.inputs.push entry
            switch key
              when 'select'
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
    prepareAlgorithmSendModel = (algorithm, selectedImage, model, highlighterData) ->
      item =
        algorithm: algorithm
        image: selectedImage
        inputs: model

      if highlighterData?.path?.view?
        path = highlighterData.path.clone()
        path.visible = false
        path.fullySelected = false
        path.scale highlighterData.scale, [0, 0]
        type = highlighterData.type

        if type is 'circle'
          item.inputs.highlighter =
            type: type
            closed: path.closed
            position: [parseInt(path.position.x), parseInt(path.position.y)]
            radius: path.bounds.width / 2
        else if type is 'rectangle'
         item.inputs.highlighter =
           type: type
           closed: path.closed
           segments: []
         item.inputs.highlighter.segments.push([path.segments[0].point.x, path.segments[0].point.y])
         item.inputs.highlighter.segments.push([path.segments[3].point.x, path.segments[3].point.y])
         item.inputs.highlighter.segments.push([path.segments[2].point.x, path.segments[2].point.y])
         item.inputs.highlighter.segments.push([path.segments[1].point.x, path.segments[1].point.y])
        else
          item.inputs.highlighter =
            type: type
            closed: path.closed
            segments: []
          angular.forEach path.segments, (segment) ->
            x = parseInt segment.point.x
            y = parseInt segment.point.y
            @.push [x, y]
          , item.inputs.highlighter.segments

      item: item

    # prepare algorithm input and output data to be displayed in datatable under results page
    prepareResultForDatatable = (input, output) ->
      visualization = null
      highlighter = []
      for entry in output.output
        if 'file' of entry
          if entry.file.options.visualization
            visualization = entry
        if 'array' of entry
          if entry.array.options? and entry.array.options.visualization
            highlighter.push(entry)
        if 'highlighter' of entry
          highlighter.push.apply(highlighter, entry.highlighter)

      if(!visualization?)
        visFile = {}
        visFile['mime-type'] = 'image/png'
        visFile['url'] = input.image.url
        visFile['options'] =
          visualization: true
          type: 'image'
        visFile['name'] = 'visualization.png'
        output['visualization'] = {}
        output.visualization['file'] = visFile
      else
        output['visualization'] = visualization
      output['highlighter'] = highlighter
      console.log input
      result =
        algorithm:
          id: input.algorithm.id
          uuid: input.uuid
          name: input.algorithm.general.name
          description: input.algorithm.general.description
        submit:
          start: input.start
          end: input.end
          duration: input.duration
        input:
          uuid: input.uuid
          inputs: input.inputs
          highlighter: input.highlighter
          image: input.image
        output: output

      result.output.uuid = input.uuid
      console.log result
      if angular.equals {}, result.input.inputs then result.input.inputs = null
      if angular.equals {}, result.output.output then result.output.output = null

      
      if result.input.inputs == null
        result.input.highlighter = null
      else if not angular.isDefined result.input.inputs.highlighter 
        result.input.highlighter = null
      else
        parsedHighlighter = {}
        parsedHighlighter[result.input.inputs.highlighter.type] = result.input.inputs.highlighter
        result.input.higlhlighters = [parsedHighlighter]

      result: result
      
    factory()

  angular.module('app.core')
    .factory 'diaModelBuilder', diaModelBuilder
