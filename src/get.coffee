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
      checkExistence current
    result = current[last]
    checkExistence result
    YAML.write result
else
  console.error "yaml get: insufficient arguments"
  console.error "yaml get <path> <reference> [--string]"
  process.exit -1

checkExistence = (key) ->
  if typeof key == 'undefined'
    console.error "Unable to get key #{reference}"
    process.exit 1
