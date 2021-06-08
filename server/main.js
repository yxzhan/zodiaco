/**
 * Code adapted from
 * https://www.didierboelens.com/2018/06/web-sockets-build-a-real-time-game/
 */

/**
 * Parameters
 */
var webSocketsServerPort = 23456; // Adapt to the listening port number you want to use
/**
 * Global variables
 */
// websocket and http servers
var webSocketServer = require('websocket').server;
var http = require('http');
const https = require('https');
const fs = require('fs');

const PLAYERSTATES = {
  uninitialized: 0,
  matching: 1,
  matched: 2,
  ready: 3,
  playing: 4,
  waiting: 5,
  over: 6
}

const MESSAGE = {}

// const options = {
//   key: fs.readFileSync('server/cert/key.pem'),
//   cert: fs.readFileSync('server/cert/cert.pem')
// };
/**
 * HTTP server to implement WebSockets
 */
// var server = https.createServer(options, function (request, response) {
//   // Not important for us. We're writing WebSocket server,
//   // not HTTP server
// });

var server = http.createServer(function (request, response) {
  // Not important for us. We're writing WebSocket server,
  // not HTTP server
});
server.listen(webSocketsServerPort, function () {
  console.log((new Date()) + " Server is listening on port " +
    webSocketsServerPort);
});

/**
 * WebSocket server
 */
var wsServer = new webSocketServer({
  // WebSocket server is tied to a HTTP server. WebSocket
  // request is just an enhanced HTTP request. For more info
  // http://tools.ietf.org/html/rfc6455#page-6
  httpServer: server
});

// This callback function is called every time someone
// tries to connect to the WebSocket server
wsServer.on('request', function (request) {
  var connection = request.accept(null, request.origin);

  //
  // New Player has connected.  So let's record its socket
  //
  var player = new Player(request.key, connection);

  //
  // Add the player to the list of all players
  //
  Players.push(player);

  //
  // We need to return the unique id of that player to the player itself
  //
  player.sendMsg({
    action: 'connect',
    data: player.id
  });

  //
  // Inform other player to update online player number
  //
  console.log('Player join, id:', player.id)
  BroadcastPlayersList();

  //
  // Listen to any message sent by that player
  //
  connection.on('message', function (data) {
    //
    // Process the requested action
    //
    var message = JSON.parse(data.utf8Data);
    console.log(message)

    if (message.action != 'join' && player.state == PLAYERSTATES.uninitialized) return
    switch (message.action) {
      //
      // When the user sends the "join" action, he provides a name.
      // Let's record it and as the player has a name, let's
      // broadcast the list of all the players to everyone
      //
      case 'join':
        player.name = message.data;
        player.state = PLAYERSTATES.matching;
        player.sendMsg({
          'action': 'matching_player'
        });
        MatchPlayer();
        break;

      case 'ready':
        player.state = PLAYERSTATES.ready;
        DealCards(player);
        break;
        //
        // When a player resigns, we need to break the relationship
        // between the 2 players and notify the other player
        // that the first one resigned
        //
      case 'resign':
        Players[player.opponentIndex].sendMsg({
          'action': 'resigned'
        });
        player.opponentIndex = null;
        break;

        //
        // A player sends a guess
        //
      case 'play':
        checkGuess(player, message.data)
        break;
        //
        // A player select a opponent's card
        //
      case 'select_card':
        Players[player.opponentIndex].sendMsg({
          'action': 'select_card',
          'data': message.data
        });
        break;
        //
        // A player takes punishment
        //
      case 'punish':
        punish(player, message.data)
        break;
        //
        // A player takes punishment
        //
      case 'skip':
        // punish(player, message.data)

        break;
    }
  });

  // user disconnected
  connection.on('close', function (connection) {
    // We need to remove the corresponding player
    console.log('Player left, id:', player.id)
    Players = Players.filter(function (obj) {
      return obj.id !== player.id;
    });
    BroadcastPlayersList();
  });
});

// -----------------------------------------------------------
// List of all players
// -----------------------------------------------------------
var Players = [];

function Player(id, connection) {
  this.id = id;
  this._connection = connection;
  this.name = "";
  this.opponentIndex = null;
  this.index = Players.length;
  this.state = PLAYERSTATES.uninitialized;
  this.cards = [];
}

