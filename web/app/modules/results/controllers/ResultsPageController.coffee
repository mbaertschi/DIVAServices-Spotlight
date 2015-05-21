angular.module('app.results').controller 'ResultsPageController', [
  '$scope'
  'diaProcessingQueue'

  ($scope, diaProcessingQueue) ->
    $scope.results = diaProcessingQueue.results()

    $scope.tableOptions =
      data: $scope.results
      iDisplayLength: 15,
      columns: [
        {
          class: 'details-control'
          orderable: false
          data: null
          defaultContent: ''
        }
        { data: 'algorithm.name' }
        { data: 'algorithm.description' }
        { data: 'image.thumbPath' }
        { data: 'submit.start' }
        { data: 'submit.end' }
        { data: 'submit.duration' }
      ]
      order: [[5, 'dsc']]

    $scope.results.push
      'algorithm':
        'name': '<span class="text-capitalize">multiscaleipd</span>'
        'description': 'this will apply the multiscaleipd algorithm on your image'
      'image':
        'path': '/uploads/uSXD3v925E-9l7DzlF8N2d-h1DnQiOZe/upload_0.png?1432201614255'
        'thumbPath': '<div class="project-members"><img src="/uploads/uSXD3v925E-9l7DzlF8N2d-h1DnQiOZe/upload_0_thumbnail.png"></div>'
      'submit':
        'start': '11:47:00'
        'end': '11:47:01'
        'duration': '1.01'
      'input':
        'inputs':
          'detector': 'Harris'
          'blurSigma': 2
          'numScales': 1
          'numOctaves': 2
          'threshold': 0.000001
          'maxFeaturesPerScale': 3
          'textInputTest': 'test text'
          'testCheckbox': 1
        'highlighter':
          'strokeWidth': 3.9950062421972534
          'strokeColor': [
            1
            0
            0
          ]
          'position': [
            'Point'
            461.6236
            211.25093
          ]
          'scaling': 1.2515625
          'closed': true
          'pivot': null
          'segments': [
            [
              'Segment'
              611.83583
              277.56804
            ]
            [
              'Segment'
              311.41136
              334.29712
            ]
            [
              'Segment'
              503.17166
              88.20474
            ]
          ]
      'output': {}
]
