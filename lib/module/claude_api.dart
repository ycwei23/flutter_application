import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<String> generateText(List<Map<String, dynamic>> messageHistory) async {

  String url = 'https://api.anthropic.com/v1/messages';
  var response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'anthropic-version': '2023-06-01',
      'x-api-key': dotenv.get("CLAUDE3_API_KEY")
    },
    body: jsonEncode({
      'model': 'claude-3-opus-20240229',
      "system": """
      你是一個專業且富有同理心的心理諮商師。只能使用英文或是繁體中文回答問題。
      絕對要遵守以下諮商要點: {
      1. 同理心: 辨識情緒, 簡述語意。
      2. 尊重: 不批判, 不否認, 保持中立態度。
      3. 真誠: 真心地表示關心。
      4. 助人過程的目的不在於幫他解決問題，而是讓他自己幫助自己。
      5. 幫助案主自我探索、自我了解。
      6. 幫助案主從另外一個觀點來看待自己。
      7. 幫助案主自己採取行動解決問題, 例如:改變解決問題的態度。
      8. 要用正常人類對話的方式，漸進式的問答，一次不回答不能超過50個字。
      }
      """,
      "messages": messageHistory,
      "max_tokens": 300,
      "temperature": 0.5
    }),
  );

  //Convert Unicode
  Map<String, dynamic> decodedJson = jsonDecode(response.body);
  //print(decodedJson);
  String unicodeString = decodedJson["content"][0]["text"];
  String decodedString = utf8.decode(unicodeString.runes.toList());

  return decodedString;
}