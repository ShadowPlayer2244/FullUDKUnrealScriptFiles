class TestMesh extends Actor
	placeable;

DefaultProperties
{
	begin object Class=StaticMeshComponent Name=Model3D
		StaticMesh = Pickups.UDamage.Mesh.S_Pickups_UDamage
	end object

	Components.add(Model3D);
}
