class Vampire extends UDKGame
	config(Game)
	
defaultproperties
{
	HUDType=class'UTGame.UTHUD'
	PlayerControllerClass=class'UTGame.UTPlayerController'
	ConsolePlayerControllerClass=class'UTGame.UTConsolePlayerController'
	DefaultPawnClass=class'UTPawn'
	PlayerReplicationInfoClass=class'UTGame.UTPlayerReplicationInfo'
	GameReplicationInfoClass=class'UTGame.UTGameReplicationInfo'
	DeathMessageClass=class'UTDeathMessage'
	PopulationManagerClass=class'UTPopulationManager'
	BotClass=class'UTBot'
}