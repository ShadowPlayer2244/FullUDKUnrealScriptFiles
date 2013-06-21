class TestSprite extends Actor
      placeable;
     
defaultproperties
{
   begin object Class=SpriteComponent Name=Image2D
      Sprite = EditorResources.AIScript
      HiddenGame = true
   end object
    
   Components.add(Image2D);
}