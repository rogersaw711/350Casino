extends Node2D


var coinCount = 1000

func setCoins(newCoinCount):
	coinCount = newCoinCount

func addCoins(coinAddAmount):
	coinCount += coinAddAmount
	print(coinCount)


