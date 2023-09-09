import 'dart:collection';

import './env.dart';
import 'package:engine/engine.dart';
import 'package:nyxx/nyxx.dart';

var board = Board.startingPosition;
var useUnicodeCharacters = false;
var fillEmptySquares = false;

void main() {
  final bot = NyxxFactory.createNyxxWebsocket(
      token, GatewayIntents.allUnprivileged | GatewayIntents.messageContent)
    ..registerPlugin(Logging()) // Default logging plugin
    ..registerPlugin(
        CliIntegration()) // Cli integration for nyxx allows stopping application via SIGTERM and SIGKILl
    ..registerPlugin(
        IgnoreExceptions()) // Plugin that handles uncaught exceptions that may occur
    ..connect();

  // Listen for message events
  bot.eventsWs.onMessageReceived.listen((event) async {
    final content = event.message.content.toLowerCase();
    if (content.startsWith("!board")) {
      await event.message.channel.sendMessage(MessageBuilder.content(
          "```${board.formatBoard(useUnicodeCharacters: useUnicodeCharacters, fillEmptySquares: fillEmptySquares)}```"));
    } else if (content.startsWith("!move")) {
      final move = content.split(" ")[1];

      if (move == "" || move.length != 4) {
        await event.message.channel
            .sendMessage(MessageBuilder.content("Invalid move bruh"));
        return;
      }

      try {
        board.makeMove(move);
      } catch (error) {
        if (error is ArgumentError) {
          await event.message.channel
              .sendMessage(MessageBuilder.content(error.message));
        }
      }

      await event.message.channel.sendMessage(MessageBuilder.content(
          "```${board.formatBoard(useUnicodeCharacters: useUnicodeCharacters, fillEmptySquares: fillEmptySquares)}```"));
    } else if (content.startsWith("!unicode")) {
      useUnicodeCharacters = !useUnicodeCharacters;
    } else if (content.startsWith("!fillempty")) {
      fillEmptySquares = !fillEmptySquares;
    }
  });
}
