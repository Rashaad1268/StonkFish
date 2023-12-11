import './env.dart';
import 'package:engine/engine.dart';
import 'package:nyxx/nyxx.dart';

var board = Board.startingPosition();
var useUnicodeCharacters = true;
var fillEmptySquares = true;

void main() {
  initAttacks();

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
          "```${board.formatBoard(side: Side.white, useUnicodeCharacters: useUnicodeCharacters, fillEmptySquares: fillEmptySquares)}```"));
    } else if (content.startsWith("!move")) {
      final move = UCIParser.parseMove(board, content.split(" ")[1]);

      if (move == null) {
        await event.message.channel
            .sendMessage(MessageBuilder.content("Invalid move bruh"));
        return;
      }
      final engine = Engine(board);

      try {
        board.makeMove(move);
        engine.searchPosition(4);

        if (board.generateLegalMoves().isNotEmpty && engine.bestMove != null) {
          board.makeMove(engine.bestMove!);
        }
      } catch (error) {
        if (error is ArgumentError) {
          await event.message.channel
              .sendMessage(MessageBuilder.content(error.message));
        }
      }

      await event.message.channel.sendMessage(MessageBuilder.content(
          "```${board.formatBoard(side: Side.white, useUnicodeCharacters: useUnicodeCharacters, fillEmptySquares: fillEmptySquares)}```"));
    } else if (content.startsWith("!unicode")) {
      useUnicodeCharacters = !useUnicodeCharacters;

      await event.message.channel.sendMessage(MessageBuilder.content(
          "```${board.formatBoard(side: Side.white, useUnicodeCharacters: useUnicodeCharacters, fillEmptySquares: fillEmptySquares)}```"));
    } else if (content.startsWith("!fillempty")) {
      fillEmptySquares = !fillEmptySquares;

      await event.message.channel.sendMessage(MessageBuilder.content(
          "```${board.formatBoard(side: Side.white, useUnicodeCharacters: useUnicodeCharacters, fillEmptySquares: fillEmptySquares)}```"));
    } else if (content.startsWith("!reset")) {
      board = Board.startingPosition();
    }
  });
}
