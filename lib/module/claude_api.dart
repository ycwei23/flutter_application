import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<String> generateText(String prompt) async {
  String url = 'https://api.anthropic.com/v1/messages';
  var response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'anthropic-version': '2023-06-01',
      'x-api-key': dotenv.get("CLAUDE3_API_KEY")
    },
    body: jsonEncode({
      'model': 'claude-3-sonnet-20240229',
      "system": "你是一個專業且富有同理心的心理諮商師。只能使用英文或是繁體中文回答問題。",
      "messages": [
        {"role": "user",
          "content": [
            {
              "type": "text",
              "text": prompt
            }
          ]
        }
      ],
      "max_tokens": 500,
      "temperature": 0.5
    }),
  );

  //Convert Unicode
  Map<String, dynamic> decodedJson = jsonDecode(response.body);
  String unicodeString = decodedJson["content"][0]["text"];
  String decodedString = utf8.decode(unicodeString.runes.toList());
  return decodedString;
}