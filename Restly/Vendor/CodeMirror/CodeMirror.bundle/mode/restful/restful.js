(function(mod) {
  if (typeof exports == "object" && typeof module == "object") // CommonJS
    mod(require("../../lib/codemirror"));
  else if (typeof define == "function" && define.amd) // AMD
    define(["../../lib/codemirror"], mod);
  else // Plain browser env
    mod(CodeMirror);
})(function(CodeMirror) {
"use strict";

var restfulMode = CodeMirror.defineMode("restful", function (config) {

  var methods = {
    "GET": true, "PUT": true, "POST": true, "PATCH": true, "DELETE": true, "HEAD": true, "OPTIONS": true,
    "TRACE": true, "CONNECT": true
  };

  function tokenBase(stream, state) {
    var ch = stream.next();

    // JSON.
    if (state.startOfLine && (ch == "{" || ch == "[")) {
      var mode = CodeMirror.getMode({json: true}, "javascript")
      state.token = function (stream, state) {
        // Check for closing brace.
        var nextChar = stream.peek();
        if (stream.sol() && (nextChar == "}" || nextChar == "]")) {
          state.token = tokenBase;
          stream.next();
          return "comment";
        }
        var ch = stream.next();
        return state.localMode.token(stream, state.localState);
      }
      state.localMode = mode;
      state.localState = CodeMirror.startState(mode);
      return "comment";
    }

    // Methods.
    stream.eatWhile(/[\w]/);
    var cur = stream.current();
    if (methods.propertyIsEnumerable(cur)) {
     return "keyword";
    }

    return null;
  }

  return {
    startState: function() {
      return {
        token: tokenBase,
        localMode: null,
        localState: null,
        startOfLine: true
      }
    },

    copyState: function (state) {
      console.log('COPY STATE!');
      var local;
      if (state.localState) {
        local = CodeMirror.copyState(state.localMode, state.localState);
      }
      return {
        token: state.token,
        localMode: state.localMode,
        localState: local,
      };
    },

    token: function (stream, state) {
      state.startOfLine = stream.sol();
      return state.token(stream, state);
    }
  };
});

CodeMirror.defineMIME("text/restful", "restful");

});
