class TestVectors extends Actor
      placeable;
     
var vector vDestination;

const SPEED = 100; // UU/Sec (Unreal Unit / Second)
     
function SetNewDestination()
{
    //choose random position
    vDestination.X = -500 + Rand(1001); //-500 to 500
    vDestination.Y = -500 + Rand(1001); //-500 to 500
    vDestination.Z = 150 + Rand(101); //150 to 250
    
    worldinfo.game.broadcast(self, "NEW DESTINATION: " $ vDestination);
}     

event PostBeginPlay()
{
    SetNewDestination();
}

//This function is called every frame by Unreal Engine
event Tick(float DeltaTime)
{   
   local vector vDistance;
   local vector vDirection;
   local vector vVelocity;
   local vector vStep;
   
   vDistance = vDestination - Location;   
   
   //Check if the Actor has reached the destination
   if( VSize( vDistance ) < SPEED )
   {
        SetNewDestination();
        vDistance = vDestination - Location;
   }
   
   vDirection = Normal( vDistance );      
   vVelocity = vDirection * SPEED;
   vStep = vVelocity * DeltaTime;
   Move( vStep );    
}
     
defaultproperties
{        
    begin object Class=StaticMeshComponent Name=Model3D
        StaticMesh = Pickups.UDamage.Mesh.S_Pickups_UDamage        
    end object
    
    Components.add(Model3D);
}    