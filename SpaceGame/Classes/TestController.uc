class TestController extends AIController;

var Pawn player;

event Possess(Pawn inPawn, bool bVehicleTransition)
{
  super.Possess(inPawn, bVehicleTransition);
  //initialize Pawn Physics
  inPawn.SetMovementPhysics();
}
auto state Idle
{
   event SeePlayer(Pawn Seen)
   {      
     super.SeePlayer(Seen);
     player = Seen;
     GotoState('Chasing');
   }
}
state Chasing
{
   Begin:
      MoveToward(player); 
      goto 'Begin';
}