import 'dart:async';
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:dartz/dartz.dart' as fn;

/// File upload/download utilities.
class FileIO {
  /// Upload a file from the user's computer, returning the content as a
  /// [String].
  ///
  /// If [maxLength] is provided, any file larger than that will be rejected.
  static Future<String> uploadToString({int? maxLength}) {
    // Use a completer to return the result of the file upload, turning the
    // callback-based API into a Future-based API.
    final completer = Completer<String>();
    final input = html.FileUploadInputElement();
    input.click(); // Open the file upload dialog.

    // Listen for the file to be selected.
    input.onChange.listen((event) {
      final files = input.files;
      if (files == null || files.isEmpty) {
        return;
      }

      final file = files[0];
      final reader = html.FileReader();
      reader.readAsArrayBuffer(file);
      reader.onLoadEnd.listen((event) {
        final result = reader.result;
        if (result is Uint8List) {
          try {
            // Decode the file content as a string.
            final content = utf8.decode(result, allowMalformed: false);

            // Check if the file is too large.
            if (maxLength != null && content.length > maxLength) {
              completer.completeError(
                'The content is too large (max length: $maxLength)!',
              );
            } else {
              completer.complete(content);
            }
          } catch (e) {
            // The file content is not a valid string.
            completer.completeError(
              'Failed to parse the file content as string!',
            );
          }
        } else {
          completer.completeError('Failed to read the file!');
        }
      });
    });

    return completer.future;
  }

  /// Save several contents as a zip file with the given names.
  static void saveAsZip(
    String zipName,
    List<fn.Tuple2<String, String>> contents, {
    int compressLevel = Deflate.BEST_SPEED,
  }) {
    final encoder = ZipEncoder();
    final archive = Archive();

    // Add each content to the archive.
    for (final content in contents) {
      final encoded = utf8.encode(content.value2);
      ArchiveFile archiveFiles = ArchiveFile.stream(
        content.value1,
        encoded.length,
        InputStream(encoded),
      );
      archive.addFile(archiveFiles);
    }

    final outputStream = OutputStream();
    final bytes = encoder.encode(
      archive,
      level: compressLevel,
      output: outputStream,
    );

    // Save the zip file.
    saveFromBytes(zipName, Uint8List.fromList(bytes!));
  }

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
