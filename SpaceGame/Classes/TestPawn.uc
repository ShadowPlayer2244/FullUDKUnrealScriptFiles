class TestPawn extends UTPawn
      placeable;

defaultproperties
{
   begin object class=SkeletalMeshComponent Name=Model3D                
      SkeletalMesh=CH_LIAM_Cathode.Mesh.SK_CH_LIAM_Cathode
      PhysicsAsset=CH_AnimCorrupt.Mesh.SK_CH_Corrupt_Male_Physics
      AnimSets(0)=CH_AnimHuman.Anims.K_AnimHuman_BaseMale
      AnimtreeTemplate=CH_AnimHuman_Tree.AT_CH_Human
   end object

   Components.Add(Model3D);
    
   ControllerClass=SpaceGame.TestController
}