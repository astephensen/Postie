(function(mod) {
  if (typeof exports == "object" && typeof module == "object") // CommonJS
    mod(require("../../lib/codemirror"));
  else if (typeof define == "function" && define.amd) // AMD
    define(["../../lib/codemirror"], mod);
  else // Plain browser env
    mod(CodeMirror);
})(function(CodeMirror) {
  "use strict";

  CodeMirror.defineSimpleMode("restful-main", {
    start: [
      // Methods.
      {
        regex: /((?:GET|PUT|POST|PATCH|DELETE|HEAD|OPTIONS|TRACE|CONNECT)\b)(.*)/,
        token: [
          'keyword',
          'variable'
        ]
      },
      // Headers.
      {
        regex: /(.*)(:)(.*)/,
        token: [
          'variable-2',
          null,
          'string'
        ]
      },
      // Form Data.
      {
        regex: /(.*)(=)(.*)/,
        token: [
          'variable-3',
          null,
          'string'
        ]
      },
      // Comments.
      {
        regex: /\/\*/,
        token: "comment",
        next: "comment"
      },
      {
        regex: /\/\/.*/,
        token: "comment"
      }
    ],
    // Method state.
    method: [
      {
        regex: /.*/,
        token: 'variable',
        next: 'start'
      }
    ],
    // Comment state.
    comment: [
      {
        regex: /.*?\*\//,
        token: "comment",
        next: "start"
      },
      {
        regex: /.*/,
        token: "comment"
      }
    ]
  });

  CodeMirror.defineMode('restful', function (config) {

    // Stores the default mode that will be used.
    var restfulMode = CodeMirror.getMode(config, {
      name: 'restful-main'
    });

    // Processes restful state.
    function restful(stream, state) {

      // Check for JSON.
      if (stream.sol() && (stream.peek() == '{' || stream.peek() == '[')) {
        var mode = CodeMirror.getMode(config, 'javascript')
        state.token = function (stream, state) {
          // Check for closing brace.
          if (stream.sol() && (stream.peek() == '}' || stream.peek() == ']')) {
            state.token = restful;
            state.localState = state.localMode = null;
            stream.next();
            return null;
          }
          return state.localMode.token(stream, state.localState);
        }
        state.localMode = mode;
        state.localState = CodeMirror.startState(mode);
      }

      var style = restfulMode.token(stream, state.restfulState), modeSpec;
      return style;
    }

    /* ----------------------------------------- */

    return {
      startState: function() {
        var state = restfulMode.startState();
        return {
          token: restful,
          localMode: null,
          localState: null,
          restfulState: state,
          startOfLine: true
        }
      },

      copyState: function (state) {
        var local;
        if (state.localState) {
          local = CodeMirror.copyState(state.localMode, state.localState);
        }
        return {
          token: state.token,
          localMode: state.localMode,
          localState: local,
          restfulState: CodeMirror.copyState(restfulMode, state.restfulState)
        };
      },

      token: function (stream, state) {
        state.startOfLine = stream.sol();
        return state.token(stream, state);
      },

      innerMode: function (state) {
        return {
          state: state.localState || state.restfulState,
          mode: state.localMode || restfulMode
        };
      }
    };
  });

  CodeMirror.defineMIME("text/restful", "restful");

});
