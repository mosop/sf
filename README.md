# Sf (Successes and Failures)

A tiny Crystal library for managing the object status.

[![Build Status](https://travis-ci.org/mosop/sf.svg?branch=master)](https://travis-ci.org/mosop/sf)

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  sf:
    github: mosop/sf
```

<a name="code_samples"></a>

## Code Samples

### Storing Statuses

```crystal
class IsMosop
  extend Sf::AsStatusOwner

  status :success
  status :failure

  getter name : String

  def initialize(@name : String)
  end

  def validate
    if @name == "mosop"
      success!
    else
      failure!
    end
  end
end

mosops = IsMosop::Statuses.new
%w(mosop mosop mosop usop).each do |name|
  mosops.continue do
    IsMosop.new(name).validate
  end
end

mosops[0].status.name # "success"
mosops[1].status.name # "success"
mosops[2].status.name # "success"
mosops[3].status.name # "failure"
mosops[0].name # "mosop"
mosops[1].name # "mosop"
mosops[2].name # "mosop"
mosops[3].name # "usop"
mosops.success[0].name # "mosop"
mosops.success[1].name # "mosop"
mosops.success[2].name # "mosop"
mosops.failure[0].name # "usop"
mosops.has_success? # true
mosops.has_failure? # true
```

## Usage

```crystal
require "sf"
```

and see:

* [Code Samples](#code_samples)
