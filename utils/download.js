url = WScript.Arguments(0);
outfile = WScript.Arguments(1);

try {
  request = new ActiveXObject("WinHttp.WinHttpRequest.5.1");
} catch (err) {
  request = new ActiveXObject("Microsoft.XMLHTTP");
}

request.Open("GET", url, /*async*/false);
request.Send();

try {
  StreamType = {Binary: 1, Text: 2};
  bin_stream = new ActiveXObject("ADODB.Stream");
  bin_stream.Type = StreamType.Binary;
  bin_stream.Open();
  bin_stream.Write(request.ResponseBody);
  bin_stream.SaveToFile(outfile);
  bin_stream.Close();
} catch (err) {
  // TODO: use `tb` to write response bytes.
  throw err;
}
