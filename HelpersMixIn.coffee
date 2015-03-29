_ = require('lodash')

HelpersMixIn =
    componentWillMount: ->
      # if there are props not docummented in propTypes, console.warn will be triggered
      props = Object.keys(@props or {})
      propTypes = Object.keys(@propTypes or @constructor.propTypes or {})
      displayName = @displayName or @constructor.displayName
      if not displayName
        console.warn("displayName is not provided in", @)
        displayName = 'UNKNOWN'
      if props.length
        if not propTypes.length
          return console.warn("propTypes are not present in #{ displayName }. Provide propTypes to make debug easier.")
        _.difference(props, propTypes).forEach (key) ->
          console.warn("`#{ key }` propType is not present in #{ displayName }. Provide propTypes to make debug easier.")

    getState: (field) ->
      # summary:
      #            React stores old state when it's not rendered yet.
      #            New one is stored in _pendingState.
      #            This method returns calculated state, even if it's not rendered yet.
      # field: String
      #            State field
      state = this.state
      pendingState = this._pendingState
      if pendingState.hasOwnProperty(field)
        return pendingState[field]
      else if state
        return state[field]

    getClassName: (classNameAddon) ->
      # summary:
      #            getClassName joins all possible className configurations.
      #            - support case when you pass className to custom element
      #            - supports component className
      #            - support custom className defined in component
      # classNameAddon: String / Array / Object
      #            additional className, you may add in render method.
      #
      if _.isArray(classNameAddon)
        classNameAddon = classNameAddon.join(' ')
      else if _.isPlainObject(classNameAddon)
      	classNameAddon = Object.keys(_.pick(classNameAddon, _.identity))

      return "#{classNameAddon} #{this.props.className or ''} #{this.className or ''}"

module.exports = HelpersMixIn
