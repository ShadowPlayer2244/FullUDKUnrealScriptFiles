class AmbientCreature extends Actor;


var() array<AmbientCreatureNode> MyNodes;

var float MinTravelTime, MaxTravelTime;

var float Speed;

var float MinSize,MaxSize;


function PostBeginPlay()
{
	local Float RandVal;

	Super.PostBeginPlay();
	
	RandVal = RandRange(0.5,1.5);
	Speed *=RandVal;
	RotationRate *=RandVal;

	SetDrawScale(RandRange(MinSize,MaxSize));

	SetRandDest();

}

function Tick(Float DeltaTime)
{
	

	Super.Tick(DeltaTime);
	
	Velocity = Normal(Vector(Rotation))*Speed;
}




function SetRandDest()
{
	local int Idx;
	local AmbientCreatureNode DestNode;
	local float MoveInterval;

	Idx = Rand(MyNodes.Length);

	DestNode = MyNodes[Idx];
	SetDest(DestNode);

	MoveInterval = VSize(DestNode.Location - Location) / Speed;
	
	SetTimer(RandRange(MinTravelTime,FMin(MaxTravelTime,MoveInterval)),false,'SetRandDest');



}

function SetDest(AmbientCreatureNode inNode)
{
	local Vector MoveDirection,MoveOffset;

	MoveOffset = Normal(VRand()) * inNode.Radius;

	MoveDirection = (inNode.Location + MoveOffset) - Location;
	DesiredRotation = Rotator(MoveDirection);

	
	
}




DefaultProperties
{
	
	Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		End Object

	Components(0)=MyLightEnvironment

	Begin Object Class=StaticMeshComponent Name=MyStaticMesh
		LightEnvironment=MyLightEnvironment
		End Object

	Components(1)=MyStaticMesh

	CollisionComponent=MyStaticMesh

	bCollideWorld=True

	Physics=PHYS_Projectile

	bStatic=False
	bMovable=True
	
	
}
