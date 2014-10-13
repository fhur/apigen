apigen (alpha)
==============

Generate api clients by documenting you api implementation. `apigen` is
a simple DSL for documenting your API. After documenting, `apigen` can
understand the DSL and generate clients for your API (so you don't have
to). There are several `apigen` generators for mayor languages/frameworks.

What is apigen?
===============

Is as simple as this:
1. Document your API
```ruby
# Finds a user given the user's id
# returns :404 if the user is not found
# get /users/{user_id}/show
# @path {int} user_id the user's id
def find_user_by_id
  user = User.find(params[:id])
  if user
    respond_with :200, user
  else
    respond_with :404, "User not found"
  end
end
```

Language Spec
=============

### How to specifying the method and url
To specify the method and url use the following syntax `{method_name} {url}`. The following methods
are supported: get, post, put, delete (head, options, patch to come)
Example: A simple get request
```ruby
# get /users
def index
  User.all
end
```

### Path parameters
Path parameters can be specified using sinatra/rails syntax `{param_name}`.
Example:
```ruby
# delete /users/{user_id}
def delete_by_id
  # method implementation
end
```

Example: specifying several params
```ruby
# get /users/{user_id}/friends/{friend_id}
def find_friend
  # method implementation
end
```

### Query Parameters
Query parameters can be specified using the following syntax `@query
{type} name description` where
1. `type` is one of `string`, `int`, `boolean` or `float`. The type is
   optional, `string` is the default type.
2. `name` is the name of the parameter, any alphanumeric string starting
   with a letter (convention is to use `lowercase_underscored` names)
3. `description` is a string that describes the attribute.

Example:
```ruby
# get /users
# @query {string} name The user's name
def find_users_by_name
```

### Headers
Headers can be specified per method using the following syntax `@header name value`
Example:
```ruby
# get /users
# @header Content-Type application/json
def users
```

Config File
===========
The Config file specifies all the configuration needed to load Apigen
with the generators you wish to use.

The structure of the file is as follows

Example:
This config file example takes one input file and applies two
generators, apigen-ruby and apigen-python.

You can specify any number of generators.
The opts parameter is optional, it is passed on to the generator,
different genrators may require that you pass different options.

```json
input: "~/apps/my_rails_app/app/controllers/users_controller.rb",
generators: [
  {
    require: "apigen-ruby",
    out:  "~/apps/gems/apigen_ruby/lib/users_api.rb",
    opts : {
      name: "UsersApi"
    }
  },
  {
    require: "apigen-python"
    out: "~/apps/pips/apigen_py/users_api.py",
    opts : {}
  }
]
```

== Contributing to apigen
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

