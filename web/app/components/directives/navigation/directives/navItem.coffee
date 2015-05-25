angular.module('app').directive 'navItem', [ ->
  require: [
    '^navigation'
    '^?navGroup'
  ]
  restrict: 'AE'
  controller: 'NavItemController'
  scope:
    title: '@'
    state: '@'
    icon: '@'
    iconCaption: '@'
    href: '@'
    target: '@'
    news: '@'

  transclude: true
  replace: true
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
]
