do ->
  'use strict'

  diaPanAndZoomManager = ->
    pz = null

    factory = =>
      pz = @
      pz.paperScopes = {}
      add: add
      activate: activate
      changeZoom: changeZoom
      changeCenter: changeCenter
      initPanAndZoom: initPanAndZoom
      reset: reset

    initPanAndZoom = (type, vm) ->
      if /MAC/.test navigator.platform.toUpperCase() then pz.direction = 1 else pz.direction = -1
      @add type, vm.uuid, vm.paperScope
      vm.element.on 'mouseenter', (event) =>
        @activate vm.uuid
      vm.element.on 'mouseleave', =>
        @reset vm.uuid
      vm.element.on 'mousewheel', (event) =>
        if event.shiftKey
          @changeCenter vm.uuid, event.deltaX, event.deltaY, event.deltaFactor
          event.preventDefault()
        else if event.altKey
          mousePosition = new vm.paperScope.Point event.offsetX, event.offsetY
          viewPosition = vm.paperScope.view.viewToProject mousePosition
          @changeZoom vm.uuid, event.deltaY, viewPosition
          event.preventDefault()
      vm.element.on 'mousedown', (event) ->
        vm.drag.x = event.pageX
        vm.drag.y = event.pageY
        vm.drag.state = true
      vm.element.on 'mouseup', ->
        vm.drag.state = false
      vm.element.on 'mousemove', (event) =>
        if vm.drag.state
          vm.delta.x = event.pageX - vm.drag.x
          vm.delta.y = event.pageY - vm.drag.y
          vm.drag.x = event.pageX
          vm.drag.y = event.pageY
          @changeCenter vm.uuid, -vm.delta.x, vm.delta.y, 1

    add = (type, id, vm) ->
      if not pz.paperScopes[id]? then pz.paperScopes[id] = {}
      pz.paperScopes[id][type] = vm
      pz.paperScopes[id].active = true

    activate = (id) ->
      pz.paperScopes[id].active = true

    reset = (id) ->
      pz.paperScopes[id].active = false

    changeZoom = (id, deltaY, viewPosition) ->
      calcNewZoom = (oldZoom, delta, c, p) ->
        factor = 1.01 * pz.direction
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

      if pz.paperScopes[id].active and pz.paperScopes[id]['input']?
        paperInput = pz.paperScopes[id]['input']
        [newZoom, offset] = calcNewZoom paperInput.view.zoom, deltaY, paperInput.view.center, viewPosition
        paperInput.view.zoom = newZoom
        paperInput.view.center = [paperInput.view.center.x + offset[0], paperInput.view.center.y + offset[1]]
      if pz.paperScopes[id].active and pz.paperScopes[id]['output']?
        outputPaper = pz.paperScopes[id]['output']
        [newZoom, offset] = calcNewZoom outputPaper.view.zoom, deltaY, outputPaper.view.center, viewPosition
        outputPaper.view.zoom = newZoom
        outputPaper.view.center = [outputPaper.view.center.x + offset[0], outputPaper.view.center.y + offset[1]]

    changeCenter = (id, deltaX, deltaY, deltaFactor) ->
      calcNewCenter = (oldCenter, deltaX, deltaY, factor) ->
        offset = [deltaX * factor * pz.direction, -deltaY * factor * pz.direction]
        newCenter = [oldCenter.x + offset[0], oldCenter.y + offset[1]]
        newCenter

      if pz.paperScopes[id].active and pz.paperScopes[id]['input']?
        inputPaper = pz.paperScopes[id]['input']
        inputPaper.view.center = calcNewCenter inputPaper.view.center, deltaX, deltaY, deltaFactor
      if pz.paperScopes[id].active and pz.paperScopes[id]['output']?
        outputPaper = pz.paperScopes[id]['output']
        outputPaper.view.center = calcNewCenter outputPaper.view.center, deltaX, deltaY, deltaFactor

    factory()

  angular.module('app.results')
    .factory 'diaPanAndZoomManager', diaPanAndZoomManager
