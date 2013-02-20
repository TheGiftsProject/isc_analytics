# ISC Analytics [![Build Status](https://travis-ci.org/TheGiftsProject/isc_analytics.png?branch=master)](https://travis-ci.org/TheGiftsProject/isc_analytics)
A simple client-side & server-side analytics library for Rails. It currently supports only KISSmetrics for more advanced
analytics features (trackEvent / setProperties) and Google Analytics just for tracking pageviews.

## Installation

Just add the `isc_analytics` gem into your Gemfile

```ruby
gem 'isc_analytics'
```

Then add an initializer file in your `config/initializers` directory containing the initial config of your analytics.

## Configuration

ISC Analytics currently supports the following configuration options:


```ruby
IscAnalytics.config.providers = ANALYTIC_PROVIDERS # a providers object (preferably using ConfigReader)
IscAnalytics.config.namespace = 'App' # an alias which will gain all the analytics behaviour in the clientside.
```

We highly recommend you to use our other gem
[ConfigReader](https://github.com/TheGiftsProject/configreader) to load the analytics_providers data from YML.

The providers hash / EnvConfigReader should contain the following sub keys:

```yml
kissmetrics:
  key: "KEY"
  dryrun: false # see http://support.kissmetrics.com/apis/ruby for more details
google_analytics:
  key: "KEY"
ipinfodb:
  key: "KEY"
optimizely:
  key: "KEY"
```

Currently only the KISSMetrics and Google Analytics keys are mandatory although the gem isn't fully tested without the ipinfodb and optimizely options.

## Usage

The basic way to use isc_analytics is to simply follow the **Getting Started** step, which will guide you on how
to enable simple visitor tracking in KISSmetrics and Google Analytics

If you need more, there's a client-side & server-side tracking analytics API. (Enabled just for KISSmetrics)

## Getting Started

After you've finished configuring isc_analytics, do the following in order to include it in your app:

#### ApplicationController

Add the following line inside your ApplicationController:

```ruby
include IscAnalytics::ControllerSupport
```
This will enable you to use the Analytics object from your controllers and views.

#### Application Layout

Add the following line to your main application layout, under the HTML head tag.

```erb
<%= add_analytics %>
```

This will embed all the needed HTML for the analytics to run (including the code for all the required services).

## Client Side

Once you've included isc_analytics as we've explained above, you will have access to the following client-side API:

```js
Analytics.trackEvent(<event name>, [<properties_hash>]);
Analytics.setProperty(<property_key>, <property_value>);
Analytics.setProperties(<properties_hash>);
Analytics.identify(<identity>, [<properties_hash>]);
Analytics.clearIdentity()
```

### Namespacing

If you've configured a Namespace in the initializer, then we'll automatically alias all the functions to the Namespace of your choice for easy access.
For example if I set my namespace as `App` then I'll be able to access the trackEvent function from `App.trackEvent`

## Server Side

All the **client side event tracking is available from the server side** as well. Once you've included isc_analytics you can access the `analytics` object which will have methods identical to the client-side analytics methods.
For example you can call `analytics.trackEvent('user-visit')` and it will be persisted in the current user session and flushed into the user's browser next time he visits a page (via add_analytics). This mechanism is similar in behaviour to Rails' flash object.

There is also support for purely server-side analytics (currently only for KISSMetrics) that send the data directly to KM, without going through the user's browser.
It is accessible through `IscAnalytics.server` with the following interface:
```ruby
IscAnalytics.server.track_event(identity, name, properties={})
IscAnalytics.server.set_properties(identity, properties)
IscAnalytics.server.alias(identity, new_identity)
```

### Opt out

One very cool feature **isc_analytics** has is a built in opt_out feature to be used when testing the system or when doing admin actions.
To enter opt_out for the current browsing session just call `analytics.opt_out!` from the controller.
Once opt-ted out, a dummy implementation of the analytics js will be sent to the client meaning that no calls will actually be sent to the analytics service.

## Notes
### KISSMetrics URL api
After including IscAnalytics::ControllerSupport into your controller, you can override the [KISSMetrics URL api](http://support.kissmetrics.com/apis/url) by adding `before_filter keep_km_url_event` to your controller.
This records the url events manually as soon as the request comes in and allows you to use `redirect_to` without worrying about losing analytics data.
If you intend to use this, you should disable the URL api in your kissmetrics settings in order to avoid duplicate events.
