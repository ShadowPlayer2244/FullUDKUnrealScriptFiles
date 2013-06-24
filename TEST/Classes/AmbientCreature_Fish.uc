/* AmbientCreature_Fish
 * 
 * Adds Functionality for fish behaviour, including bursts in speed and a mesh for display
 * 
 * 
 * 
 */
class AmbientCreature_Fish extends AmbientCreature placeable;

var bool bFalloff;

var float BurstSpeed, OrigSpeed;

var Rotator BurstRotRate, OrigRotRate;

var int BurstPercent;



function Tick(Float DeltaTime)
{
	
	if(bFalloff)
	{
		Speed -= BurstSpeed * DeltaTime;
		
		RotationRate -= BurstRotRate * DeltaTime;

		if (Speed <= OrigSpeed)
		{
			Speed = OrigSpeed;
			RotationRate = OrigRotRate;
			bFalloff = False;
			ClearTimer('SetRandDest');
			SetRandDest();

		}
	}


	Super.Tick(DeltaTime);
}


function SetRandDest()
{
	if(!bFalloff && Rand(100) < BurstPercent)
	{
		Speed = BurstSpeed;
		RotationRate = BurstRotRate;
		bFalloff = True;
	}

	Super.SetRandDest();
}


function PostBeginPlay()
{
	local Float RandVal;

	Super(Actor).PostBeginPlay();
	
	RandVal = RandRange(0.5,1.5);
	Speed *=RandVal;
	RotationRate *=RandVal;

	OrigRotRate = RotationRate ;
	BurstRotRate = RotationRate * 4;

	OrigSpeed = Speed;
	BurstSpeed = Speed * 4;

	SetDrawScale(RandRange(MinSize,MaxSize) * RandRange(MinSize,MaxSize));

	SetRandDest();

}



DefaultProperties
{
	
	Speed=70

	MinSize=0.12
	MaxSize=0.55

	MinTravelTime=0.25
	MaxTravelTime=4.0
	RotationRate=(Pitch=16384,Yaw=16384,Roll=16384)
	BurstPercent=10

	Begin Object Name=MyStaticMesh
		StaticMesh=StaticMesh'Chapter_06_Functions.ClownFish'
		End Object

}
