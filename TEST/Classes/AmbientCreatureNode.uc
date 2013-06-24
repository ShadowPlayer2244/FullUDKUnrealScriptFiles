class AmbientCreatureNode extends Info placeable;

var float Radius;

var() Const EditConst DrawSphereComponent RadiusComponent;

function PreBeginPlay()
{
	Radius = RadiusComponent.SphereRadius;
	Super.PreBeginPlay();
}



DefaultProperties
{

	Begin Object Class=DrawSphereComponent Name=DrawSphere0
		SphereColor=(B=255,G=70,R=64,A=255)
		SphereRadius=128.000000
		End Object

	RadiusComponent=DrawSphere0
	Components.Add(DrawSphere0);

	Radius = 128;

}
