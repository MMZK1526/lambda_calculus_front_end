import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';

/// File upload/download utilities.
class FileIO {
  /// Save a [Uint8List] as a file with the given name.
  static void saveFromBytes(String name, Uint8List bytes) {
    final url = html.Url.createObjectUrlFromBlob(
      html.Blob([bytes]),
    );

    // Create an anchor element to download the file.
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = name;
    html.document.body?.children.add(anchor);

    anchor.click(); // Download the file by clicking the anchor.

    // Remove the anchor from the DOM.
    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }

  /// Save a [String] as a file with the given name.
  static void saveFromString(String name, String content) {
    final url = html.Url.createObjectUrlFromBlob(
      html.Blob([utf8.encode(content)]),
    );

    // Create an anchor element to download the file.
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = name;
    html.document.body?.children.add(anchor);

    anchor.click(); // Download the file by clicking the anchor.

    // Remove the anchor from the DOM.
    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }
}
