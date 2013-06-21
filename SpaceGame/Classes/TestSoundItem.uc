class TestSoundItem extends Actor
      placeable;

event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
   local TestSoundGameInfo testSoundGameInfo;    
   
   testSoundGameInfo = TestSoundGameInfo( worldinfo.game );
   
   if( testSoundGameInfo != None)
   {    
    if( Pawn(Other) != None && Pawn(Other).controller.bIsPlayer )
    {               
        testSoundGameInfo.RemoveItem( self );      
    }
   }
}     
defaultproperties
{        
    bCollideActors=true    
    bBlockActors=false
    
    Begin Object Class=CylinderComponent Name=CylinderComp
        CollisionRadius=20
        CollisionHeight=28
        CollideActors=true        
        BlockActors=false
    End Object    
    Components.Add( CylinderComp )
    CollisionComponent=CylinderComp    
        
    Begin Object Class=DynamicLightEnvironmentComponent Name=LightEnvironmentComp
        bEnabled = true
    End Object    
    Components.add( LightEnvironmentComp )
    
    Begin Object Class=StaticMeshComponent Name=StaticMeshComp
        StaticMesh = Pickups.JumpBoots.Mesh.S_UN_Pickups_Jumpboots002    
        LightEnvironment = LightEnvironmentComp
        Scale = 2
    End Object    
    Components.add( StaticMeshComp )    
}     