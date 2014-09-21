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

TODO
====

- Implement `request_params` in Endpoint
- Implement retrofit template
- Implement `response_type` in Endpoint
