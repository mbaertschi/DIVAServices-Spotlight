do ->
  'use strict'

  navGroup = ->

    directive = ->
      restrict: 'AE'
      transclude: true
      replace: true
      scope:
        icon: '@'
        title: '@'
        iconCaption: '@'
        active: '=?'
      template: """
        <li ui-sref-active='open'>
          <a href=''>
            <i ng-if='hasIcon' class='fa fa-lg fa-fw fa-{{ icon }}'>
              <em data-ng-if='hasIconCaption'>{{ iconCaption }}</em>
            </i>
            <span class='menu-item-parent'>{{ title }}</span>
          </a>
          <ul ng-transclude></ul>
        </li>
      """
      controller: 'NavGroupController'

    directive()

  angular.module('app.widgets')
    .directive 'navGroup', navGroup
