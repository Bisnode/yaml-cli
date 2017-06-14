{call} = require "fairmont"
YAML = require "./yaml"

[path, reference, value...] = process.argv[2..]

if path? && reference? && value?
  call ->
    root = current = yield YAML.read path
    [keys..., last] = reference.split "."
    for key in keys
      if typeof current[key] == 'undefined'
        current[key] = {}
      current = current[key]
    if Array.isArray(current[last])
      current[last].push(value.join(" "))
    else
      current[last] = value.join(" ")
    YAML.write root
else
  console.error "yaml set: insufficient arguments"
  console.error "yaml set <path> <reference> <value>"
  process.exit -1
