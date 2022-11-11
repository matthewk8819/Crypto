#Variables
players: public(address[100])
numPlayers: public(uint256) #num of players to access player array
playersTurn: public(uint256)
playersIn: HashMap[address,bool]#true if player is in game - might be unneeded
losers: public(address[100])
numLosers: public(uint256) #num of losers to access losers array 
odds: public(uint256)
creator: public(address)

#Constructor - works
@external
def __init__():
    self.creator = tx.origin#does this work? 
    self.numPlayers = 0
    self.numLosers = 0
    self.playersTurn = 0


#setOdds - works
@external
def setOdds(oneInThisMany : uint256):
    self.odds = oneInThisMany


#addPlayer - add to players
@external
def addPlayer(newPlayerAddress : address):
    assert newPlayerAddress not in self.losers
    assert newPlayerAddress not in self.players
    self.players[self.numPlayers] = newPlayerAddress
    self.numPlayers = self.numPlayers + 1
    self.playersIn[newPlayerAddress] = True

#lose - 
@internal
def lose(player : address):
    self.losers[self.numLosers]=player
    self.numLosers = self.numLosers + 1
    #clear players in dyn(null) and hash(false) VERY IMPORTANT !!!!!*!*!*!*!*!*
    self.numPlayers = 0
    self.playersTurn = 0
    #find a way to clear the self.players list and self.playersIn (if find one, delete other structure)


#random - works 
@internal
def random() -> uint256:
    return block.timestamp%self.odds


#play
@external
def play():
    num: uint256 = self.random()
    if num==1:
        self.lose(self.players[self.playersTurn])
    self.playersTurn=self.playersTurn + 1