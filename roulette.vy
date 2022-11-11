#Variables
players: public(DynArray[address,100])
playersTurn: public(uint256)
losers: public(DynArray[address,100])
odds: public(uint256)
creator: public(address)

#Constructor - works
@external
def __init__():
    self.creator = tx.origin#does this work? 
    self.playersTurn = 0


#setOdds - works
@external
def setOdds(oneInThisMany : uint256):
    self.odds = oneInThisMany


#addPlayer - works
@external
def addPlayer(newPlayerAddress : address):
    assert newPlayerAddress not in self.losers
    assert newPlayerAddress not in self.players
    self.players.append(newPlayerAddress)

#lose - 
@internal
def lose(player : address):
    self.losers.append(player)
    for i in self.players:
        self.players.pop()
    self.playersTurn=0

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
    if self.playersTurn!=len(self.players)-1:
        self.playersTurn=self.playersTurn + 1
    if self.playersTurn==len(self.players)-1:
        self.playersTurn=0

#isALoser
@external
def isALoser(person : address) -> (bool):
    return person in self.losers