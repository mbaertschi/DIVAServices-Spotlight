do ->
  'use strict'

  navItem = ->

    directive = ->
      require: [
        '^navigation'
        '^?navGroup'
      ]
      restrict: 'AE'
      transclude: true
      replace: true
      scope:
        title: '@'
        state: '@'
        icon: '@'
        iconCaption: '@'
        href: '@'
        target: '@'
        news: '@'
      template: """
        <li ui-sref-active='active'>
          <a ui-sref='{{ state }}' title='{{ title }}'>
            <i ng-if="hasIcon" class="fa fa-lg fa-fw fa-{{ icon }}"><em ng-if="hasIconCaption"> {{ iconCaption }} </em></i>
            <span ng-class="{'menu-item-parent': !isChild}"> {{ title }} </span>
            <span ng-if="news && news > 0" class="badge pull-right inbox-badge bg-color-yellow">{{ news }}</span>
            <span ng-transclude></span>
          </a>
        </li>
      """
      controller: 'NavItemController'

    directive()

  angular.module('app.widgets')
    .directive 'navItem', navItem
