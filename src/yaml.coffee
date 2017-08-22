{async, read, isObject, isArray} = require "fairmont"
YAML = require "js-yaml"
errors = require "./errors"

module.exports =

  read: async (_path, schema) ->

    path = if _path == "-" then process.stdin else _path
    yamlSchema = YAML.DEFAULT_SAFE_SCHEMA
    if schema is "failsafe" then yamlSchema = YAML.FAILSAFE_SCHEMA

    try
      yaml = yield read path
    catch error
      errors.readingPath error, path

    try
      data = YAML.safeLoad yaml, schema: yamlSchema
    catch error
      errors.parsingYAML error

    data

  write: (data) ->

    result =
      if data?
        if (isObject data)
          try
            YAML.safeDump data
              .slice 0, -1
          catch error
            errors.formatYAML error
        else if (isArray data)
          data.join "\n"
        else
          data.toString()
      else
        ""

    console.log result
