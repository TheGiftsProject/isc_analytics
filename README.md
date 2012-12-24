# ISC Analytics [![Build Status](https://travis-ci.org/TheGiftsProject/isc_analytics.png?branch=master)](https://travis-ci.org/TheGiftsProject/isc_analytics)
A simple client-side & server-side analytics library for Rails

## Installation 

Just add the `isc_analytics` gem into your Gemfile

```ruby
gem 'isc_analytics'
```

Then create an initializer file in your `config/initialize` directory containing the initial config of your analytics.

## Configuration

ISC Analytics current supports the following configurations:


```ruby
IscAnalytics.config.accounts = ANALYTIC_ACCOUNTS # an accounts objects (preferably using ConfigReader)
IscAnalytics.config.namespace = 'App' # an alias which will gain all the analytics behivour in the clientside.
```

We recommend our other gem [ConfigReader](https://github.com/TheGiftsProject/configreader) to load the analytics_accounts data from a YML.

The analytics accounts should contain the following sub keys:

```yml
kissmetrics_key: "KEY"
google_analytics_key: "KEY"
ipinfodb_key: "KEY"
optimizely_key: "KEY"
``` 

Currently only the KISSMetrics and Google Analytics keys are mandatory although the gem isn't fully tested without the ipinfodb and optimizely options.

## Usage

There are three points of usage for the isc_analytics gem, the first is including and starting to use the gem in your app. The second is Client side analytics events and the third is server side analytics events.

### Including

To include isc_analytics in your app, after you install the gem.
Add the following line inside your ApplicationController:

```ruby
include IscAnalytics::ControllerSupport
```
This will enable you to use the analytics object from your controllers and views.

And the following line to your main application layout

```erb
<%= add_analytics %>
```

This will embed all the needed html for the analytics to run (including the code for all the required services.)

### Client Side

After your install and include the isc_gem you can use the following functions in your client side javascript.

```js
Analytics.trackEvent(<event name>, [<properties_hash>]);
Analytics.setProperty(<property_key>, <property_value>);
Analytics.setProperties(<properties_hash>);
Analytics.identify(<identity>, [<properties_hash>]);
Analytics.clearIdentity()
```

#### Namespacing
The cool thing is that if you configure a Namespace in the configuration then we'll automatically alias all the functions to the Namespace of your choice for easy access.
For example if I set my namespace as `App` then I'll be able to access the trackEvent function from `App.trackEvent`

### Server Side

All the **client side event tracking is available from the server side** as well. Once you inlcude isc_analytics you can access the `analytics` object which will have methods identical to the client-side analytics methods.  
For example you can call `analytics.trackEvent('user-visit')` and it will be persisted in the current user session and flushed into the users browser next time he visits a page (via add_analytics). This mechanism is similar in behaivour to Rails' flash object.
 
### Opt out

One very cool feature **isc_analytics** has is a built in opt_out feature to be used when testing the system or when doing admin actions. 
To enter opt_out for the current browsing session just call `analytics.opt_out!` from the controller.  
Once opt-ted out, a dummy implementation of the analytics js will be sent to the client meaning that no calls will actually be sent to the analytics service.
