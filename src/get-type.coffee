{call, isDefined, isObject, isArray} = require "fairmont"
YAML = require "./yaml"

[path, reference, extra] = process.argv[2..]

if extra is "--string" then schema = "failsafe" else schema = undefined

if path? && reference?
  call ->
    root = current = yield YAML.read path, schema
    [keys..., last] = reference.split "."
    for key in keys
      current = current[key]
    result = current[last]
    if typeof result is 'undefined'
      console.error "Unable to get type of key #{reference}"
      process.exit 1
    switch typeof result
      when 'boolean' then console.log 'bool'
      when 'string' then console.log 'str'
      when 'number'
        if result % 1 == 0 then console.log 'int'
        else console.log 'float'
      when 'object'
        if Array.isArray result then console.log 'seq'
        else console.log 'map'
      else console.log typeof result
else
  console.error "yaml get: insufficient arguments"
  console.error "yaml get <path> <reference> [--string]"
  process.exit -1
