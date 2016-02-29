// Generated by CoffeeScript 1.10.0
(function() {
  var YAML, _query, async, get, isArray, isObject, path, query, read, ref, ref1, set, value,
    slice = [].slice;

  ref = process.argv.slice(2), path = ref[0], query = ref[1], value = ref[2];

  if ((path != null) && (query != null)) {
    _query({
      path: path,
      query: query,
      value: value
    }).then(function(result) {
      return console.log(result);
    });
  } else {
    console.error("yaml: insufficient arguments");
    console.error("yaml <path> <reference> <value>");
    process.exit(-1);
  }

  ref1 = require("fairmont"), async = ref1.async, read = ref1.read, isObject = ref1.isObject, isArray = ref1.isArray;

  YAML = require("js-yaml");

  get = function(object, key) {
    var index, match, ref2;
    if ((match = key.match(/^([^\[]+)\[(\d+)\]$/)) != null) {
      ref2 = match.slice(1), key = ref2[0], index = ref2[1];
      return object[key][index];
    } else {
      return object[key];
    }
  };

  set = function(object, key, value) {
    var index, match, ref2;
    if ((match = key.match(/^([^\[]+)\[(\d+)\]$/)) != null) {
      ref2 = match.slice(1), key = ref2[0], index = ref2[1];
      return object[key][index] = value;
    } else {
      return object[key] = value;
    }
  };

  _query = async(function*(arg) {
    var current, i, j, key, keys, last, len, path, query, ref2, result, root, value;
    path = arg.path, query = arg.query, value = arg.value;
    root = current = YAML.safeLoad((yield read(path)));
    ref2 = query.split("."), keys = 2 <= ref2.length ? slice.call(ref2, 0, i = ref2.length - 1) : (i = 0, []), last = ref2[i++];
    for (j = 0, len = keys.length; j < len; j++) {
      key = keys[j];
      current = get(current, key);
    }
    if (value != null) {
      set(current, last, value);
      return YAML.safeDump(root);
    } else {
      result = get(current, last);
      if ((isObject(result)) || (isArray(result))) {
        return YAML.safeDump(result);
      } else {
        return result;
      }
    }
  });

  module.exports = _query;

}).call(this);