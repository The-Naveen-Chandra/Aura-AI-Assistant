import 'package:aura/components/feature_box.dart';
import 'package:aura/services/openai_service.dart';
import 'package:aura/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  String lastWords = '';
  final OpenAIService openAIService = OpenAIService();

  @override
  void initState() {
    super.initState();
    initSpeechToText();
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
    print(lastWords);
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Aura",
        ),
        leading: const Icon(
          Icons.menu,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Virtual assistant image
            Stack(
              children: [
                Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.only(top: 4),
                    // decoration: const BoxDecoration(
                    //   color: Pallete.assistantCircleColor,
                    //   shape: BoxShape.circle,
                    // ),
                  ),
                ),
                Container(
                  height: 104,
                  decoration: const BoxDecoration(
                    // shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/images/meteor-rain.gif",
                      ),
                    ),
                  ),
                )
              ],
            ),
            // chat bubble
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 35).copyWith(
                top: 30,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Pallete.borderColor,
                ),
                borderRadius: BorderRadius.circular(20).copyWith(
                  topLeft: Radius.zero,
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  "Good Morning, what task can I do for you?",
                  style: TextStyle(
                    color: Pallete.mainFontColor,
                    fontSize: 20,
                    fontFamily: 'Cera Pro',
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 10, left: 22),
              child: const Text(
                "Here are a few features",
                style: TextStyle(
                  fontFamily: 'Cera Pro',
                  color: Pallete.mainFontColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // features list
            Column(
              children: const [
                FeatureBox(
                  color: Pallete.firstSuggestionBoxColor,
                  headerText: "ChatGPT",
                  descriptionText:
                      "A smater way to stay organised and informed with ChatGPT.",
                ),
                FeatureBox(
                  color: Pallete.secondSuggestionBoxColor,
                  headerText: "Dell-E",
                  descriptionText:
                      "Get inspired and stay creative with your personal assistant powered by Dell-E.",
                ),
                FeatureBox(
                  color: Pallete.thirdSuggestionBoxColor,
                  headerText: "Smart Voice Assistant",
                  descriptionText:
                      "Get the best of both worlds with a voice assistant powered by Dell-E and ChatGPT.",
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (await speechToText.hasPermission && speechToText.isNotListening) {
            await startListening();
          } else if (speechToText.isListening) {
            final speech = await openAIService.isArtPromptAPI(lastWords);
            print(speech);
            await stopListening();
          } else {
            initSpeechToText();
          }
        },
        child: Icon(
          speechToText.isListening ? Icons.stop : Icons.mic,
        ),
      ),
    );
  }
}
