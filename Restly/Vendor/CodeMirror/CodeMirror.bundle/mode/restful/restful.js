(function(mod) {
  if (typeof exports == "object" && typeof module == "object") // CommonJS
    mod(require("../../lib/codemirror"));
  else if (typeof define == "function" && define.amd) // AMD
    define(["../../lib/codemirror"], mod);
  else // Plain browser env
    mod(CodeMirror);
})(function(CodeMirror) {
"use strict";

  var methodRegex = /(?:GET|PUT|POST|PATCH|DELETE|HEAD|OPTIONS|TRACE|CONNECT)\b/;

  CodeMirror.defineSimpleMode("restful", {
    start: [
      // Methods.
      {
        regex: methodRegex,
        token: "keyword",
        next: "method"
      }
    ],
    // Method state.
    method: [
      {
        regex: /.*/,
        token: "text",
        next: "start"
      }
    ],
    // The meta property contains global information about the mode. It
    // can contain properties like lineComment, which are supported by
    // all modes, and also directives like dontIndentStates, which are
    // specific to simple modes.
    meta: {
      lineComment: "//"
    }
  });

});
