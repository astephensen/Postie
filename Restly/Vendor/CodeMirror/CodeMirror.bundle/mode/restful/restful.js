(function(mod) {
  if (typeof exports == "object" && typeof module == "object") // CommonJS
    mod(require("../../lib/codemirror"));
  else if (typeof define == "function" && define.amd) // AMD
    define(["../../lib/codemirror"], mod);
  else // Plain browser env
    mod(CodeMirror);
})(function(CodeMirror) {
"use strict";

CodeMirror.defineMode("restful", function() {

  function words(str) {
    var obj = {}, words = str.split(" ");
    for (var i = 0; i < words.length; ++i) obj[words[i]] = true;
    return obj;
  }

  var requestMethods = words("GET PUT POST PATCH DELETE HEAD OPTIONS TRACE CONNECT");

  function tokenBase(stream, state) {
    var ch = stream.next();

    // Comment.
    if (ch == "/") {
      if (stream.eat("*")) {
        state.tokenize = tokenComment;
        return tokenComment(stream, state);
      }
    }

    // Whitespace.
    stream.eatWhile(/[\w\$_]/);
    var cur = stream.current();

    // Request Methods.
    if (requestMethods.propertyIsEnumerable(cur)) {
      stream.skipToEnd();
      return "keyword";
    }

    // Something Else?
    else if (ch == ":") {
      stream.skipToEnd();
      return "string";
    }

    return "text";
  }

  function tokenComment(stream, state) {
    var maybeEnd = false, ch;
    while (ch = stream.next()) {
      if (ch == "/" && maybeEnd) {
        state.tokenize = tokenBase;
        break;
      }
      maybeEnd = (ch == "*");
    }
    return "comment";
  }

  return {
    startState: function() {
      return {tokenize: null};
    },

    token: function(stream, state) {
      if (stream.eatSpace()) return null;
      var style = (state.tokenize || tokenBase)(stream, state);
      if (style == "comment" || style == "meta") return style;
      return style;
    },

    electricChars: "{}"
  }
});

CodeMirror.defineMIME("text/x-restful", "restful");

});
