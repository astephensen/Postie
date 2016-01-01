window.editor = CodeMirror(document.body, {
  lineNumbers: true,
  styleActiveLine: true,
  matchBrackets: true,
  viewportMargin: Infinity
});

window.editor.on('change', function(instance, change) {
  window.webkit.messageHandlers.notification.postMessage({
    event: 'change'
  });
});

window.onload = function () {
  window.webkit.messageHandlers.notification.postMessage({
    event: 'loaded'
  });
};
