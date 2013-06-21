class TestSoundGameInfo extends UTGame;

var SoundCue itemSound; 
var AudioComponent gameMusic, victoryMusic;
var int itemCount;

function StartMatch()
{
   local TestSoundItem itemLocal;
   
   Super.StartMatch();
   
   itemCount = 0;
   
   //Check how many Items are on the Level
   foreach AllActors( class'TestSoundItem', itemLocal )
   {
      itemCount++;
   }
      
   gameMusic.Play();      
}

function RemoveItem( TestSoundItem item )
{      
   PlaySound( itemSound );
   item.Destroy();
   itemCount--;
   
   if ( itemCount <= 0 ) 
   {
      Broadcast( self, "You collected all the Items.") ;      
      gameMusic.FadeOut( 2, 0 );
      victoryMusic.FadeIn( 2, 1 );
   }
}
defaultproperties
{        
    itemSound = SoundCue'A_Pickups_Powerups.PowerUps.A_Powerup_JumpBoots_PickupCue'
    
    Begin Object Class=AudioComponent Name=Music01Comp
        SoundCue=TestMusic.G_Music.Pumpkin_Party_Cue                
    End Object
    
    gameMusic = Music01Comp        
    
    Begin Object Class=AudioComponent Name=Music02Comp
        SoundCue=A_Music_RomNecris01.MusicSegments.A_Music_RomNecris01_Victory01Cue            
    End Object
        
    victoryMusic = Music02Comp
}