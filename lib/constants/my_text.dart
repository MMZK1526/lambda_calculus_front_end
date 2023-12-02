enum MyText {
  title,
  introTab,
  evalTab,
  typeTab,

  typeInfer,
  upload,
  download,
  reset,
  confirm,
  help,
  evaluate,
  resetInputs,
  showFirst,
  steps,

  fullReduction,
  callByName,
  callByValue,

  responseMarkdown,
}

extension MyTextExtension on MyText {
  String get text {
    switch (this) {
      case MyText.title:
        return 'Lambda Calculus Simulator';
      case MyText.introTab:
        return 'Introduction';
      case MyText.typeTab:
        return 'Type Inference';
      case MyText.evalTab:
        return 'Evaluation';

      case MyText.typeInfer:
        return 'Infer Type';
      case MyText.upload:
        return 'Upload';
      case MyText.download:
        return 'Download';
      case MyText.reset:
        return 'Reset';
      case MyText.confirm:
        return 'Confirm';
      case MyText.help:
        return 'Help';
      case MyText.evaluate:
        return 'Evaluate';
      case MyText.resetInputs:
        return 'Start from R0';
      case MyText.showFirst:
        return 'Show First';
      case MyText.steps:
        return 'Steps';

      case MyText.fullReduction:
        return 'Full Reduction';
      case MyText.callByName:
        return 'Call by Name';
      case MyText.callByValue:
        return 'Call by Value';

      case MyText.responseMarkdown:
        return 'response.md';
      default:
        return 'Unknown';
    }
  }
}
