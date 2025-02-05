import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';
import 'package:usay/Components/ai_msg_card.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:usay/Components/dialogs.dart';
import 'package:usay/models/messages.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({super.key,required this.title, required this.controller});
  final String title;
  final MotionTabBarController controller;

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  //  final _c = ChatController();
  final _textC = TextEditingController();
  final _scrollC = ScrollController();

  final _list = <AiMessage>[
    AiMessage(msg: 'Hello, How can I help you?', msgType: MessageType.bot)
  ];

  Future<void> _askQuestion() async {
    _textC.text = _textC.text.trim();

    if (_textC.text.isNotEmpty) {
      //user
      _list.add(AiMessage(msg: _textC.text, msgType: MessageType.user));
      _list.add(AiMessage(msg: '', msgType: MessageType.bot));
      setState(() {});

      _scrollDown();

      final res = await _getAnswer(_textC.text);

      //ai bot
      _list.removeLast();
      _list.add(AiMessage(msg: res, msgType: MessageType.bot));
      _scrollDown();

      setState(() {});

      _textC.text = '';
      return;
    }

    Dialogs.showSnackBar(context, 'Ask Something!');
  }

  //for moving to end message
  void _scrollDown() {
    _scrollC.animateTo(_scrollC.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }

  //get answer from google gemini ai
  Future<String> _getAnswer(final String question) async {
    try {
      //TODO - Google Gemini API Key - https://aistudio.google.com/app/apikey

      const apiKey = '';

      log('api key: $apiKey');

      if (apiKey.isEmpty) {
        return 'Gemini API Key required \nChange in Ai Screen Codes';
      }

      final model = GenerativeModel(
        model: 'gemini-1.5-flash-latest',
        apiKey: apiKey,
      );

      final content = [Content.text(question)];
      final res = await model.generateContent(content, safetySettings: [
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.none),
      ]);

      log('res: ${res.text}');

      return res.text!.trim();
    } catch (e) {
      log('getAnswerGeminiE: $e');
      return 'Something went wrong (Try again in sometime)';
    }
  }

  @override
  void dispose() {
    _textC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      //app bar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Your AI Assistant',style: TextStyle(color: Colors.white),),
      ),

      //send message field & btn
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8 ,vertical: 10),
        child: Row(children: [
          //text input field
          Expanded(
              child: TextFormField(
                controller: _textC,
                textAlign: TextAlign.center,
                onTapOutside: (e) => FocusScope.of(context).unfocus(),
                decoration: InputDecoration(
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                    filled: true,
                     isDense: true,
                    hintText: 'Ask me anything you want...',
                    hintStyle: const TextStyle(fontSize: 14),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)))),
              )),

          //for adding some space
          const SizedBox(width: 8),

          //send button
          ElevatedButton(
              onPressed:
                _askQuestion,
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                elevation: 10,
                padding: const EdgeInsets.all(0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(mq.height * 0.07),
                child: Image.asset(
                  'Images/send.webp',
                  fit: BoxFit.cover,
                  height: mq.height * 0.07,
                  width: mq.height * 0.07,
                ),
              )),
        ]),
      ),

      //body
      body: ListView(
        physics: const BouncingScrollPhysics(),
        controller: _scrollC,
        padding: EdgeInsets.only(top: mq.height * .02, bottom: mq.height * .1),
        children: _list.map((e) => AiMessageCard(message: e)).toList(),
      ),
    );
  }
}