Player.prototype = {
  getId: function () {
    return {
      name: this.name,
      id: this.id
    };
  },
  sendMsg: function (msg) {
    this._connection.sendUTF(JSON.stringify(msg))
  },
  setOpponent: function (id) {
    var self = this;
    Players.forEach(function (player, index) {
      if (player.id == id) {
        self.opponentIndex = index;
        Players[index].opponentIndex = self.index;
        return false;
      }
    });
  }
};

// ---------------------------------------------------------
// Routine to broadcast the list of all players to everyone
// ---------------------------------------------------------
function BroadcastPlayersList() {
  Players.forEach(function (player) {
    player.sendMsg({
      'action': 'players_list',
      'data': Players.length
    });
  });
}

// ---------------------------------------------------------
// Match players
// ---------------------------------------------------------
function MatchPlayer() {
  let matchingList = Players.filter(player => player.state === PLAYERSTATES.matching).slice(0, 2)
  if (matchingList.length != 2) return

  let firstPlayer = matchingList[0]
  let secondPlayer = matchingList[1]

  firstPlayer.state = PLAYERSTATES.matched
  secondPlayer.state = PLAYERSTATES.matched

  firstPlayer.setOpponent(secondPlayer.id)
  secondPlayer.setOpponent(firstPlayer.id)

  firstPlayer.sendMsg({
    'action': 'new_game',
    'data': secondPlayer.name
  })
  secondPlayer.sendMsg({
    'action': 'new_game',
    'data': firstPlayer.name
  })
}

// ---------------------------------------------------------
// Deal cards
// ---------------------------------------------------------
function DealCards(player) {
  let opponent = Players[player.opponentIndex]
  // wait until opponent ready
  if (opponent.state != PLAYERSTATES.ready) return
  const maxValue = 12
  const splitSize = 10
  // Generate cards
  let allCardsVal = Array.from(Array(maxValue).keys()).map(v => v + 1)
  allCardsVal = _shuffle(allCardsVal.concat(allCardsVal))

  // sort cards according to values
  let cards1 = allCardsVal.slice(0, splitSize).sort((v, v2) => v - v2)
  let cards2 = allCardsVal.slice(splitSize, splitSize * 2).sort((v, v2) => v - v2)

  player.cards = cards1.map(v => {
    return {
      show: 0,
      value: v
    }
  })

  opponent.cards = cards2.map(v => {
    return {
      show: 0,
      value: v
    }
  })
  updateCards(player)
  console.log('New Game')
}

// ---------------------------------------------------------
// Check guess result
// ---------------------------------------------------------
function checkGuess(player, data) {
  let opponent = Players[player.opponentIndex]
  let index = parseInt(data.split(',')[0])
  let guessNum = parseInt(data.split(',')[1])
  if (guessNum == opponent.cards[index]['value']) {
    opponent.cards[index]['show'] = 1
    updateCards(player)
    player.sendMsg({
      'action': 'hint_update',
      'data': 'Correct! Continue guessing or skip this round.'
    })
    player.sendMsg({
      'action': 'show_skip',
      'data': true
    })
  } else {
    player.sendMsg({
      'action': 'hint_update',
      'data': 'Guessed wrong! Turn over one of your card.'
    })
  }
}


// ---------------------------------------------------------
// Unfold players' own cards
// ---------------------------------------------------------
function punish(player, data) {
  let index = parseInt(data)
  player.cards[index]['show'] = 1
  updateCards(player)
}

// ---------------------------------------------------------
// Update card display state
// ---------------------------------------------------------
function updateCards(player) {
  let opponent = Players[player.opponentIndex]
  player.sendMsg({
    'action': 'cards_update',
    'data': {
      'myCard': player.cards,
      'opponentsCard': opponent.cards
    }
  })
  opponent.sendMsg({
    'action': 'cards_update',
    'data': {
      'myCard': opponent.cards,
      'opponentsCard': player.cards
    }
  })
}

// ---------------------------------------------------------
// Shuffle array helper function
// ---------------------------------------------------------
function _shuffle(array) {
  var currentIndex = array.length,
    randomIndex;

  // While there remain elements to shuffle...
  while (0 !== currentIndex) {

    // Pick a remaining element...
    randomIndex = Math.floor(Math.random() * currentIndex);
    currentIndex--;

    // And swap it with the current element.
    [array[currentIndex], array[randomIndex]] = [
      array[randomIndex], array[currentIndex]
    ];
  }

  return array;
}
