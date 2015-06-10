do ->
  'use strict'

  diaPanAndZoomManager = ->

    factory = ->
      factory.paperScopes = {}
      add: add
      activate: activate
      changeZoom: changeZoom
      changeCenter: changeCenter
      reset: reset

    add = (type, id, vm) ->
      if not factory.paperScopes[id]? then factory.paperScopes[id] = {}
      factory.paperScopes[id][type] = vm
      factory.paperScopes[id].active = true

    activate = (id) ->
      factory.paperScopes[id].active = true

    reset = (id) ->
      factory.paperScopes[id].active = false

    changeZoom = (id, deltaY, viewPosition) ->
      calcNewZoom = (oldZoom, delta, c, p) ->
        factor = 1.01
        if delta < 0
          newZoom = oldZoom * factor
        else if delta > 0
          newZoom = oldZoom / factor
        else
          newZoom = oldZoom
        beta = oldZoom / newZoom
        pc = [p.x - c.x, p.y - c.y]
        mult = [pc[0] * beta, pc[1] * beta]
        sub = [p.x - mult[0], p.y - mult[1]]
        a = [sub[0] - c.x, sub[1] - c.y]
        [newZoom, a]

      if factory.paperScopes[id].active and factory.paperScopes[id]['input']?
        paperInput = factory.paperScopes[id]['input']
        [newZoom, offset] = calcNewZoom paperInput.view.zoom, deltaY, paperInput.view.center, viewPosition
        paperInput.view.zoom = newZoom
        paperInput.view.center = [paperInput.view.center.x + offset[0], paperInput.view.center.y + offset[1]]
      if factory.paperScopes[id].active and factory.paperScopes[id]['output']?
        outputPaper = factory.paperScopes[id]['output']
        [newZoom, offset] = calcNewZoom outputPaper.view.zoom, deltaY, outputPaper.view.center, viewPosition
        outputPaper.view.zoom = newZoom
        outputPaper.view.center = [outputPaper.view.center.x + offset[0], outputPaper.view.center.y + offset[1]]

    changeCenter = (id, deltaX, deltaY, deltaFactor) ->
      calcNewCenter = (oldCenter, deltaX, deltaY, factor) ->
        offset = [deltaX * factor, -deltaY * factor]
        newCenter = [oldCenter.x + offset[0], oldCenter.y + offset[1]]
        newCenter

      if factory.paperScopes[id].active and factory.paperScopes[id]['input']?
        inputPaper = factory.paperScopes[id]['input']
        inputPaper.view.center = calcNewCenter inputPaper.view.center, deltaX, deltaY, deltaFactor
      if factory.paperScopes[id].active and factory.paperScopes[id]['output']?
        outputPaper = factory.paperScopes[id]['output']
        outputPaper.view.center = calcNewCenter outputPaper.view.center, deltaX, deltaY, deltaFactor

    factory()

  angular.module('app.results')
    .factory 'diaPanAndZoomManager', diaPanAndZoomManager
