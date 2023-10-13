enum MyText {
  title,
  introTab,
  simTab,
  typeTab,

  convert,
  upload,
  download,
  reset,
  confirm,
  help,
  simulate,
  addRegister,
  resetInputs,
  startFromR0,
  showFirst,
  steps,

  connectionErr,
  uploadErr,
  tooManyStepsErr,

  responseJSON,
  responseMarkdown,
  encodeZip,
  decodeZip,
  simlateZip,
}

extension MyTextExtension on MyText {
  String get text {
    switch (this) {
      case MyText.title:
        return 'Register Machine Simulator';
      case MyText.introTab:
        return 'Introduction';
      case MyText.typeTab:
        return 'Type Inference';
      case MyText.simTab:
        return 'Simulation';

      case MyText.convert:
        return 'Convert';
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
      case MyText.simulate:
        return 'Simulate';
      case MyText.addRegister:
        return 'Add Register';
      case MyText.resetInputs:
        return 'Reset Inputs';
      case MyText.startFromR0:
        return 'Start from R0';
      case MyText.showFirst:
        return 'Show First';
      case MyText.steps:
        return 'Steps';

      case MyText.connectionErr:
        return 'Connection Error';
      case MyText.uploadErr:
        return 'Upload Error';
      case MyText.tooManyStepsErr:
        return 'Too Many Steps: The Web APP can show up to 114514 steps. If you want more, please use the Haskell CLI available [here](https://github.com/MMZK1526/Haskell-RM#readme).';
      case MyText.responseJSON:
        return 'response.json';
      case MyText.responseMarkdown:
        return 'response.md';
      case MyText.encodeZip:
        return 'encode.zip';
      case MyText.decodeZip:
        return 'decode.zip';
      case MyText.simlateZip:
        return 'simulate.zip';
      default:
        return 'Unknown';
    }
  }
}
