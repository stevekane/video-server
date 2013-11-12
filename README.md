# Rails Template

### Skypager

Skypager is a Rails Engine based CMS.  

To initialize for the first time:

```
bundle exec rake skypager:initialize
```

### Custom Gems.

This project is currently dependent on the `datapimp/smooth` and
`datapimp/skypager` repositories.  These may be private.  You are
probably a collaborator on them.

You will need to clone them to your local machine, and then use the
bundler local config option:

```bash
bundle config local.smooth-io /Users/jonathan/Projects/smooth
bundle config local.skypager /Users/jonathan/Projects/skypager
```

### Core Concepts: API Controller

#### RSpec API Documentation

The RSpec API Documentation gem allows us to write tests which serve a
dual purpose of acting as documentation, and automated integration tests
of the various API controllers.

#### FilterContext

The `FilterContext` class can be subclassed, and is a good place to
capture custom query logic.  The `FilterContext` encapsulates the query
parameters, the resource that is being queried, and the current user
doing the querying.

Any Controller classes which inherit from `ApiController` will have free
index and show actions which automatically use the `FilterContext`.

By including the `FilterContext::Delegator` class in your `ActiveRecord`
models, you will automatically get a query class method which creates an
instance of the `FilterContext` and returns the results.

#### Jbuilder for views

Jbuilder views come with built in support for Rails russian doll style
caching, based on the max updated timestamp.  This, combined with their
very easy syntax for describing custom JSON responses, makes it a
compelling choice.

#### Mutations

To process requests which intend to mutate the data store, I use the
`mutations` gem.

The files in the `app/mutations` folder follow a naming convention based
on the RESTful endpoint.  For example, given the following controller:

```ruby
class ProjectsController < ApiController
end
```

the `create`, `update`, and `destroy` methods will all be routed to
matching classes like such:

```ruby
class CreateProject < Mutations::Command
  required do
    model :user
    hash :project do
      string :name
    end
  end

  def execute
    user.projects.create(name: project['name'])  
  end
end
```

This pattern eliminates the need for most controller boilerplate in
Rails.
