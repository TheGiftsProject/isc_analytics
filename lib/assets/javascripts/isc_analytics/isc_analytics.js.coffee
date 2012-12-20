class window.Analytics

# check if the Kissmetrics async queue is loaded
  @isLoaded: ->
    window._kmq?

  ###
  Push a call asynchronously to Kissmetrics API
  @param callData - array to push
  ###
  @push: (callData) ->
    if _.isArray(callData) and @isLoaded()
      _kmq.push callData

  ###
  Track Event
  @param eventName - event name string
  @param properties - JSON with custom data
  ###
  @trackEvent: (eventName, properties) ->
    if @isValid eventName
      properties = properties or {}
      @push ["record", eventName, properties]

  ###
  Set properties
  @param properties - JSON with custom data
  ###
  @setProperties: (properties) ->
    unless _.isEmpty(properties)
      @push ["set", properties]


  ###
  Set a single property
  @param property
  @param value
  ###
  @setProperty: (property, value) ->
    if @isValid property
      properties = {}
      properties[property] = value
      @setProperties properties


  ###
  Identify a user with a unique id
  @param identifier - could be either username or email (currently email)
  @param properties - JSON with custom data
  ###
  @identify: (identifier, properties) ->
    if @isValid identifier
      @push ["identify", identifier]
      @setProperties(properties)


  ###
  Clear the user's identity
  @see http://support.kissmetrics.com/advanced/identity-management
  ###
  @clearIdentity: ->
    @push ["clearIdentity"]


  ###
  alias simply takes two arguments which are the two identities that you need
  to tie together. So if you call alias with the identities bob and bob@bob.com
  KISSmetrics will tie together the two records and will treat the identities bob
  and bob@bob.com as the same person.
  @param name
  ###
  @setAlias: (name, identifier) ->
    if @isValid(identifier) and @isValid(name)
      @push ["alias", name, identifier]

  @isValid: (str)->
    !_.isEmpty(str) and _.isString(str)