window.editor = CodeMirror.fromTextArea(document.getElementById("code"), {
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

window.editor.on('cursorActivity', function(instance) {
  window.webkit.messageHandlers.notification.postMessage({
    event: 'cursor-moved'
  });
});

window.onload = function () {
  window.webkit.messageHandlers.notification.postMessage({
    event: 'loaded'
  });
};
