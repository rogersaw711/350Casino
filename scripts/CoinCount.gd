extends Node2D

class_name CoinCount
var coinCount = 1000

func getCoinCount():
	return coinCount



func setCoins(newCoinCount):
	coinCount = newCoinCount

func addCoins(coinAddAmount):
	coinCount += coinAddAmount

